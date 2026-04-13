from flask import Flask, request, jsonify
from roles import Student, Faculty, Admin
from flask_cors import CORS

import os
import shutil
import subprocess
import sys
import tempfile
import threading
import time
from collections import defaultdict, deque
from typing import Tuple

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)

# Hard limits to protect free-tier deployments from request bursts and large payloads.
MAX_REQUEST_BYTES = int(os.environ.get("MAX_REQUEST_BYTES", "200000"))
MAX_SOURCE_CHARS = int(os.environ.get("MAX_SOURCE_CHARS", "50000"))
MAX_STDIN_CHARS = int(os.environ.get("MAX_STDIN_CHARS", "20000"))
RATE_LIMIT_WINDOW_SECONDS = int(os.environ.get("RATE_LIMIT_WINDOW_SECONDS", "60"))
RATE_LIMIT_MAX_REQUESTS = int(os.environ.get("RATE_LIMIT_MAX_REQUESTS", "20"))
MAX_CONCURRENT_EXECUTIONS = int(os.environ.get("MAX_CONCURRENT_EXECUTIONS", "6"))

app.config["MAX_CONTENT_LENGTH"] = MAX_REQUEST_BYTES

_execution_slots = threading.BoundedSemaphore(max(1, MAX_CONCURRENT_EXECUTIONS))
_rate_limit_lock = threading.Lock()
_rate_limit_buckets = defaultdict(deque)


@app.route('/dashboard', methods=['POST'])
def dashboard():
    data = request.json
    username = data.get("username")
    email = data.get("email")
    role = data.get("role")

    role_map = {
        "student": Student,
        "faculty": Faculty,
        "admin": Admin
    }

    if role.lower() not in role_map:
        return jsonify({"error": "Invalid role"}), 400

    user_class = role_map[role.lower()]
    user = user_class(username, email)
    return jsonify(user.get_dashboard())


def _run(cmd, cwd: str, stdin: str, timeout_s: int) -> Tuple[int, str, str]:
    proc = subprocess.run(
        cmd,
        cwd=cwd,
        input=stdin.encode("utf-8"),
        stdout=subprocess.PIPE,
        stderr=subprocess.PIPE,
        timeout=timeout_s,
        check=False,
    )
    return proc.returncode, proc.stdout.decode("utf-8", errors="replace"), proc.stderr.decode("utf-8", errors="replace")


def _client_ip() -> str:
    xff = (request.headers.get("X-Forwarded-For") or "").strip()
    if xff:
        return xff.split(",")[0].strip()
    return (request.remote_addr or "unknown").strip()


def _check_rate_limit(ip: str) -> Tuple[bool, int]:
    now = time.time()
    window_start = now - RATE_LIMIT_WINDOW_SECONDS
    with _rate_limit_lock:
        bucket = _rate_limit_buckets[ip]
        while bucket and bucket[0] < window_start:
            bucket.popleft()

        if len(bucket) >= RATE_LIMIT_MAX_REQUESTS:
            retry_after = max(1, int(bucket[0] + RATE_LIMIT_WINDOW_SECONDS - now))
            return False, retry_after

        bucket.append(now)

        # Periodic cleanup to avoid unbounded memory growth.
        if len(_rate_limit_buckets) > 5000:
            stale_ips = [k for k, q in _rate_limit_buckets.items() if not q or q[-1] < window_start]
            for k in stale_ips:
                _rate_limit_buckets.pop(k, None)

    return True, 0


@app.route('/execute', methods=['POST'])
def execute():
    """Execute code in a given language and return captured stdout.

    SECURITY WARNING:
    This is NOT a secure sandbox. Do not expose this endpoint publicly without containerization,
    strict resource limits, filesystem isolation, and network restrictions.
    """
    ip = _client_ip()
    allowed, retry_after = _check_rate_limit(ip)
    if not allowed:
        return jsonify({
            'result': '',
            'stdout': '',
            'stderr': 'Rate limit exceeded',
            'error': 'Rate limit exceeded',
            'retryAfterSeconds': retry_after,
            'exitCode': 429,
        }), 429

    if not _execution_slots.acquire(blocking=False):
        return jsonify({
            'result': '',
            'stdout': '',
            'stderr': 'Server busy. Try again shortly.',
            'error': 'Server busy. Try again shortly.',
            'exitCode': 429,
        }), 429

    data = request.get_json(silent=True) or {}
    code = (data.get('code') or '').replace('\r\n', '\n')
    language = (data.get('language') or 'python').lower()
    stdin = (data.get('input') or data.get('stdin') or '').replace('\r\n', '\n')

    if not code.strip():
        _execution_slots.release()
        return jsonify({'result': '', 'stdout': '', 'stderr': 'Empty code', 'error': 'Empty code', 'exitCode': 1}), 400

    if len(code) > MAX_SOURCE_CHARS:
        _execution_slots.release()
        return jsonify({'result': '', 'stdout': '', 'stderr': 'Code too large', 'error': 'Code too large', 'exitCode': 413}), 413

    if len(stdin) > MAX_STDIN_CHARS:
        _execution_slots.release()
        return jsonify({'result': '', 'stdout': '', 'stderr': 'Input too large', 'error': 'Input too large', 'exitCode': 413}), 413

    timeout_s = int(os.environ.get('CODE_EXEC_TIMEOUT_SECONDS', '8'))
    timeout_s = min(max(timeout_s, 1), 20)
    exe_name = 'main.exe' if os.name == 'nt' else 'main'

    with tempfile.TemporaryDirectory(prefix='stela_exec_') as td:
        try:
            if language in ('python', 'py'):
                file_path = os.path.join(td, 'main.py')
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(code)
                exit_code, out, err = _run([sys.executable, file_path], cwd=td, stdin=stdin, timeout_s=timeout_s)

            elif language in ('javascript', 'js', 'node'):
                if shutil.which('node') is None:
                    return jsonify({'result': '', 'stdout': '', 'stderr': 'node not installed', 'error': 'node not installed', 'exitCode': 127}), 400
                file_path = os.path.join(td, 'main.js')
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(code)
                exit_code, out, err = _run(['node', file_path], cwd=td, stdin=stdin, timeout_s=timeout_s)

            elif language in ('cpp', 'c++'):
                compiler = None
                if shutil.which('g++') is not None:
                    compiler = 'g++'
                elif shutil.which('clang++') is not None:
                    compiler = 'clang++'

                if compiler is None:
                    return jsonify({'result': '', 'stdout': '', 'stderr': 'C++ compiler not installed (g++ or clang++)', 'error': 'C++ compiler not installed (g++ or clang++)', 'exitCode': 127}), 400
                src = os.path.join(td, 'main.cpp')
                exe = os.path.join(td, exe_name)
                with open(src, 'w', encoding='utf-8') as f:
                    f.write(code)
                c_exit, c_out, c_err = _run([compiler, '-std=c++17', '-O2', src, '-o', exe], cwd=td, stdin='', timeout_s=timeout_s)
                if c_exit != 0:
                    return jsonify({'result': '', 'stdout': c_out, 'stderr': c_err, 'error': c_err, 'exitCode': c_exit}), 200
                exit_code, out, err = _run([exe], cwd=td, stdin=stdin, timeout_s=timeout_s)

            elif language in ('c',):
                compiler = None
                if shutil.which('gcc') is not None:
                    compiler = 'gcc'
                elif shutil.which('clang') is not None:
                    compiler = 'clang'

                if compiler is None:
                    return jsonify({'result': '', 'stdout': '', 'stderr': 'C compiler not installed (gcc or clang)', 'error': 'C compiler not installed (gcc or clang)', 'exitCode': 127}), 400
                src = os.path.join(td, 'main.c')
                exe = os.path.join(td, exe_name)
                with open(src, 'w', encoding='utf-8') as f:
                    f.write(code)
                c_exit, c_out, c_err = _run([compiler, '-O2', src, '-o', exe], cwd=td, stdin='', timeout_s=timeout_s)
                if c_exit != 0:
                    return jsonify({'result': '', 'stdout': c_out, 'stderr': c_err, 'error': c_err, 'exitCode': c_exit}), 200
                exit_code, out, err = _run([exe], cwd=td, stdin=stdin, timeout_s=timeout_s)

            elif language in ('java',):
                if shutil.which('javac') is None or shutil.which('java') is None:
                    return jsonify({'result': '', 'stdout': '', 'stderr': 'javac/java not installed', 'error': 'javac/java not installed', 'exitCode': 127}), 400
                # Require a public class Main for simplicity.
                src = os.path.join(td, 'Main.java')
                with open(src, 'w', encoding='utf-8') as f:
                    f.write(code)
                c_exit, c_out, c_err = _run(['javac', src], cwd=td, stdin='', timeout_s=timeout_s)
                if c_exit != 0:
                    return jsonify({'result': '', 'stdout': c_out, 'stderr': c_err, 'error': c_err, 'exitCode': c_exit}), 200
                exit_code, out, err = _run(['java', '-cp', td, 'Main'], cwd=td, stdin=stdin, timeout_s=timeout_s)

            elif language in ('dart',):
                # Optional: only works if Dart SDK is installed on the host.
                if shutil.which('dart') is None:
                    return jsonify({'result': '', 'stdout': '', 'stderr': 'dart not installed', 'error': 'dart not installed', 'exitCode': 127}), 400
                src = os.path.join(td, 'main.dart')
                with open(src, 'w', encoding='utf-8') as f:
                    f.write(code)
                exit_code, out, err = _run(['dart', src], cwd=td, stdin=stdin, timeout_s=timeout_s)

            else:
                return jsonify({'result': '', 'stdout': '', 'stderr': f'Unsupported language: {language}', 'error': f'Unsupported language: {language}', 'exitCode': 2}), 400

            # Keep compatibility with existing clients expecting 'result'
            return jsonify({'result': out, 'stdout': out, 'stderr': err, 'error': err if exit_code != 0 else '', 'exitCode': exit_code}), 200

        except subprocess.TimeoutExpired:
            return jsonify({'result': '', 'stdout': '', 'stderr': 'Time limit exceeded', 'error': 'Time limit exceeded', 'exitCode': 124}), 200
        except Exception as e:
            return jsonify({'result': '', 'stdout': '', 'stderr': str(e), 'error': str(e), 'exitCode': 1}), 200
        finally:
            _execution_slots.release()

if __name__ == '__main__':
    # For local development you can set FLASK_DEBUG=1.
    debug = os.environ.get('FLASK_DEBUG', '').strip() in ('1', 'true', 'yes')
    port = int(os.environ.get('PORT', '5000'))
    app.run(host='0.0.0.0', port=port, debug=debug)

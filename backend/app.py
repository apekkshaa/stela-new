from flask import Flask, request, jsonify
from roles import Student, Faculty, Admin
from flask_cors import CORS

import os
import shutil
import subprocess
import tempfile
from typing import Tuple

app = Flask(__name__)
CORS(app, resources={r"/*": {"origins": "*"}}, supports_credentials=True)


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


@app.route('/execute', methods=['POST'])
def execute():
    """Execute code in a given language and return captured stdout.

    SECURITY WARNING:
    This is NOT a secure sandbox. Do not expose this endpoint publicly without containerization,
    strict resource limits, filesystem isolation, and network restrictions.
    """
    data = request.get_json(silent=True) or {}
    code = (data.get('code') or '').replace('\r\n', '\n')
    language = (data.get('language') or 'python').lower()
    stdin = (data.get('input') or data.get('stdin') or '').replace('\r\n', '\n')

    if not code.strip():
        return jsonify({'result': '', 'stdout': '', 'stderr': 'Empty code', 'error': 'Empty code', 'exitCode': 1}), 400

    timeout_s = int(os.environ.get('CODE_EXEC_TIMEOUT_SECONDS', '8'))
    exe_name = 'main.exe' if os.name == 'nt' else 'main'

    with tempfile.TemporaryDirectory(prefix='stela_exec_') as td:
        try:
            if language in ('python', 'py'):
                file_path = os.path.join(td, 'main.py')
                with open(file_path, 'w', encoding='utf-8') as f:
                    f.write(code)
                exit_code, out, err = _run(['python', file_path], cwd=td, stdin=stdin, timeout_s=timeout_s)

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

if __name__ == '__main__':
    # For local development you can set FLASK_DEBUG=1.
    debug = os.environ.get('FLASK_DEBUG', '').strip() in ('1', 'true', 'yes')
    port = int(os.environ.get('PORT', '5000'))
    app.run(host='0.0.0.0', port=port, debug=debug)

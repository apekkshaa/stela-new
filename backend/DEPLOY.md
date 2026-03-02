# Deploying the `/execute` backend

This backend runs student/faculty code for grading.

**Security warning**: as written, this is **not** a secure sandbox. Only deploy it if you add proper isolation (container/VM sandboxing, no outbound network, strict CPU/memory limits, filesystem isolation, request auth/rate limiting).

## Local Docker run

From the `backend/` folder:

1. Build:

```bash
docker build -t stela-exec-backend .
```

2. Run:

```bash
docker run --rm -p 8080:8080 \
  -e CODE_EXEC_TIMEOUT_SECONDS=8 \
  stela-exec-backend
```

3. Test:

```bash
curl -s http://localhost:8080/execute \
  -H "Content-Type: application/json" \
  -d '{"language":"python","code":"print(1+2)","input":""}'
```

## Point the Flutter app to the deployed backend

When you run the Flutter app, pass:

```bash
flutter run -d chrome --dart-define=CODE_EXEC_ENDPOINT=https://YOUR_DOMAIN/execute
```

For a deployed web build:

```bash
flutter build web --dart-define=CODE_EXEC_ENDPOINT=https://YOUR_DOMAIN/execute
```

## Notes

- Java requires the submitted code to declare `public class Main` (see backend/app.py).
- If your host doesn’t have Node/JDK/C++ toolchain installed, JS/Java/C/C++ will fail.
- The Dockerfile includes Node + GCC/G++ + default-jdk for convenience.

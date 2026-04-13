# STELA Monorepo

This repository is split into separate frontend and backend apps:

- `frontend/` -> Flutter Web/mobile app
- `backend/` -> Flask code execution API (`/execute`)

## Local Development

### Frontend (Flutter)

```bash
cd frontend
flutter pub get
flutter run -d chrome \
	--dart-define=CODE_EXEC_ENDPOINT=http://localhost:8080/execute
```

### Backend (Flask)

```bash
cd backend
pip install -r requirements.txt
gunicorn -w 2 -b 0.0.0.0:8080 app:app
```

## Deploy Frontend to Vercel

Set the Vercel project root to `frontend`.

- Root Directory: `frontend`
- Build Command: `flutter build web --release`
- Output Directory: `build/web`
- Environment Variable:
	- `CODE_EXEC_ENDPOINT=https://<your-render-service>.onrender.com/execute`

## Deploy Backend to Render

Create a Web Service from this repo using:

- Root Directory: `backend`
- Runtime: `Docker` (recommended since this app needs Node/GCC/JDK too)
- Exposed port: `8080`
- Environment variable:
	- `CODE_EXEC_TIMEOUT_SECONDS=6`
	- `MAX_CONCURRENT_EXECUTIONS=6`
	- `RATE_LIMIT_MAX_REQUESTS=20`
	- `RATE_LIMIT_WINDOW_SECONDS=60`
	- `MAX_REQUEST_BYTES=200000`
	- `MAX_SOURCE_CHARS=50000`
	- `MAX_STDIN_CHARS=20000`

The backend endpoint will be:

`https://<your-render-service>.onrender.com/execute`

Use that URL as `CODE_EXEC_ENDPOINT` for the frontend deployment.

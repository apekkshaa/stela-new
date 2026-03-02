# System Architecture — Stela App

This document contains a visual diagram and explanatory notes for the Stela app's architecture. The SVG diagram file is at `docs/architecture_diagram.svg`.

## Quick summary

- Client: Flutter app (multi-platform) — UI screens, quiz-taking flows, faculty review UIs.
- Auth: Firebase Authentication — user identity (UID used for deterministic shuffling).
- Quiz content: Firebase Realtime Database (`/quizzes`) — canonical source of quiz content authored by faculty.
- Submissions & metadata: Cloud Firestore (`quiz_submissions`, `students`) — persistent storage for attempts, student metadata, exports.
- Storage: Firebase Storage for files and assets (optional).
- Backend: Local/admin Python scripts (e.g., `backend/fix_quiz_submissions.py`) used for maintenance tasks.

## Main data flows

- Read quiz content from RTDB (client-side `QuizService`).
- Student/faculty quiz attempts are saved to Firestore `quiz_submissions` by the client (faculty-enabled flow);
  submissions include `quizData`, `attemptQuestions`, `answers`, `correctAnswers`, `percentage`, `timeTakenSeconds`, `timestamp`.
- Faculty UIs stream Firestore submissions (`.snapshots()`) for live review and export to XLSX.
- Admin scripts can query and fix documents in Firestore (e.g., populate missing `facultyId`).

## Files of interest

- `lib/services/quiz_service.dart` — RTDB initialization and quiz parsers.
- `lib/screens/quizzes.dart` — student quiz UI and local scoring logic.
- `lib/screens/faculty_quiz_taking_screen.dart` — faculty-enabled quiz flow that persists submissions.
- `lib/screens/faculty_quiz_submissions_list.dart` and `lib/screens/faculty_submissions_manage.dart` — viewing and exporting submissions.
- `backend/fix_quiz_submissions.py` — Firestore maintenance script.

## Next steps / suggestions

- If you want a PNG/PNG export of the SVG, I can generate one or give commands to convert SVG → PNG (requires local tools like `rsvg-convert` or `inkscape`).
- I can also produce a higher-fidelity diagram (Graphviz/PlantUML) or generate a Mermaid diagram for embedding.
- Want me to: (a) add this diagram into your README, (b) create a PNG export, or (c) produce a PlantUML version?


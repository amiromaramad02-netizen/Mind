# FocusFlow

FocusFlow is a premium Flutter productivity app built around the Pomodoro Technique. It combines focus sessions, task planning, habit streaks, analytics, gamification, local notifications, and an AI-assistant abstraction in a clean feature-first architecture.

## Current Stack

- Flutter 3.41 stable / Dart 3.11
- Riverpod for dependency injection and state management
- GoRouter for navigation
- Hive for offline-first local persistence
- Flutter Local Notifications and Workmanager-ready background architecture
- FL Chart, Flutter Animate, Lottie, Google Fonts, and Material 3
- Firebase/Auth package dependencies are included for production integration

## Features Implemented

- Onboarding with animated, skippable pages
- Mockable authentication repository for email, Google, Apple, and guest-style future flows
- Home dashboard with focus goal, quote, task preview, habit preview, and quick timer entry
- Pomodoro engine with 25/5/20 cycle automation, four-session long-break logic, pause/resume/reset/skip, persisted focus session history, notification hooks, and background-time accurate countdown math
- Task management with add/delete/complete, priority model, tags/categories/subtasks/deadline fields, and Hive-backed offline storage
- Habit tracking with streak calculation and completion history
- Analytics, profile, settings, focus mode, session summary, gamification, focus music, and AI assistant screens/providers
- Light/dark Material 3 theme with premium typography, gradients, glass cards, and animation polish

## Architecture

The app uses a clean, feature-first layout:

```text
lib/
├── config/
├── core/
│   └── services/
├── features/
│   ├── auth/
│   ├── onboarding/
│   ├── home/
│   ├── pomodoro/
│   ├── tasks/
│   ├── analytics/
│   ├── habits/
│   ├── settings/
│   ├── gamification/
│   ├── ai_assistant/
│   └── profile/
├── routes/
├── shared/
├── theme/
└── main.dart
```

Each feature keeps domain models, data repositories, and presentation state/widgets close together. Repository abstractions are intentionally local-first so Firebase, calendar sync, AI APIs, Apple Health, Google Fit, and cloud backup can be added behind interfaces without rewriting UI flows.

## Setup

```bash
flutter pub get
flutter analyze
flutter test
flutter run
```

No code generation step is required for the current implementation.

## Production Notes

- Android and iOS platform folders are present under this Flutter project.
- Local notifications are initialized at startup and can be expanded for reminder scheduling.
- Workmanager scaffolding exists for daily reminders and session recovery tasks.
- Audio hooks are defensive while placeholder audio assets are absent.
- Before App Store or Play Store submission, replace mock auth with Firebase-backed auth, configure signing, app identifiers, icons/splash assets, privacy manifests, notification permission copy, and store metadata.

## Verification

The current project passes:

```bash
flutter analyze
flutter test
```

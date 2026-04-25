# CommitLock

CommitLock is a Flutter-based habit accountability app where users create commitment sessions, run a timer, complete or break sessions with confirmation, and track their session history. The app is designed with a lightweight clean architecture approach, Provider for state management, and Hive for local persistence.

---

## Features

### Completed Features
- Authentication (Login / Signup)
- Commitment session creation
- Timer-based session workflow
- Break session with confirmation dialog
- Session history tracking
- Settings screen
- Dark mode support
- Splash screen
- Home screen (excluding steak tracking feature)
- Action screen for session control
- Offline data storage using Hive

---

## Architecture

The project follows a light Clean Architecture (feature-wise structure) to keep the code modular and scalable.

Each feature contains:
- `data` → data sources and repository implementation
- `domain` → Hive models and data classes
- `presentation` → UI screens and Provider state management

This structure is simplified since the app is small but still follows separation of concerns.

---

## Project Structure


lib/
│
├── core/
│ ├── services/ (Hive service)
│ ├── theme/ (dark/light theme)
│ ├── utils/
│ └── widgets/ (reusable widgets)
│
├── features/
│ ├── auth/
│ ├── commitment/
│ ├── home/
│ ├── history/
│ ├── settings/
│ └── splash/
│
└── main.dart


---

## State Management

- Provider
- Used for:
  - Authentication state
  - Timer/session logic
  - Theme management (dark mode)
  - History updates
  - Settings handling

---

## Local Database

- Hive 
- Used for:
  - Storing commitment sessions
  - Saving session history
  - Maintaining offline persistence

---

## Setup Instructions

### 1. Clone repository
```bash
git clone https://github.com/Fathimathnishma/CommitLock.git
cd commitlock
2. Install dependencies
flutter pub get
3. Generate Hive adapters (if required)
flutter packages pub run build_runner build
4. Run application
flutter run



iOS Build Information
Tested on: Android only
iOS build compatibility: Not tested (no macOS environment available)
iOS-specific notes:
App has been fully developed and tested only on Android.
iOS build has not been generated.
No iOS-specific configurations (Info.plist / CocoaPods) have been tested.
Known iOS limitations:
iOS compatibility is unverified
May require platform-specific fixes if built on macOS
iOS experience:
No iOS development or deployment experience
Android-only development workflow



Known Limitations
Steak tracking feature not implemented
No cloud sync (fully offline app)
Timer recovery after app kill is basic
iOS not tested
No push notifications
Minimal backend validation/error handling

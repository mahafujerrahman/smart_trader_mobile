# SmartTrader Mobile

A production-quality Flutter mobile application for professional forex traders. Built as a technical test assignment.

---

## 📱 Features

| Feature | Description |
|---|---|
| **Authorization** | Dual-service auth (Peanut + Partner), token persistence, re-auth, logout |
| **User Profile** | Account info, trading stats, masked phone number display |
| **Signals Archive** | Historical trading signals with currency pair & date range filters |
| **Promo Materials** | Company promotions via SOAP API with external link navigation |

---

## ⏱ Time Estimation & Actual

| | Time |
|---|---|
| **Estimated** | 10–12 hours |
| **Actual** | ~11 hours |

---

## 🏗 Architecture

The app follows **Clean Architecture** with a **feature-first** project structure.

```
lib/
├── app/
│   ├── config/        # App-wide constants, colors, styles, icons
│   ├── core/          # Network client, router, error handling, shared widgets
│   └── helpers/       # SharedPreferences wrapper, date/time utilities
├── features/
│   ├── auth/          # Login flow
│   ├── profile/       # User profile screen
│   ├── signals/       # Signals archive screen
│   ├── promo/         # Promo materials screen
│   └── shell/         # Bottom navigation shell
└── common_model/      # Shared data models
```

Each feature is organized into three layers:

```
feature/
├── data/
│   ├── datasources/   # Remote API calls
│   ├── models/        # JSON ↔ Dart model mapping
│   └── repositories/  # Repository implementations
├── domain/
│   ├── entities/      # (optional) pure domain objects
│   └── repositories/  # Abstract repository contracts
└── presentation/
    ├── cubit/         # BLoC/Cubit state management
    └── views/         # UI screens and widgets
```

---

## 🛠 Technical Decisions

### State Management — BLoC/Cubit
Cubit was chosen over full BLoC because the app does not require complex event-driven logic. Each screen has a dedicated Cubit with clearly defined states (Initial, Loading, Loaded, Error, Empty).

### Navigation — go_router
`go_router` provides declarative routing with deep link support, auth-aware redirect guards, and `ShellRoute` for the bottom navigation tab structure.

### Networking
- **Peanut Service (REST)**: Direct `http` calls with custom response handling — the API returns raw booleans and string tokens (not standard JSON objects), requiring careful decoding.
- **Partner Service (REST + GET)**: `http` GET with `passkey` header for signals; POST for token retrieval.
- **Promo Service (SOAP)**: Custom XML parsing via the `xml` package.

### Persistence — shared_preferences
Login credentials (login + password) and tokens (peanut, partner) are persisted locally to support app restart without re-login.

### Error Handling
All async operations catch: `SocketException`, `TimeoutException`, `AuthFailure`, `ServerFailure`, `NetworkFailure`, and generic exceptions. User-friendly messages are shown via SnackBar / Error widgets with retry capability.

### UI
- Dark theme with teal (`#00D4AA`) accent color
- `flutter_screenutil` for responsive sizing
- Shimmer loading skeletons
- Animated entry transitions
- `cached_network_image` for promo images

---

## 🧩 Additional Questions

### Q1: How would you organize a reusable verification module shared across multiple mobile apps?

**Approach: Federated Plugin / Shared Package**

```
packages/
└── verification_module/
    ├── lib/
    │   ├── domain/           # Abstract VerificationRepository
    │   ├── data/             # Remote data source implementations
    │   ├── presentation/     # Cubit + generic UI widgets
    │   └── verification_module.dart   # Public API
    └── pubspec.yaml
```

Each consuming app imports the package and provides concrete implementations via constructor injection:
```dart
VerificationFlow(
  repository: MyAppVerificationRepository(),
  onSuccess: (token) => myRouter.go('/home'),
  onFailure: (msg) => showError(msg),
)
```

The module exposes a **VerificationFlow** widget (or a `GoRouter` sub-route tree) that handles all the verification UI internally, keeping the consumer app decoupled from internal screens.

---

### Q2: Architectural approaches for such a module

- **Clean Architecture**: Strict separation of data/domain/presentation layers within the package
- **Interface-based DI**: The module defines abstract repositories; apps provide implementations → enables mocking/testing and multi-app reuse
- **BLoC/Cubit internally**: State management stays inside the module, consumers only observe outcomes
- **Callback-driven API**: The module communicates back via callbacks (`onSuccess`, `onFailure`, `onExpired`) rather than coupling to any specific routing solution
- **Config object pattern**: A `VerificationConfig` class holds customizable parameters (colors, strings, timeout durations) so the module can be white-labeled across apps

---

### Q3: Dependency isolation and navigation flow

**Dependency Isolation**
- Use Dart's `get_it` service locator (or manual constructor injection) scoped to the module's lifetime
- The module's internal dependencies (HTTP client, storage) are created inside the module with optional override via constructor parameters
- Never expose internal implementation types in the public API surface

**Navigation Flow**
```
App Router
└── /auth (ShellRoute or redirect guard)
    └── VerificationFlow (encapsulated route sub-tree)
        ├── /auth/phone-entry
        ├── /auth/otp-verify
        └── /auth/success → callback fires → App pops to /home
```

Using `go_router` sub-routes or a `Navigator` stack that is fully contained within the module. The module receives a `BuildContext` or a `NavigationCallback` to exit back to the host app. This keeps navigation logic inside the module while giving the host full control over what happens after success/failure.

---

## 🚀 Setup & Run

```bash
# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build release APK
flutter build apk --release
```

**Test credentials:**
```
Login: 20234561
Password: ladevi31
```

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `flutter_bloc` | State management (Cubit) |
| `go_router` | Declarative navigation |
| `http` | REST API calls |
| `xml` | SOAP response parsing |
| `shared_preferences` | Session persistence |
| `flutter_screenutil` | Responsive UI sizing |
| `shimmer` | Loading skeleton animations |
| `cached_network_image` | Promo image caching |
| `connectivity_plus` | Network status monitoring |
| `url_launcher` | External link navigation |
| `logger` | Structured debug logging |

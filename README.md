# SmartTrader Mobile

A production-quality Flutter mobile application for professional forex traders. Built as a technical test assignment.

---

## 📱 Features

| Feature | Description |
|---|---|
| **Authorization** | Dual-service auth (Peanut + Partner), token persistence, re-auth, logout |
| **User Profile** | Account info, trading stats, masked phone number display |
| **Signals Archive** | Historical trading signals with trading-system, currency pair & date range filters |
| **Promo Materials** | Company promotions via SOAP API with external link navigation |

---

## ⏱ Time Estimation & Actual

| | Time |
|---|---|
| **Estimated** | 10–12 hours |
| **Actual** | ~11 hours |

---

## 🏗 Architecture

The app follows **Clean Architecture** with a **feature-first** project structure and **GetX** for state management, dependency injection and navigation.

lib/
├── app/
│   ├── bindings/      # App-wide InitialBinding (core services)
│   ├── config/        # App-wide constants, colors, styles, icons
│   ├── core/          # Network client, routes, error handling, shared widgets
│   └── helpers/       # SharedPreferences wrapper, date/time utilities
├── features/
│   ├── auth/          # Login flow
│   ├── profile/       # User profile screen
│   ├── signals/       # Signals archive screen
│   ├── promo/         # Promo materials screen
│   └── shell/         # Bottom navigation shell (HomeShell + HomeController)
└── common_model/      # Shared data models

Each feature is organized into layers:

feature/
├── bindings/          # GetX Bindings — registers the feature's dependencies
├── data/
│   ├── datasources/   # Remote API calls
│   ├── models/        # JSON ↔ Dart model mapping
│   └── repositories/  # Repository implementations
├── domain/
│   └── repositories/  # Abstract repository contracts
└── presentation/
├── controller/    # GetxController (Rx state)
└── views/         # UI screens and widgets

Dependencies point inward only: presentation → domain ← data. The UI never calls an API directly; it talks to a controller, the controller to a repository contract, and the implementation in `data/` performs the actual network call.

---

## 🛠 Technical Decisions

### State Management — GetX
GetX (`get`) is used for state management, dependency injection and routing in one consistent pattern. Each screen has a dedicated `GetxController` exposing reactive (`Rx`) state — loading / loaded / error / empty are modelled explicitly, and the UI rebuilds through `Obx`. Controllers are registered per-route through feature `Bindings` (`Get.lazyPut(..., fenix: true)`), so a feature's dependencies exist only while its route is alive.

### Navigation — GetX named routes
Navigation uses GetX named routes (`GetMaterialApp` + `GetPage` table in `app/core/routes/app_pages.dart`):

- Route names: `/` (splash), `/login`, `/home`, `/home/profile`, `/home/signals`, `/home/promo`
- An `AuthMiddleware` (the GetX equivalent of a redirect guard) protects the authenticated routes: without a stored session the user is redirected to `/login`, and a logged-in user opening `/login` is sent to `/home` instead.
- The three main tabs live in a bottom-navigation shell (`HomeShell`). Tab taps call `HomeController.changeTab(index)`, which navigates with `Get.offAllNamed(...)` to the tab's route (`/home/profile`, `/home/signals`, `/home/promo`), so the selected tab is always derived from the current route.

### Networking
Only the APIs from the provided Postman collection are used — no proxy and no additional backend.

- **Peanut Service (REST)**: `http` POST calls (`IsAccountCredentialsCorrect`, `GetAccountInformation`, `GetLastFourNumbersPhone`). The API returns raw booleans and plain string tokens (not standard JSON objects), so responses are decoded carefully.
- **Partner Service (REST)**: POST `RequestMoblieCabinetApiToken` for the partner token; GET `GetAnalyticSignals/{login}` for signals, with the partner token sent in the `passkey` header. Query parameters: `tradingsystem` (user-selectable 1–10, default 3), `pairs` (comma-separated), `from` / `to` (epoch timestamps).
- **Promo Service (SOAP)**: `GetCCPromo` at `https://api-forexcopy.contentdatapro.com/Services/CabinetMicroService.svc` with `lang=en`. Two server quirks are handled explicitly:
    - The SOAPAction must be `http://tempuri.org/CabinetMicroService/GetCCPromo` (as specified in the WSDL); any other action is rejected by the server with HTTP 500.
    - `GetCCPromoResult` contains a JSON string (with Python-style `False`/`True` literals), which is sanitised and decoded into promo models; promo image URLs are served from `forex-images.ifxdb.com`. The service is slow (~80 s observed), so the SOAP call uses a dedicated 120 s timeout while the JSON APIs keep a 30 s timeout.

### Persistence — shared_preferences
Login and both tokens (Peanut + Partner) are persisted locally via a `PrefsHelper` wrapper over `shared_preferences`, so the session survives an app restart. On an expired/invalid token the stored session is cleared and the user is returned to the login screen to re-authorize; logout clears the session explicitly.

### Error Handling
All async operations map failures to typed `Failure` classes (`AuthFailure`, `ServerFailure`, `NetworkFailure`) and surface user-friendly messages with retry actions instead of raw exceptions. Loading, empty and error states are rendered explicitly on every screen.

### UI
- Dark theme with teal (`#00D4AA`) accent color
- `flutter_screenutil` for responsive sizing
- Shimmer loading skeletons
- Animated entry transitions
- `cached_network_image` for promo images
---

## 🧩 Additional Questions

### Q1: How would you organize a reusable verification module shared across multiple mobile apps?

**Approach: a standalone shared package** (private pub package / monorepo package) that owns the whole verification flow — screens, state and API contracts — and exposes only a small public API:

packages/
└── verification_module/
├── lib/
│   ├── src/
│   │   ├── domain/         # Abstract VerificationRepository + result types
│   │   ├── data/           # Default remote data source implementation
│   │   ├── presentation/   # GetxControllers + generic UI screens
│   │   └── routes/         # The module's own GetPage sub-tree
│   └── verification_module.dart   # Public API — exports ONLY the entry points
└── pubspec.yaml

Each consuming app imports the package, merges the module's routes into its own route table, and supplies only what is app-specific — a repository implementation (or the backend endpoints), branding/config, and what should happen when verification finishes:

// Host app
GetMaterialApp(
getPages: [
...AppPages.routes,
...VerificationModule.pages(
config: VerificationConfig(
primaryColor: AppColors.primaryColor,
supportEmail: 'support@example.com',
),
repository: MyAppVerificationRepository(),
onSuccess: (result) => Get.offAllNamed(AppRoutes.home),
onCancelled: () => Get.back(),
),
],
)

The module runs the full flow internally (phone/code entry → OTP verify → success/failure), and the host app stays decoupled from its internal screens.

### Q2: Architectural approaches for such a module

- **Clean Architecture inside the package**: strict data / domain / presentation separation, so the flow logic and UI can be reused even if a host app only needs the headless (logic-only) part.
- **Interface-based dependency injection**: the module defines abstract contracts (`VerificationRepository`, token storage, analytics/logger); host apps provide implementations. This keeps the module backend-agnostic and makes it fully mockable in tests.
- **State stays inside the module**: the module manages its own state with its own GetX controllers; consumers never reach into them — they only observe the final outcome.
- **Callback-driven public API**: results are reported through callbacks (`onSuccess`, `onFailure`, `onExpired`, `onCancelled`) instead of the module navigating in the host app, so the module never depends on the host's routing solution.
- **Config object pattern**: a single `VerificationConfig` (colors, strings/localization, timeouts, attempt limits) makes the module white-labelable across apps without code changes.

### Q3: Dependency isolation and navigation flow

**Dependency Isolation**
- The module registers its dependencies in its own GetX `Bindings`, attached only to the module's routes — controllers/services are created when the flow is entered and disposed when it is left, so nothing leaks into the host app's DI container.
- Internal types (data sources, models, controllers) live under `src/` and are never exported from the public `verification_module.dart` file; the public surface is only the entry widget/routes, the config class and the result types.
- The module brings its own network/storage abstractions and accepts overrides through its config/constructor, instead of reading the host app's globals or singletons.

**Navigation Flow**

Host app router (GetMaterialApp getPages)
└── Host routes (/, /login, /home, ...)
└── Verification module sub-tree (pages provided by the package)
├── /verify            (entry: phone / code entry)
├── /verify/otp        (OTP verification)
└── /verify/success    → onSuccess callback fires → host navigates to /home

The module owns navigation *inside* its sub-tree (named routes, its own middleware if a step must be guarded), and hands control back to the host exclusively through callbacks at the exit points. This keeps the flow fully encapsulated while the host decides what happens before and after verification.

---

## 🚀 Setup & Run

# Install dependencies
flutter pub get

# Run on device/emulator
flutter run

# Build release APK
flutter build apk --release

**Test credentials:**
Login: 20234561
Password: ladevi31

---

## 📦 Key Dependencies

| Package | Purpose |
|---|---|
| `get` | State management, dependency injection, navigation |
| `http` | REST API calls |
| `xml` | SOAP envelope building / response parsing |
| `shared_preferences` | Session persistence |
| `flutter_screenutil` | Responsive sizing |
| `shimmer` | Loading skeleton animations |
| `flutter_svg` | SVG icons |
| `cached_network_image` | Promo image caching |
| `connectivity_plus` | Network status monitoring |
| `url_launcher` | External link navigation (promo materials) |
| `intl` | Date/number formatting |
| `logger` | Structured debug logging |

> Note: `go_router` is still listed in `pubspec.yaml` from an earlier iteration but is no longer used — navigation is fully handled by GetX. It can be removed safely.

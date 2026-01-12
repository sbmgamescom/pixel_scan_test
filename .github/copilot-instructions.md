# Pixel Scan Test - AI Coding Guidelines

## Project Overview
**Pixel Scan Test** is a Flutter document scanning and editing application with in-app subscription management. The app enables users to scan documents, edit images, and access premium features through RevenueCat integration.

**Key Technologies:**
- Flutter (Dart 3.6.2+) with Material Design 3
- RevenueCat for subscription management
- document_scanner & pro_image_editor plugins
- SharedPreferences for local state persistence

---

## Architecture & Layers

### Core Layer (`lib/src/core/`)
Contains business logic, services, and models shared across the app:

- **Services** (`core/services/`):
  - `SubscriptionService`: Local subscription state (SharedPreferences-backed)
  - `RevenueCatService`: Remote subscription management via RevenueCat API
  - `ImageEditingService`: Wrapper for pro_image_editor integration
  
- **Models** (`core/models/`):
  - `UserSubscriptionInfo` & `SubscriptionModel`: Subscription data types
  - `DocumentModel`: Document metadata

- **Router** (`core/router/AppNavigator`): Custom ChangeNotifier-based navigation (not using GoRouter)

### UI Layer (`lib/src/ui/`)
Screen-level components with View-ViewModel pattern:

- **Home Screen** (`ui/home/`): Document list & scanning interface
- **Onboarding** (`ui/onboarding/`): First-time user experience
- **Paywall** (`ui/paywall/`): Subscription purchase UI
- **PDF** (`ui/pdf/`): Document viewing/editing
- **Subscription** (`ui/subscription/SubscriptionViewModel`): Subscription state management

### Reusable Components (`lib/src/components/`)
- `LoadingOverlay`: Global loading indicator

---

## Critical Patterns

### State Management
**Pattern: Service + StreamController + ChangeNotifier**
- Services expose `Stream<T>` via `StreamController.broadcast()` for reactive updates
- Example: `SubscriptionService.subscriptionStream` & `RevenueCatService.subscriptionStream`
- UI observes streams via `StreamBuilder` or subscribes in ViewModels
- `SubscriptionViewModel` listens to `RevenueCatService.subscriptionStream` and notifies listeners

**Do NOT use:**
- Provider, Bloc, Riverpod (custom patterns preferred)
- `setState()` for service-level state (OK for local widget state)

### Navigation
- `AppNavigator` is a `ChangeNotifier` with `GlobalKey<NavigatorState>`
- Routes: `/home`, `/paywall`, `/pdf`
- Pass arguments as `Map<String, dynamic>` in navigation methods
- Example: `appNavigator.goPaywall(source: 'launch')`

### Image Handling
- **Editing Flow**: `ImageEditingService.openImageEditor()` → returns `Uint8List`
- **Storage**: Original scanned images in temp directory; edited versions saved via `DocumentScanRepository.saveEditedImage()`
- **Display**: `ImageEditingService.buildImageWidget()` with `ValueKey` for gallery

### Subscription Logic
**Dual Service Design:**
1. **SubscriptionService** (local): Quick status checks, works offline
2. **RevenueCatService** (remote): Source of truth, real purchases, cloud sync

**Flow:**
- App boots → initialize `SubscriptionService` (main.dart)
- Behind-the-scenes → initialize `RevenueCatService` if premium needed
- UI listens to `RevenueCatService.subscriptionStream` for real-time changes
- Purchase attempts trigger `RevenueCatService.purchaseProduct()` → user subscription updated
- Custom entitlement key: `'premium'` (set in RevenueCat dashboard)

---

## Key Conventions

### Imports & Organization
- Use relative imports within `lib/src/`
- Prefer importing by layer: `import '../../core/models/...'` (not absolute package imports)
- Constants in `config/` (e.g., `AppImages`, `AppIcons`)

### Error Handling
- Services catch and log errors with `dart:developer.log()`
- Services provide `errorMessage` getter or throw exceptions
- UI handles errors via try-catch + SnackBar display
- Don't suppress exceptions silently

### Localization
- Russian-language strings in code (comments & error messages)
- Use Material Design localized messages where possible

### Asset Management
- Images in `assets/images/`; Icons in `assets/icons/`
- Reference via `AppImages` class constants (see `config/images.dart`)
- SVG via `flutter_svg` package

### Fonts
- Custom SF Pro Display font family (weights 100-900)
- Set globally in `ThemeData` → available as `fontFamily: 'SF Pro Display'`

---

## Development Workflows

### Running the App
```bash
flutter pub get
flutter run
```

### Debugging Subscriptions
- Check `SharedPreferences` for local state: `isPremium`, `activeProductId`, `expirationDate`
- Monitor RevenueCat logs: `Purchases.setLogLevel(LogLevel.debug)` enabled
- Fake purchases in RevenueCat Sandbox for testing

### Testing
- Use Flutter's built-in test framework
- Mock services via constructor injection (see `SubscriptionViewModel` pattern)
- No production API keys in code (use placeholders + environment configuration)

### Code Analysis
```bash
dart analyze
```

---

## Common Pitfalls

1. **Mixing local & remote state**: Don't query SharedPreferences after RevenueCat purchase—always use RevenueCat as source of truth
2. **Navigation state loss**: AppNavigator.navigatorKey must not be recreated mid-session
3. **Memory leaks**: Unsubscribe from StreamController in `dispose()`; SubscriptionViewModel cancels `_subscriptionSubscription`
4. **Product ID mismatch**: RevenueCat product IDs (e.g., `weekly_premium`) must match iOS/Android store configurations
5. **Expired subscription checks**: Manually validate `expirationDate.isBefore(DateTime.now())` in SubscriptionService

---

## Key Files to Know

- [main.dart](../main.dart): App entry, service initialization
- [core/services/subscription_service.dart](../lib/src/core/services/subscription_service.dart): Local subscription state
- [core/services/revenue_cat_service.dart](../lib/src/core/services/revenue_cat_service.dart): Remote subscription source of truth
- [core/router/app_navigator.dart](../lib/src/core/router/app_navigator.dart): Custom navigation controller
- [ui/subscription/viewmodel/subscription_viewmodel.dart](../lib/src/ui/subscription/viewmodel/subscription_viewmodel.dart): Example of service + stream integration
- [ui/paywall/paywall_screen.dart](../lib/src/ui/paywall/paywall_screen.dart): Purchase UI example
- [core/repositories/document_scan_repository.dart](../lib/src/core/repositories/document_scan_repository.dart): Document plugin wrapper

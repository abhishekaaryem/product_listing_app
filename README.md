# product_listing_app

Developer Guide — product_listing_app

This repository contains a Flutter mobile application. The app uses modern
patterns suitable for production: BLoC for state management, GetIt for
dependency injection, and SharedPreferences for lightweight local storage.

Purpose of this README
- Provide a practical onboarding guide for new developers.
- Explain project structure, key files, and common workflows.

---

Table of contents
- Quick start (run the app)
- Project structure overview
- Key concepts and patterns
	- Dependency Injection
	- BLoC architecture
	- Models and immutability
- Major features and where to look
	- Auth (login flow)
	- Splash and app bootstrap
	- Home (products, banners)
	- Wishlist (add/remove)
	- Profile (logout)
	- Navigation (animated bottom nav)
- Common development tasks
	- Adding a new feature
	- Adding tests
	- Debugging and logging
- Running CLI commands and tests
- Troubleshooting
- Contributing guidelines

---

Quick start (run the app)

1. Requirements
	 - Flutter SDK (stable). Check your version with `flutter --version`.
	 - Android or iOS toolchain for device/emulator work.

2. Install packages

```bash
cd /path/to/product_listing_app
flutter pub get
```

3. Run the app

```bash
# Run on a connected device/emulator
flutter run

# Run tests
flutter test
```

Project structure overview

Top-level folders you need to know:

- `lib/` — application source code
	- `core/` — shared utilities and app-level wiring
		- `di/` — dependency injection (GetIt) setup (`dependency_injection.dart`)
		- `bloc/` — app-level bloc utilities (e.g., `AppBlocObserver`)
		- `nav_bar/` — navigation cubit for bottom navigation
		- `theme/` — app-wide theme
	- `features/` — feature modules; each feature has its own `bloc`, `repository`, `views`, and `widgets`
	- `main.dart` — app bootstrap: initializes DI and provides global Bloc/Repository providers

- `test/` — unit and widget tests

Key concepts and patterns

Dependency Injection
- Located in `lib/core/di/dependency_injection.dart` using GetIt.
- `main.dart` calls `di.setupLocator()` on startup; repositories and services are registered there.
- In widgets/Blocs prefer using `RepositoryProvider.of<T>(context)` or `di.sl<T>()` (GetIt) to obtain instances — makes testing/mocking easier.

BLoC architecture
- Each feature follows the pattern: `feature/bloc/<feature>_bloc.dart`, `<feature>_event.dart`, `<feature>_state.dart`.
- Blocs are often provided at the app/root level (in `main.dart`) so the state is shared across the app.
- Use `BlocProvider`, `BlocBuilder`, and `BlocListener` to connect UI to Blocs.
- The project sometimes uses optimistic UI updates (e.g., toggling favorites locally before API success) — follow existing patterns if extending that behavior.

Models and immutability
- Models (for example `Product`) are immutable and feature a `copyWith` method. Always `copyWith` when changing a model instance to ensure new state objects are emitted from Blocs.

Major features and where to look

- Auth
	- `lib/features/auth/`
	- `AuthRepository` handles login flow and stores JWT in `SharedPreferences` under the key `jwt_token`.
	- `AuthBloc` orchestrates phone verification, OTP, and name saving.

- Splash
	- `lib/features/splash/`
	- Splash screen waits briefly and then checks for the saved JWT token; if present the app navigates to `/home`, otherwise to `/login`.

- Home
	- `lib/features/home/`
	- `HomeBloc` handles loading banners and products. Product UI is in `widgets/product_card.dart`, which displays an images carousel, pricing, discount badge, rating, caption, stock, product type, and favorite toggle.

- Wishlist
	- `lib/features/wishlist/`
	- `WishlistBloc` manages add/remove calls to the server and emits `WishlistLoaded`. The `HomeBloc` listens for wishlist updates and synchronizes product `isFavorite` fields via an `UpdateFavorites` event.

- Profile
	- `lib/features/profile/`
	- Logout button calls `ProfileRepository.clearJwtToken()` to remove the JWT and then navigates to `/login`.

- Navigation
	- Bottom navigation uses `NavigationCubit` and an animated pill-style bar is implemented in `lib/features/nav/widget/bottom_nav_bar.dart`.

Common development tasks

Adding a new feature
- Create `lib/features/<your_feature>/` with `bloc/`, `repository/`, `views/`, `widgets/`.
- Register any repositories in `core/di/dependency_injection.dart` and provide Blocs in `main.dart` as needed.

Adding tests
- Use the `test/` folder. For Bloc tests, provide fake repositories or register test instances in GetIt.
- Some widget tests run `MyApp()` directly; ensure `di.setupLocator()` is initialized in the test setup so GetIt registrations exist.

Debugging and logging
- `AppBlocObserver` (registered in `main.dart`) prints transitions and errors for Blocs.
- Repositories log API requests/responses — check logs for troubleshooting.

Running CLI commands and tests

```bash
# install deps
flutter pub get

# static analysis
flutter analyze

# run unit/widget tests
flutter test

# run the app
flutter run
```

Troubleshooting
- "Missing DI registration" in tests: make sure you call `di.setupLocator()` in test setup.
- Splash navigation unexpected: confirm JWT exists in SharedPreferences under `jwt_token`.
- Wishlist UI out-of-sync: verify models are immutable and `copyWith` is used; ensure `WishlistLoaded` triggers `HomeBloc`'s `UpdateFavorites`.

Contributing guidelines (quick)
- Run `flutter analyze` locally before PRs.
- Add tests for any new Bloc logic or complex UI behavior.
- Keep modules self-contained and avoid global mutable state.

Extras I can add (on request)
- `CONTRIBUTING.md` with PR checklist and branch strategy.
- A simple CI workflow (GitHub Actions) running analyze & tests on PRs.
- Small architecture diagram or ASCII flow chart.

If you'd like, I can commit a `CONTRIBUTING.md` and a basic GitHub Actions workflow next.

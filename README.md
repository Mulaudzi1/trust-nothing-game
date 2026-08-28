# Trust Nothing

An original mobile trap-platformer inspired by the deceptive-platformer genre. The goal is simple: reach the exit. The level, however, cannot be trusted.

## Features

- Flutter/Dart mobile-first implementation
- 120-level campaign across 6 worlds
- Touch left/right/jump controls
- Hidden hazards and deceptive exits
- Reusable data-driven level definitions
- Persistent level unlocks and death counter
- Responsive landscape gameplay canvas
- Automated level validation tests
- GitHub Actions analysis, tests and release web build

## Requirements

- Flutter stable with Dart 3.4+
- Android Studio/Android SDK for Android builds
- Xcode on macOS for iOS builds
- Chrome for quick web testing

## First-time setup

The repository intentionally keeps generated platform runner folders out of source. From the repository root run:

```bash
flutter create .
flutter pub get
flutter analyze
flutter test
```

## Run

```bash
flutter devices
flutter run
```

For Chrome:

```bash
flutter run -d chrome
```

For Android, start an emulator or connect a USB-debugging-enabled Android phone and run `flutter run`.

## Release

```bash
flutter build appbundle --release
```

The Android App Bundle is written under `build/app/outputs/bundle/release/`.

## Architecture

- `lib/game/` — game domain, level catalogue and gameplay engine
- `lib/services/` — persistent application services
- `test/` — automated campaign and domain validation
- `.github/workflows/` — continuous integration

## Visual Studio

Flutter itself does not require a `.sln` for Android/iOS development. Visual Studio is used by Flutter when targeting Windows desktop; run `flutter create --platforms=windows .` on Windows to generate the native Windows Visual Studio solution under `windows/`.

## Originality

Trust Nothing does not contain Level Devil source code, artwork, audio, branding, or copied level layouts. It uses the general concept of a deceptive trap-platformer with an original implementation and campaign.

## Status

The source is structured for CI validation. Always confirm the current CI run is green before treating a commit as a release candidate.

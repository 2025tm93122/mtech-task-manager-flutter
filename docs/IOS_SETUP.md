# iOS setup and run guide

## Prerequisites

Use a Mac because iOS Simulator/Xcode builds require macOS.

Install:
- Xcode from the Mac App Store
- Xcode Command Line Tools: `xcode-select --install`
- Flutter stable SDK and add `flutter/bin` to PATH
- CocoaPods: `sudo gem install cocoapods`

Then verify:

```bash
flutter doctor -v
```

Resolve all red items under **Xcode - develop for iOS and macOS**.

## First-time project bootstrap

From the unzipped project directory:

```bash
bash scripts/bootstrap_ios.sh
```

This creates the standard generated `ios/` Flutter runner in a temporary directory and copies only that runner into this project, preserving all assignment code.

## Configure Back4App

```bash
cp .back4app.env.example .back4app.env
open .back4app.env
```

Paste your Back4App Application ID and Client Key. Enable Live Query using `docs/BACK4APP_SETUP.md`.

## Start an iPhone simulator

```bash
open -a Simulator
flutter devices
```

If multiple devices are shown, either run:

```bash
bash scripts/run_ios.sh
```

or pass a device ID:

```bash
bash scripts/run_ios.sh <DEVICE_ID>
```

## Run from Xcode (optional)

After bootstrapping:

```bash
open ios/Runner.xcworkspace
```

Choose an iPhone simulator and press Run. For Flutter `--dart-define` credentials, running via `scripts/run_ios.sh` is simpler and safer.

## Quality checks

```bash
bash scripts/check_project.sh
```

This runs `flutter analyze` and `flutter test`.

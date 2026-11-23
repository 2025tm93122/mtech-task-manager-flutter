#!/usr/bin/env bash
set -euo pipefail

cd "$(dirname "$0")/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "ERROR: Flutter is not installed or not in PATH."
  echo "Install Flutter first, then run this script again."
  exit 1
fi

if ! command -v pod >/dev/null 2>&1; then
  echo "ERROR: CocoaPods is not installed. Run: sudo gem install cocoapods"
  exit 1
fi

if [ ! -d ios ]; then
  echo "Generating the standard Flutter iOS runner without overwriting this project..."
  TMP_DIR="$(mktemp -d)"
  flutter create \
    --platforms=ios \
    --org com.mtech.taskmanager \
    --project-name mtech_task_manager \
    "$TMP_DIR/generated"
  cp -R "$TMP_DIR/generated/ios" ./ios
  rm -rf "$TMP_DIR"
fi

flutter pub get
(
  cd ios
  pod install
)

echo "iOS bootstrap complete."
echo "Next: cp .back4app.env.example .back4app.env, fill your Back4App keys, then bash scripts/run_ios.sh"

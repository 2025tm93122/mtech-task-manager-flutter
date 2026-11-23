#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")/.."

if ! command -v flutter >/dev/null 2>&1; then
  echo "Flutter not found; static project files are present but Flutter checks cannot run on this machine."
  exit 2
fi

flutter pub get
flutter analyze
flutter test

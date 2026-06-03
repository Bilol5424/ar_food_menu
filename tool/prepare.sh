#!/usr/bin/env bash
# Scaffolds the Android platform folder and applies the required permissions.
# Safe to run repeatedly. Run this once before `flutter build apk`.
set -euo pipefail

flutter pub get

# Generate the android/ folder if it does not exist yet (it is git-ignored).
if [ ! -d android ]; then
  flutter create --platforms=android --org com.armenu --project-name ar_food_menu .
fi

python3 tool/patch_manifest.py android/app/src/main/AndroidManifest.xml
echo "Project ready. Next: flutter build apk --release"

#!/bin/bash
# Build HippoShelf.app (河马置物架) as a universal binary.
set -euo pipefail

cd "$(dirname "$0")"

APP="HippoShelf.app"
rm -rf "$APP" build
mkdir -p "$APP/Contents/MacOS" "$APP/Contents/Resources" build

for ARCH in arm64 x86_64; do
  swiftc -O -target "$ARCH-apple-macos13.0" \
    Sources/ShelfStore.swift Sources/L10n.swift Sources/UpdateChecker.swift Sources/SettingsWindow.swift Sources/HippoPanel.swift Sources/main.swift \
    -o "build/HippoShelf-$ARCH"
done

lipo -create build/HippoShelf-arm64 build/HippoShelf-x86_64 -output "$APP/Contents/MacOS/HippoShelf"
cp Info.plist "$APP/Contents/Info.plist"

if [ -f Resources/AppIcon.icns ]; then
  cp Resources/AppIcon.icns "$APP/Contents/Resources/AppIcon.icns"
fi

codesign --force --sign - "$APP" >/dev/null 2>&1 || true
lipo -info "$APP/Contents/MacOS/HippoShelf"
echo "Built $APP"

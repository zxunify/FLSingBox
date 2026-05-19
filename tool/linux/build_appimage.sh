#!/bin/bash
# AppImage packaging script for FLSingBox
# Usage: bash tool/linux/build_appimage.sh [version]

set -e

VERSION="${1:-$(jq -r .app_version version.json)}"
ARCH="x86_64"
APP_DIR="dist/AppDir"
OUTPUT="dist/linux/flsingbox-linux-x64-v${VERSION}.AppImage"

echo "Building AppImage v${VERSION}..."

# Clean
rm -rf "$APP_DIR"
mkdir -p "$APP_DIR/usr/bin"
mkdir -p "$APP_DIR/usr/lib"
mkdir -p "$APP_DIR/usr/share/applications"
mkdir -p "$APP_DIR/usr/share/icons/hicolor/256x256/apps"

# Copy Flutter build
BUNDLE="build/linux/x64/release/bundle"
cp -r "$BUNDLE"/* "$APP_DIR/usr/bin/"

# Copy core
if [ -f "assets/singbox/sing-box" ]; then
  cp assets/singbox/sing-box "$APP_DIR/usr/bin/sing-box"
  chmod +x "$APP_DIR/usr/bin/sing-box"
fi

# Desktop file
cat > "$APP_DIR/flsingbox.desktop" << EOF
[Desktop Entry]
Name=FLSingBox
Comment=Multi-platform proxy client powered by sing-box
Exec=flsingbox
Icon=flsingbox
Type=Application
Categories=Network;Utility;
EOF

# AppRun
cat > "$APP_DIR/AppRun" << 'EOF'
#!/bin/bash
SELF=$(readlink -f "$0")
HERE=${SELF%/*}
export LD_LIBRARY_PATH="${HERE}/usr/bin/lib:${LD_LIBRARY_PATH}"
exec "${HERE}/usr/bin/flsingbox" "$@"
EOF
chmod +x "$APP_DIR/AppRun"

# Icon (use placeholder if not available)
if [ -f "assets/icons/app_icon.png" ]; then
  cp assets/icons/app_icon.png "$APP_DIR/flsingbox.png"
  cp assets/icons/app_icon.png "$APP_DIR/usr/share/icons/hicolor/256x256/apps/flsingbox.png"
else
  # Create a simple placeholder
  touch "$APP_DIR/flsingbox.png"
fi

# Copy desktop file to standard location
cp "$APP_DIR/flsingbox.desktop" "$APP_DIR/usr/share/applications/"

# Download appimagetool if not present
if [ ! -f "/tmp/appimagetool" ]; then
  echo "Downloading appimagetool..."
  curl -L "https://github.com/AppImage/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage" -o /tmp/appimagetool
  chmod +x /tmp/appimagetool
fi

# Build AppImage
mkdir -p "dist/linux"
ARCH="$ARCH" /tmp/appimagetool "$APP_DIR" "$OUTPUT"

echo "✓ AppImage created: $OUTPUT"

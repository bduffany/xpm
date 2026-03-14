#!/usr/bin/env bash

if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install --cask blender
  exit
fi

# Map architecture to Blender's naming convention
case "$_XPM_ARCH" in
  amd64) blender_arch="linux-x64" ;;
  arm64) blender_arch="linux-arm64" ;;
  *) echo >&2 "blender: unsupported architecture $_XPM_ARCH"; exit 1 ;;
esac

# Get the latest release version from the mirror
latest_dir=$(curl -fsSL "https://download.blender.org/release/" |
  grep -oE 'Blender[0-9]+\.[0-9]+' |
  sort -t. -k1,1n -k2,2n |
  tail -1)

if [[ -z "$latest_dir" ]]; then
  echo >&2 "blender: failed to find latest release directory"
  exit 1
fi

# Get the tarball filename from the release directory
tarball=$(curl -fsSL "https://download.blender.org/release/${latest_dir}/" |
  grep -oE "blender-[0-9]+\.[0-9]+\.[0-9]+-${blender_arch}\.tar\.xz" |
  head -1)

if [[ -z "$tarball" ]]; then
  echo >&2 "blender: failed to find tarball for ${blender_arch}"
  exit 1
fi

download_url="https://download.blender.org/release/${latest_dir}/${tarball}"

sudo rm -rf "$_XPM_APPLICATIONS_PATH/blender"
sudo mkdir -p "$_XPM_APPLICATIONS_PATH/blender"
curl -fsSL -L "$download_url" | sudo tar xJ -C "$_XPM_APPLICATIONS_PATH/blender" --strip-components=1
sudo ln -sf "$_XPM_APPLICATIONS_PATH/blender/blender" "$_XPM_LOCAL_BIN_PATH/blender"

# Create desktop entry
mkdir -p "$_XPM_DESKTOP_ENTRIES_PATH"
cat > "$_XPM_DESKTOP_ENTRIES_PATH/blender.desktop" <<EOF
[Desktop Entry]
Name=Blender
Exec=$_XPM_APPLICATIONS_PATH/blender/blender %f
Icon=$_XPM_APPLICATIONS_PATH/blender/blender.svg
Type=Application
Categories=Graphics;3DGraphics;
MimeType=application/x-blender;
EOF
chmod +x "$_XPM_DESKTOP_ENTRIES_PATH/blender.desktop"

#!/usr/bin/env bash

if [[ "$OSTYPE" != linux* ]]; then
  echo "cursor installer not yet implemented for $OSTYPE"
  exit 1
fi

curl -fsSL "https://downloader.cursor.sh/linux/appImage/x64" >./cursor
chmod +x ./cursor

curl -fsSL "https://us1.discourse-cdn.com/flex020/uploads/cursor1/original/2X/a/a4f78589d63edd61a2843306f8e11bad9590f0ca.png" >./cursor.png

cat >./cursor.desktop <<EOF
[Desktop Entry]
Name=Cursor
Exec=$_XPM_LOCAL_BIN_PATH/cursor
Icon=cursor.png
Type=Application
Categories=Utility;Development;
EOF
chmod +x cursor.desktop

mkdir -p "$_XPM_LOCAL_BIN_PATH" "$_XPM_DESKTOP_ICONS_PATH" "$_XPM_DESKTOP_ENTRIES_PATH"
sudo mv ./cursor "$_XPM_LOCAL_BIN_PATH/cursor"
mv ./cursor.png "$_XPM_DESKTOP_ICONS_PATH/cursor.png"
mv ./cursor.desktop "$_XPM_DESKTOP_ENTRIES_PATH/cursor.desktop"

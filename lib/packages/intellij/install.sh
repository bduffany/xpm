#!/usr/bin/env bash
set -e

# TODO: macOS etc.
curl 'https://data.services.jetbrains.com/products?code=IIC' |
  jq -r '.[0].releases[0].downloads.linux.link' |
  xargs curl -fSsL |
  tar xvfz -

BASENAME=$(find . -maxdepth 1 -type d | grep idea)
sudo mv "$BASENAME" "/opt/$BASENAME"
sudo ln -s "/opt/$BASENAME" /opt/idea

sudo ln /opt/idea/bin/idea.png /usr/share/pixmaps/idea.png >/dev/null

mkdir -p ~/.local/share/applications
cat >~/.local/share/applications/idea.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=IntelliJ IDEA Community Edition
Icon=idea
Exec="/opt/idea/bin/idea" %f
Comment=IntelliJ IDE from JetBrains
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-intellij-idea
EOF

sudo ln -s "/opt/idea/bin/idea" "$_XPM_LOCAL_BIN_PATH/intellij"

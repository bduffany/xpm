if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install --cask goland
  exit
fi

curl 'https://data.services.jetbrains.com/products?code=GO' |
  jq -r '.[0].releases[0].downloads.linux.link' |
  xargs curl -fSsL |
  tar xvfz -

BASENAME=$(find . -maxdepth 1 -type d | grep GoLand)
sudo mv "$BASENAME" "/opt/$BASENAME"
sudo ln -s "/opt/$BASENAME" "/opt/GoLand"

ICON_URL="https://res.cloudinary.com/canonical/image/fetch/f_auto,q_auto,fl_sanitize,w_128,h_128/https://dashboard.snapcraft.io/site_media/appmedia/2017/11/go_1282x.png"
curl -fsSL "$ICON_URL" | sudo tee /usr/share/pixmaps/goland.png >/dev/null

mkdir -p ~/.local/share/applications
cat >~/.local/share/applications/goland.desktop <<EOF
[Desktop Entry]
Version=1.0
Type=Application
Name=GoLand
Icon=goland
Exec="/opt/GoLand/bin/goland.sh" %f
Comment=Golang IDE
Categories=Development;IDE;
Terminal=false
StartupWMClass=jetbrains-goland
EOF

sudo ln -s "/opt/GoLand/bin/goland.sh" "$_XPM_LOCAL_BIN_PATH/goland"

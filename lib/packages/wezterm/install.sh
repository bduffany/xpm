#!/usr/bin/env bash

if [[ "$OSTYPE" == darwin* ]]; then
  echo >&2 "wezterm: not yet supported on macOS"
  exit 1
fi

curl -fsSL https://apt.fury.io/wez/gpg.key |
  sudo gpg --yes --dearmor -o /usr/share/keyrings/wezterm-fury.gpg
echo 'deb [signed-by=/usr/share/keyrings/wezterm-fury.gpg] https://apt.fury.io/wez/ * *' |
  sudo tee /etc/apt/sources.list.d/wezterm.list
sudo apt-get update
sudo apt-get install -y wezterm-nightly

# Init wezterm config
mkdir -p ~/.config/wezterm/
if ! [[ -e ~/.config/wezterm/wezterm.lua ]]; then
  cp wezterm.lua ~/.config/wezterm/wezterm.lua
fi

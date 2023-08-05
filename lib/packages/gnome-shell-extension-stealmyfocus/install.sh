#!/usr/bin/env bash
set -ex

mkdir -p ~/.local/share/gnome-shell/extensions/
cd ~/.local/share/gnome-shell/extensions/
EXTENSION_DIR="focus-my-window@varianto25.com"
if [[ -e "$EXTENSION_DIR" ]]; then
  echo >&2 "error: stealmyfocus extension dir $PWD/$EXTENSION_DIR already exists"
  exit 1
fi

git clone https://github.com/v-dimitrov/gnome-shell-extension-stealmyfocus "$EXTENSION_DIR"
cd "$EXTENSION_DIR"
git checkout "3b1069fe32e31b7df3ffc4f97eae347b265c0b64" &>/dev/null

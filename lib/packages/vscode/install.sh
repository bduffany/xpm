#!/usr/bin/env bash

if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  echo >&2 "vscode: not yet available on darwin"
  exit 1
fi

curl -fsSL 'https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64' --output code.deb
sudo dpkg -i code.deb

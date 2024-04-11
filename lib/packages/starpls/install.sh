#!/usr/bin/env bash

curl -fsSL https://api.github.com/repos/withered-magic/starpls/releases/latest |
  jq -r '.assets[].browser_download_url' |
  grep -E "/starpls-${_XPM_KERNEL}-${_XPM_ARCH}.tar.gz$" |
  xargs curl -fsSL --output ./starpls

chmod +x starpls
sudo mv starpls "${_XPM_LOCAL_BIN_PATH}/starpls"

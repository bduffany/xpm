#!/usr/bin/env bash

if [[ "$_XPM_KERNEL" != "linux" ]]; then
  echo >&2 "pandoc installer not yet implemented on $_XPM_KERNEL"
  exit 1
fi

download_url="$(
  curl -fsSL https://api.github.com/repos/jgm/pandoc/releases/latest |
    jq -r '.assets[].browser_download_url' |
    grep -E "pandoc-.*-${_XPM_ARCH}\.deb$"
)"

if [[ -z "$download_url" ]]; then
  echo >&2 "pandoc: failed to find .deb download for arch ${_XPM_ARCH}"
  exit 1
fi

curl -fsSL "$download_url" -o pandoc.deb
sudo dpkg -i pandoc.deb

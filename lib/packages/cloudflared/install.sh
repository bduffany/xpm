#!/usr/bin/env bash

if [[ "$_XPM_KERNEL" != "linux" ]]; then
  echo >&2 "cloudflared not yet implemented on $_XPM_KERNEL"
  exit 1
fi

curl -fsSL \
  "https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64.deb" \
  -o cloudflared.deb
sudo dpkg -i cloudflared.deb

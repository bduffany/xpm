#!/usr/bin/env bash

case "$_XPM_KERNEL/$_XPM_ARCH" in
linux/amd64)
  codex_target="x86_64-unknown-linux-musl"
  ;;
linux/arm64)
  codex_target="aarch64-unknown-linux-musl"
  ;;
darwin/amd64)
  codex_target="x86_64-apple-darwin"
  ;;
darwin/arm64)
  codex_target="aarch64-apple-darwin"
  ;;
*)
  echo >&2 "codex installer not yet implemented for $_XPM_KERNEL/$_XPM_ARCH"
  exit 1
  ;;
esac

archive="codex-${codex_target}.tar.gz"
binary="codex-${codex_target}"
download_url="https://github.com/openai/codex/releases/latest/download/${archive}"

curl -fsSL --output "${archive}" "${download_url}"
tar -xzf "${archive}" "${binary}"
sudo install -m 0755 "${binary}" "$_XPM_LOCAL_BIN_PATH/codex"

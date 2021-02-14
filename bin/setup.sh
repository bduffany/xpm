#!/usr/bin/env bash
set -e
source "$(dirname $(realpath "$0"))/../lib/bootstrap.sh"

_xpm_import "log"
_xpm_import "platform/package_manager"

: ${REPO_URL:="https://github.com/bduffany/xpm"}
: ${LOCAL_BINARIES_PATH:="/usr/local/bin/"}

printf "install xpm? [Y/n]: " && read && [[ "$REPLY" =~ ^[Yy]?$ ]]
if ! which python3 >/dev/null; then
  printf "install python3 (required by xpm)? [Y/n]" && read && [[ "$REPLY" =~ ^[Yy]?$ ]]
  xpm::platform::package_manager::install python3
fi

function get_install_dir() {
  # TODO: What about MacOS?
  echo "/opt/xpm"
}
: ${INSTALL_DIR:=$(get_install_dir)}
if [[ -e "$INSTALL_DIR" ]]; then
  echo "error: directory already exists: \"$INSTALL_DIR\"" >&2
  exit 1
fi

cd $(mktemp -d)
function cleanup() {
  rm -rf "$PWD"
}
trap cleanup EXIT

sudo mkdir -p "$(dirname "$INSTALL_DIR")"
if ! [[ -z "$DEV_REPO_PATH" ]]; then
  sudo cp -R "$DEV_REPO_PATH" "$INSTALL_DIR"
else
  git clone "$REPO_URL" xpm --depth 1
  sudo mv xpm "$INSTALL_DIR"
fi
sudo ln -s "$INSTALL_DIR/bin/xpm.sh" "$LOCAL_BINARIES_PATH/xpm"
sudo chmod +x "$LOCAL_BINARIES_PATH/xpm"

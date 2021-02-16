#!/usr/bin/env bash
set -e

export _XPM_ROOT="$(realpath $(dirname $(realpath "$0"))/..)"
if [[ -e "$_XPM_ROOT/.git" ]]; then
  echo "setup.sh: not intended to be run inside the git repo; exiting"
  exit 1
fi

source "$_XPM_ROOT/lib/bootstrap.sh"

_xpm_import "log"
_xpm_import "platform/package_manager"

: ${LOCAL_BINARIES_DIR:="/usr/local/bin"}

if [[ "$XPM_NOCONFIRM" != "true" ]]; then
  printf "install xpm? [Y/n]: " && read && [[ "$REPLY" =~ ^[Yy]?$ ]]
fi

if ! which python3 >/dev/null; then
  if [[ "$XPM_NOCONFIRM" != "true" ]]; then
    printf "install python3 (required by xpm)? [Y/n]" && read && [[ "$REPLY" =~ ^[Yy]?$ ]]
  fi
  xpm::platform::package_manager::install python3
fi

: ${INSTALL_DIR:="$_XPM_APPLICATIONS_DIR/xpm"}
if [[ -e "$INSTALL_DIR" ]]; then
  echo "error: xpm installation directory already exists: \"$INSTALL_DIR\"" >&2
  exit 1
fi

# Relocate the workspace to the install dir
sudo mkdir -p "$(dirname "$INSTALL_DIR")"
cd / && sudo mv "$_XPM_ROOT" "$INSTALL_DIR" && cd "$INSTALL_DIR"

sudo ln -s "$INSTALL_DIR/bin/xpm.sh" "$LOCAL_BINARIES_DIR/xpm"
sudo chmod +x "$LOCAL_BINARIES_DIR/xpm"

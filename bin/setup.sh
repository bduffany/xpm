#!/usr/bin/env bash
set -e

: ${REPO_URL:="https://github.com/bduffany/xpm"}

printf "install xpm? [Y/n]: " && read && [[ "$REPLY" =~ ^[Yy]?$ ]]

function get_install_dir() {
  # TODO: What about MacOS?
  echo "/opt/xpm"
}
: ${INSTALL_DIR:-$(get_install_dir)}
if [[ -e "$INSTALL_DIR" ]]; then
  echo "error: directory \"$INSTALL_DIR\" already exists" >&2
  echo "failed to install xpm"
  exit 1
fi

cd $(mktemp -d)
function cleanup() {
  rm -rf "$PWD"
}

git clone "$REPO_URL" --depth 1
sudo mv xpm /opt/xpm

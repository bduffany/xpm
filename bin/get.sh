#!/usr/bin/env bash
set -e
git --version >/dev/null || {
  echo "error: missing git command; install git and try again"
  exit 1
}

cd $(mktemp -d)
function cleanup() { rm -rf "$PWD"; }
trap cleanup EXIT

git clone https://github.com/bduffany/xpm && (cd xpm && bin/setup.sh)

#!/usr/bin/env bash
# Installs the xpm sources in this repo to the local machine, so that
# xpm always executes from within this directory, even when invoked via
# the `xpm` command.
#
# Only tested on Linux.
set -e

cd "$(dirname "$(realpath "$0")")/.."

sudo rm /usr/local/bin/xpm
sudo rm -rf /opt/xpm

sudo ln -s "$PWD/bin/xpm.sh" /usr/local/bin/xpm
sudo ln -s "$PWD" "/opt/xpm"

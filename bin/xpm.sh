#!/usr/bin/env bash
set -e
source "$(dirname $(realpath "$0"))/../lib/bootstrap.sh"

USAGE="NAME:
    xpm - cross-platform package manager

USAGE:
    xpm command [command options] [arguments...]

COMMANDS:
  install, i  install a package on the current system
  source      output shell code for importing xpm sources
  upgrade     upgrade xpm
  root        print absolute path to xpm root dir
  help, h     show help for xpm
  version, v  print version and exit
"

if [[ -z "$@" ]]; then
  echo "$USAGE" >&2
  exit 1
fi

if [[ "$1" =~ ^(-h|--help)$ ]]; then
  echo "$USAGE"
  exit 0
fi

cmd="$1"
if ! [[ -e "$_XPM_ROOT/lib/cmd/" ]]; then
  echo "xpm: error: could not locate lib/cmd/ subdirectory of _XPM_ROOT (set to $_XPM_ROOT)"
  exit 1
fi
if [[ "$cmd" == "v" ]]; then
  cmd="version"
fi
if ! [[ -e "$_XPM_ROOT/lib/cmd/$cmd.sh" ]]; then
  echo "xpm: error: invalid command: $cmd" >&2
  echo "$USAGE" >&2
  exit 1
fi
shift
_xpm_import "cmd/$cmd"
"xpm::cmd::$cmd::main" "$@"

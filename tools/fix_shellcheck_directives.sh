#!/usr/bin/env bash
set -e

cd "$(dirname "$(realpath "$0")")"/..
find . -type f -name '*.sh' | while read -r path; do
  if head -n 1 <"$path" | grep -P '^#(!|\s*shellcheck.* shell=.)' &>/dev/null; then
    continue
  fi
  echo "$path"
  contents=$(cat "$path")
  path=$(mktemp)
  echo "Peep $path"

  touch "$path"
  echo "# shellcheck shell=bash" >>"$path"
  echo "$contents" >>"$path"
done

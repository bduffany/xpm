#!/bin/sh
set -e
cd $(realpath $(dirname "$0"))/..
docker build --file test/Dockerfile --tag xpm:latest .
docker run --net=host --rm --interactive --tty xpm:latest "$@"

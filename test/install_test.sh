#!/bin/sh
set -e

: ${DOCKERFILE:="test/local.Dockerfile"}

cd $(realpath $(dirname "$0"))/..
docker build --file "$DOCKERFILE" --tag xpm:latest .
docker run --net=host --rm --interactive --tty xpm:latest "$@"

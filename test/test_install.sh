#!/bin/sh

cd $(realpath $(dirname "$0"))/..
docker build --path test/Dockerfile --tag xpm:latest
docker run --rm --interactive --tty xpm:latest

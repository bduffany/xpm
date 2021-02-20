#!/bin/sh
set -e

: "${DOCKERFILE:="test/local.Dockerfile"}"

cd "$(realpath "$(dirname "$0")")"/..
docker build --file "$DOCKERFILE" --tag xpm:latest .
for pkg in "$@"; do
  docker run --net=host --rm --interactive --tty xpm:latest bash -c '
xpm install -y '"$pkg"'
cd $(mktemp -d)
source /etc/profile
echo "Testing '"$pkg"'... "
bash "$(xpm root)"/lib/packages/'"$pkg"'/test.sh
[[ $? == 0 ]] && echo "PASSED" || echo "FAILED"
'
done

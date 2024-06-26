# shellcheck shell=bash

go_version=$(
  git ls-remote --tags https://github.com/golang/go |
    grep -v rc |
    awk '/go[0-9]+\.[0-9]+/{ print $2 }' |
    perl -p -e 's@.*?(\d+\.\d+(\.\d+)?).*@\1@' |
    (while read -r line; do [[ -z "$line" ]] || echo "$line"; done) |
    xargs python3 "$_XPM_ROOT/lib/semver.py" sort |
    tail -n 1
)

if ! [[ "$go_version" ]]; then
  echo >&2 "Could not locate latest go version"
  exit 1
fi

URL_PREFIX="https://go.dev/dl/go${go_version}."

if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  eval "$(xpm source lib/darwin.sh)"
  xpm::darwin::install_pkg "${URL_PREFIX}darwin-${_XPM_ARCH}.pkg"
  exit
fi

curl -fsSL --output "go.tar.gz" "${URL_PREFIX}linux-${_XPM_ARCH}.tar.gz"
# Remove any existing go installation
sudo rm -rf /usr/local/go
sudo tar -C /usr/local -xzf "go.tar.gz"

# Update /etc/profile with /usr/local/go/bin
if ! grep -q /usr/local/go/bin /etc/profile; then
  echo "export PATH=\"\$PATH:/usr/local/go/bin\"" | sudo tee --append /etc/profile >/dev/null
fi

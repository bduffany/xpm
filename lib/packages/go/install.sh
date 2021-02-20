# shellcheck shell=bash

go_version=$(
  git ls-remote --tags https://github.com/golang/go |
    awk '/go[0-9]+\.[0-9]+/{ print $2 }' |
    perl -p -e 's@.*?(\d+\.\d+(\.\d+)?).*@\1@' |
    (while read -r line; do [[ -z "$line" ]] || echo "$line"; done) |
    xargs python3 "$_XPM_ROOT/lib/semver.py" sort |
    tail -n 1
)

if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  out=~/Downloads/go"$go_version".darwin-amd64.pkg
  wget -O "$out" \
    "https://golang.org/dl/go$go_version.darwin-amd64.pkg"
  open "$out"
fi

wget -O "go.tar.gz" "https://golang.org/dl/go$go_version.linux-amd64.tar.gz"
sudo tar -C /usr/local -xzf "go.tar.gz"
echo "export PATH=\"\$PATH:/usr/local/go/bin\"" | sudo tee /etc/profile >/dev/null

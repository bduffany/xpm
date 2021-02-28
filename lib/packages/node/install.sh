# Lookup latest LTS version
version=$(
  curl https://api.github.com/repos/nodejs/node/releases?per_page=10 |
    jq -r '.[] | select(.name | contains("LTS")) | .tag_name' |
    head -n 1
)

if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  eval "$(xpm source lib/darwin.sh)"
  xpm::darwin::install_pkg "https://nodejs.org/dist/$version/node-$version.pkg"
  exit
fi

echo "Installing node $version"

wget -O- "https://nodejs.org/dist/$version/node-$version-linux-x64.tar.xz" |
  tar xfJ - --strip-components 1
find . -maxdepth 1 -type d | grep / | while read -r dir; do
  cp -R "$dir" /usr/local
done

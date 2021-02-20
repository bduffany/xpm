if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install gh
  exit
fi

download_url="$(
  curl -sS https://api.github.com/repos/cli/cli/releases/latest |
    jq -r '.assets[] | .browser_download_url | select(endswith("linux_amd64.tar.gz"))'
)"
wget -O gh.tar.gz "$download_url"
tar xvf gh.tar.gz
cd gh_* || exit 1
for dir in bin share/man/man1; do
  sudo mv "$dir"/* "/usr/local/$dir/"
done

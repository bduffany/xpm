if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install gh
  exit
fi

if command -v apt &>/dev/null; then
  curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg |
    sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg &&
    sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg &&
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null &&
    sudo apt update &&
    sudo apt install gh -y
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

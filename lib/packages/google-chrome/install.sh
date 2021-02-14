if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install --cask google-chrome
  exit
fi

# TODO: Support non-debian:
# https://chromium.googlesource.com/chromium/src/+/refs/heads/master/docs/linux/chromium_packages.md

wget -O google-chrome.deb "https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb"
sudo dpkg -i google-chrome.deb

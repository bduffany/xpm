if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install fd
  exit
fi

sudo apt-get install -y fd-find
sudo ln -s "$(command -v fdfind)" "$_XPM_LOCAL_BIN_PATH/fd"

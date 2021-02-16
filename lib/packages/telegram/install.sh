if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew install --cask telegram
  exit
fi

wget -O telegram.tar.xz https://telegram.org/dl/desktop/linux
tar xvf telegram.tar.xz
sudo mv ./Telegram "$_XPM_APPLICATIONS_PATH/Telegram"
sudo ln -s "$_XPM_APPLICATIONS_PATH/Telegram/Telegram" "$_XPM_LOCAL_BIN_PATH/telegram"

kernel="$_XPM_KERNEL"
if [[ "$kernel" == "darwin" ]]; then
  brew install grpcurl
  exit
fi
variant="${kernel}_x86_64"
wget -O grpcurl.tar.gz "https://github.com/fullstorydev/grpcurl/releases/download/v1.8.0/grpcurl_1.8.0_$variant.tar.gz"
tar xvf grpcurl.tar.gz
sudo cp grpcurl "$_XPM_LOCAL_BIN_PATH/grpcurl"

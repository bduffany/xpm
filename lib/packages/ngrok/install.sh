variant="$_XPM_KERNEL-amd64"
download_url="$(curl -s 'https://ngrok.com/download' | grep -oP 'href="https.*?'"$variant"'.*?"' | sed -r 's/href="(.*?)"/\1/g')"
wget -O ngrok.tar.gz "$download_url"
tar -xvf ngrok.tar.gz
sudo cp ngrok "$_XPM_LOCAL_BIN_PATH/ngrok"

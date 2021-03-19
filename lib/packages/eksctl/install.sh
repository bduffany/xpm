if [[ "$_XPM_KERNEL" == "darwin" ]]; then
  brew tap weaveworks/tap
  brew install weaveworks/tap/eksctl
  exit
fi

curl -fsSL "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" |
  tar xz -C "$PWD"

sudo mv eksctl "$_XPM_LOCAL_BIN_PATH/eksctl"

# bazelisk is a launcher for bazel that ensures `.bazelversion` settings inside
# git workspaces are respected.
# It's usually desirable to install bazelisk instead of bazel, and have
# bazelisk manage bazel installation for you.

download_url=$(curl https://api.github.com/repos/bazelbuild/bazelisk/releases/latest |
  jq -r '.assets[] | .browser_download_url' |
  grep -P '/bazelisk-'"$_XPM_KERNEL"'-amd64$')
wget -O bazel "$download_url"
chmod +x ./bazel
sudo mv ./bazel "$_XPM_LOCAL_BIN_PATH/bazel"

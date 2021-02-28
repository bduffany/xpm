_xpm_import "log"

# Installs a .pkg file given a URL.
xpm::darwin::install_pkg() {
  local url="${1?}"
  local fname
  fname=$(echo "$url" | xargs basename)
  if ~ [[ "$fname" =~ \.pkg$ ]]; then
    xpm::log::error "install_pkg: URL does not end with .pkg extension: $url"
    return 1
  fi
  mkdir -p ~/Downloads
  # TODO: handle duplicate filenames
  local out=~/Downloads/"$fname"
  wget -O "$out" "$url"
  sudo installer -pkg "$out" -target /
}

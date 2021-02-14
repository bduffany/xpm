_xpm_import "has"
_xpm_import "log"

function xpm::platform::package_manager::install() {
  if xpm::has apt-get; then
    sudo apt-get install "$@"
  elif xpm::has brew; then
    brew install "$@"
  elif xpm::has pacman; then
    sudo pacman -S "$@"
  elif xpm::has yum; then
    sudo yum install "$@"
  else
    xpm::log::fatal "error: could not locate a package manager tool."
  fi
}

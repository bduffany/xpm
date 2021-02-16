_xpm_import "has"
_xpm_import "log"

function xpm::platform::package_manager::install() {
  local noconfirm_args=()
  if [[ "$_XPM_NOCONFIRM" == true ]]; then
    noconfirm_args+=("-y")
  fi
  if xpm::has apt-get; then
    sudo apt-get install "${noconfirm_args[@]}" "$@"
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

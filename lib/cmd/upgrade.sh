__xpm_cmd_upgrade_usage='NAME:
    xpm upgrade - update xpm in place

USAGE:
    xpm upgrade

OPTIONS:
    -h: show help
'

function xpm::cmd::upgrade::main() {
  while getopts ":h" opt; do
    case ${opt} in
    h)
      echo "$__xpm_cmd_upgrade_usage"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "$__xpm_cmd_upgrade_usage" >&2
      exit 1
      ;;
    esac
  done

  _xpm_cmd_upgrade_bin_path=$(which "$0")
  _xpm_cmd_upgrade_install_dir="$(dirname $(realpath "$0"))"
  _xpm_cmd_upgrade_backup_dir=$(mktemp -d --suffix=.xpm)

  function _xpm_cmd_upgrade_cleanup() {
    if ! [[ -e "$_xpm_cmd_upgrade_install_dir" ]]; then
      echo "Something went wrong with the upgrade. Restore the old version with the following command:" >&2
      printf "sudo rm \"$_xpm_cmd_upgrade_bin_path\" && " >&2
      printf "sudo rm -rf \"$_xpm_cmd_upgrade_install_dir\" && " >&2
      printf "sudo mv \"$_xpm_cmd_upgrade_backup_dir\" \"$_xpm_cmd_upgrade_install_dir\"" >&2
      echo >&2
      exit 1
    else
      rm -rf "$_xpm_cmd_upgrade_backup_dir"
    fi
  }
  trap _xpm_cmd_upgrade_cleanup EXIT

  echo "
set -ex
rm \"$_xpm_cmd_upgrade_bin_path\"
rm -rf \"$_xpm_cmd_upgrade_install_dir\"
curl -SsL xpm.sh/get | XPM_NOCONFIRM=true INSTALL_DIR=\"$_xpm_cmd_upgrade_install_dir\" bash
" | bash
}

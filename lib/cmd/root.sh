__xpm_cmd_root_usage='NAME:
    xpm root - print path to the xpm root dir

DESCRIPTION:
    The xpm root dir is the local directory to which the xpm distribution was installed.

USAGE:
    xpm root

OPTIONS:
    -h: show help
'

function xpm::cmd::root::main() {
  while getopts ":h" opt; do
    case ${opt} in
    h)
      echo "$__xpm_cmd_root_usage"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "$__xpm_cmd_root_usage" >&2
      exit 1
      ;;
    esac
  done
  echo "$_XPM_ROOT"
}

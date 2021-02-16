__xpm_cmd_source_usage='NAME:
    xpm source - import xpm libraries via shell code

USAGE:
    eval $(xpm source [paths...]) # paths are relative to the xpm root dir

OPTIONS:
    -h: show help
'

function xpm::cmd::source::main() {
  while getopts ":h" opt; do
    case ${opt} in
    h)
      echo "$__xpm_cmd_source_usage"
      exit 0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "$__xpm_cmd_source_usage" >&2
      exit 1
      ;;
    esac
  done
  if [[ $# != 1 ]]; then
    echo "xpm source: incorrect number of arguments" >&2
    echo "$__xpm_cmd_source_usage" >&2
    exit 1
  fi
  : ${_XPM_ROOT:="$(realpath $(dirname $(realpath "$0"))/..)"}
  echo "export _XPM_ROOT=\"$_XPM_ROOT\" && source \"$_XPM_ROOT/lib/bootstrap.sh\" && source \"$_XPM_ROOT/$1\""
}

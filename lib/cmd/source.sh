__xpm_cmd_source_usage='NAME:
    xpm source - import xpm libraries via shell code

USAGE:
    eval $(xpm source [paths...]) # paths are relative to the xpm root dir

OPTIONS:
    -h: show help
'

function xpm::cmd::source::main() {
  local using=false
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
  echo "source \"$_XPM_ROOT/lib/bootstrap.sh\" && source \"$_XPM_ROOT/$1\""
}

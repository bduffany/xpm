__import 

__xpm_cmd_source_usage='NAME:
    xpm source - get shell code to import xpm libraries

USAGE:
    eval $(xpm source -g [paths...])

OPTIONS:
    -g: strip namespace prefixes, importing into the global namespace
    -h: show help
'

function xpm::cmd::source::main() {
  local using=false
  while getopts ":hg" opt; do
    case ${opt} in
    h)
      echo "$__xpm_cmd_source_usage"
      exit 0
    g)
      using="true"
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      echo "$__xpm_cmd_source_usage" >&2
      exit 1
    ;;
    esac
  done
  if [[ "$using" == "true" ]]; then
    echo "source \"$_XPM_ROOT/lib/using.sh\""
  fi
  echo "source \"$_XPM_ROOT/$1\""
}

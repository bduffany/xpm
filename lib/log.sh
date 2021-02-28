_xpm_import "ansi"
_xpm_import "functions"

# Set COLOR env var to false to disable colors entirely.
: ${COLOR:=true}

function xpm::log::fatal() {
  xpm::log::color red "$@\n"
  exit 1
}

function xpm::log::error() {
  xpm::log::color red "$@\n"
}

function xpm::log::success() {
  xpm::log::color green "$@\n"
}

function xpm::log::comment() {
  xpm::log::color dim "$@\n"
}

function xpm::log::warn() {
  xpm::log::color yellow "$@\n"
}

function xpm::log::info() {
  xpm::log::color blue "$@\n"
}

function xpm::log::color() {
  if [[ "$COLOR" == "false" ]] || ! [ -t 1 ]; then
    shift
    echo "$@"
    return
  fi
  local c_start=$(eval "echo \$__xpm_ansi_c_$1")
  shift
  local text="$@"
  printf "${c_start}${text}${__xpm_ansi_c_end}"
}

function xpm::log::alias() {
  for name in fatal success comment warn info color; do
    xpm::functions::redeclare "xpm::log::$name" "$name"
  done
}

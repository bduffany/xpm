_xpm_import "ansi"
_xpm_import "functions"

# Set COLOR env var to false to disable colors entirely.
: ${COLOR:=true}

function xpm::log::fatal() {
  xpm::log::color red "$@\n"
  exit 1
}

function xpm::log::success() {
  xpm::log::color green "$@\n"
}

function xpm::log::comment() {
  xpm::log::color dim "$@\n"
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
  for name in fatal comment success error; do
    xpm::functions::redeclare "xpm::log::$name" "$name"
  done
}

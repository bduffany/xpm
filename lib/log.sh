__import "lib/ansi.sh"

# Set COLOR env var to false to disable colors entirely.
: ${COLOR:=true}

function log::fatal() {
  color red "$@\n"
  exit 1
}

function log::success() {
  color green "$@\n"
}

function log::comment() {
  color dim "$@\n"
}

function log::color() {
  if [[ "$COLOR" == "false" ]] || ! [ -t 1 ]; then
    shift
    echo "$@"
    return
  fi
  local c_start=$(eval "echo \$__xpm_ansi_c_$1")
  shift
  local text="$@"
  printf "${c_start}${text}${c_end}"
}

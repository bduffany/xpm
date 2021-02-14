function xpm::functions::redeclare() {
  local original_func=$(declare -f $1)
  local new_func="$2${original_func#$1}"
  eval "$new_func"
}

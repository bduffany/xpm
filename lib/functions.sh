function xpm::functions::redeclare() {
  eval "function $2 { $1 \"\$@\" ; }"
}

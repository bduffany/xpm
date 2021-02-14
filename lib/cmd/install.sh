function xpm::cmd::install::main() {
  # Note, python3 is installed in XPM initial setup.
  (
    cd "$_XPM_ROOT"
    python3 "lib/cmd/install.py" "$@"
  )
}

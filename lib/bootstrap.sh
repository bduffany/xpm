_XPM_ROOT=$(realpath $(dirname "$0"))

__xpm_bootstrap_imports=()

# Bootstraps the XPM script.
function xpm::bootstrap::main() {

  # Define the global "_XPM_IMPORT" function, which allows importing XPM libraries
  # by their path relative to the repo root.
  function _XPM_IMPORT() {
    local path="${1?}"
    for existing in "${__xpm_bootstrap_imports[@]}"; do
      if [[ "$existing" == "$path" ]]; then
        return
      fi
    done
    source "$_XPM_ROOT/$@"
    __xpm_bootstrap_imports+=("$path")
  }
}

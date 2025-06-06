# bootstrap.sh: Sets up bash globals used by the xpm binary as well as
# packages that it installs.

if [[ "${__xpm_bootstrap_done:-}" != 1 ]]; then

  : "${_XPM_ROOT:="$(readlink -f "$(dirname "$(readlink -f "$0")")"/..)"}"
  export _XPM_ROOT="$_XPM_ROOT"
  export PATH="${_XPM_ROOT}/bin:$PATH"

  # define _XPM_* vars
  if [[ "$OSTYPE" == "linux"* ]]; then
    export _XPM_KERNEL="linux"
    export _XPM_LOCAL_BIN_PATH="/usr/local/bin"
    export _XPM_APPLICATIONS_PATH="/opt"
    export _XPM_DESKTOP_ENTRIES_PATH="$HOME/.local/share/applications"
    export _XPM_DESKTOP_ICONS_PATH="$HOME/.local/share/icons"
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    export _XPM_KERNEL="darwin"
    export _XPM_LOCAL_BIN_PATH="/usr/local/bin"
    export _XPM_APPLICATIONS_PATH="/Applications"
  else
    echo "unsupported OS: $OSTYPE" >&2
    exit 1
  fi

  # TODO: support other architectures
  if [[ "$(uname -m)" == aarch64 ]]; then
    export _XPM_ARCH=arm64
  else
    export _XPM_ARCH=amd64
  fi

  __xpm_bootstrap_done=1
  __xpm_bootstrap_imports=()

  # Define the global "_xpm_import" function, which allows importing XPM libraries
  # by their path relative to the repo root.
  function _xpm_import() {
    if [[ $# != 1 ]]; then
      echo "error: wrong number of arguments to _xpm_import"
      return 1
    fi
    local import_path="${1?}"
    for existing in "${__xpm_bootstrap_imports[@]}"; do
      if [[ "$existing" == "$import_path" ]]; then
        return
      fi
    done
    local full_path="$_XPM_ROOT/lib/$import_path.sh"
    if ! [[ -e "$full_path" ]]; then
      echo "import not found: $import_path" >&2
      return 1
    fi
    source "$full_path"
    __xpm_bootstrap_imports+=("$import_path")
  }

fi

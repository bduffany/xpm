#!/usr/bin/env bash
set -e

# XPM preamble: add this to the very beginning of your scripts to ensure that the user has XPM installed.
! which curl &>/dev/null && echo 'error: missing "curl" command: install curl and try again' && exit 1
! which xpm &>/dev/null && curl -SsLo- 'https://raw.githubusercontent.com/bduffany/xpm/main/bin/setup.sh' | bash

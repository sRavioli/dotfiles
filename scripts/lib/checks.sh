#!/bin/bash -e
# helpers to check for various things

source "$(dirname "${BASH_SOURCE[0]}")/msg.sh"
source "$(dirname "${BASH_SOURCE[0]}")/installer.sh"

# check if command is executable
function is_executable() { command -v "$1" &>/dev/null; }

function has_package() {
  if [ "$(dpkg-query -W --showformat='${Status}\n' "$1" | grep "install ok installed")" = "" ]; then
    if is_executable "brew"; then
      if [ "$(brew list | grep "$1")" = "" ]; then
        return 1
      fi
    fi
  fi
  return 0
}

function install_if_missing() {
  local pkg="$1"

  info "checking if '${pkg}' is installed"
  if ! has_package "${pkg}"; then
    warn "'${pkg}' is not installed! installing..."

    sudo ${INSTALLER} install "${pkg}" &&
      ok "installed '${pkg}'"
  else
    ok "'${pkg}' is already installed"
  fi
}

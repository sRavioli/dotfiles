#!/bin/bash -e

source "$(dirname "${BASH_SOURCE[0]}")/msg.sh"
source "$(dirname "${BASH_SOURCE[0]}")/installer.sh"

function confirm() {
  local header
  header="$(tput setaf 13)Y/N"
  local pad=$(((8 - ${#header} + 4) / 2))
  local prompt="${1:-are you sure?}"

  printf '[%*s%s%s%*s] %s' "${pad}" " " "${header}" "$(tput sgr0)" "${pad}" " " "${prompt}"

  while true; do
    read -r -p " [Y/n] " response
    if [[ -z "$response" ]]; then
      response="y"
    fi

    case "$response" in
    [yY] | [yY][eE][sS]) return 0 ;;
    [nN] | [nN][oO]) return 1 ;;
    *) warn "invalid choice" ;;
    esac
  done
}

function rm_dir() {
  local dir="$1"
  info "checking if '${dir}' exists"

  if [ -d "${dir}" ]; then
    warn "'${dir}' exists. removing..."
    rm -rf "${dir}" &&
      ok "removed '${dir}' successfully"
  else
    ok "'${dir}' is not present"
  fi
}

function mk_dir() {
  local dir="$1"
  info "creating '${dir}' directory"
  if [ -d "${dir}" ]; then
    ok "directory '${dir}' already exists"
    return
  fi

  mkdir --parents "${dir}" && ok "successfully created directory '${dir}'"
}

function is_executable() { command -v "$1" &>/dev/null; }

function has_pgk() {
  local pkg="$1"
  if dpkg-query -W -f'${db:Status-Abbrev}\n' "${pkg}" 2>/dev/null | grep -q '^.i $'; then
    return 0
  fi

  if is_executable "brew"; then
    if [ "$(brew list | grep "^${pkg}\$")" != "" ]; then
      return 0
    fi
  fi

  return 1
}

function install_pkg() {
  local pkg="$1"

  info "checking if '${pkg}' is installed"
  if has_pgk "${pkg}"; then
    ok "package '${pkg}' is already installed"
    return 0
  fi

  info "package '${pkg}' is not installed. Installing..."
  sudo "${INSTALLER}" install "${pkg}" -y &>/dev/null &&
    ok "installed package '${pkg}'"
}

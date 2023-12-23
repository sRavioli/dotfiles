#!/bin/bash -e
# installs neovim

source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

for pkg in ninja-build gettext cmake unzip curl gcc-multilib; do
  install_pkg "${pkg}"
done

cd "$HOME/usr/src/" || exit

info "cloning neovim source" &&
  git clone https://github.com/neovim/neovim &>/dev/null &&
  ok "cloned"

cd neovim || exit

info "building..."
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$INSTALLDIR" &&
  rm -rf "$INSTALLDIR"

info "installing..." &&
  cd build && cpack -G DEB && sudo dpkg -i nvim-linux64.deb

ok "done"

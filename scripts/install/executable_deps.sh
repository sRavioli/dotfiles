#!/bin/bash -e
# install some dependecies

source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

info "INSTALLING PACKAGES"

info "installing packages with apt/nala"
pkgs=("libssl-dev" "ripgrep" "ddgr" "polybar")
for pkg in "${pkgs[@]}"; do
  info "installing '${pkg}'"
  sudo "${INSTALLER}" install "${pkg}" -y && ok "installed '${pkg}'"
done

if is_executable "cargo"; then
  info "installing packages with cargo"
  cargo_pkgs=("cargo-update" "eza" "du-dust" "onefetch")
  for pkg in "${cargo_pkgs[@]}"; do
    info "installing '${pkg}'"
    cargo install "${pkg}" && ok "installed '${pkg}'"
  done
  cargo install --locked yazi-fm
else
  warn "cargo is not executable, skipping these packages ${cargo_pkgs[*]}"
fi

if is_executable "brew"; then
  brew_pkgs=(
    "pandoc"
    "poppler"
    "ffmpeg"
    "rga"
    "gh"
    "mask"
    "tokei"
    "gitui"
    "procs"
    "sk"
    "thefuck"
    "fzf"
    "fd"
    "glow"
    "hyperfine"
    "bat"
    "bat-extras"
    "bottom"
    "cocogitto"
    "difftastic"
  )
  for pkg in "${brew_pkgs[@]}"; do
    info "installing '${pkg}'"
    brew install "${pkg}" && ok "installed '${pkg}'"
  done
else
  warn "brew is not executable, skipping these packages ${brew_pkgs[*]}"
fi

# install fzf key bindings and completions
"$(brew --prefix)"/opt/fzf/install

ok "DONE INSTALLING PACKAGES"

#!/bin/bash -e
# install bspwm and sxhkd

source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

info "INSTALLING BSPWM AND SXHKD"

for pkg in libxcb-xinerama0-dev libxcb-icccm4-dev libxcb-randr0-dev libxcb-util0-dev libxcb-ewmh-dev libxcb-keysyms1-dev libxcb-shape0-dev; do
  install_pkg "${pkg}"
done

info "cloning bspwm..." &&
  git clone https://github.com/baskerville/bspwm.git "${HOME}/usr/src/bspwm" &&
  ok "cloned bspwm"

info "cloning sxhkd..." &&
  git clone https://github.com/baskerville/sxhkd.git "${HOME}/usr/src/sxhkd" &&
  ok "cloned sxhkd"

info "installing bspwm" &&
  (cd "${HOME}/usr/src/bspwm" && make && sudo make install) &&
  ok "installed bspwm"

info "installing sxhkd" &&
  (cd "${HOME}/usr/src/sxhkd" && make && sudo make install) &&
  ok "installed sxhkd"

info "creating directories for configuration" &&
  mkdir -p ~/.config/{bspwm,sxhkd} && ok "created directories"

info "copying bspwm config" &&
  cp "${HOME}"/usr/src/bspwm/examples/bspwmrc ~/.config/bspwm/ && ok "copied"

info "copying sxhkd config" &&
  cp "${HOME}"/usr/src/bspwm/examples/sxhkdrc ~/.config/sxhkd/ && ok "copied"

info "making bspwmrc executable" &&
  chmod u+x ~/.config/bspwm/bspwmrc &&
  ok "done"

info "DONE INSTALLING BSPWM AND SXHKD"

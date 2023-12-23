#!/bin/bash -e
# installs the Kanagawa GKT theme

## LOAD LIBRARY  ===============================================================
source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

info "INSTALLING DESKTOP THEME"

## INSTALL KANAGAWA THEME ======================================================
for pkg in gtk2-engines-murrine gnome-tweaks; do
  install_pkg "${pkg}"
done

rm_dir "/tmp/Kanagawa-GKT-Theme/" &&
  ok "ready to clone"

info "cloning..." &&
  git clone https://github.com/Fausto-Korpsvart/Kanagawa-GKT-Theme.git /tmp/Kanagawa-GKT-Theme &>/dev/null

info "copying directories into place..."
for filename in /tmp/Kanagawa-GKT-Theme/themes/*; do
  cp --recursive --force "${filename}" "${HOME}/.themes" &&
    ok "copied '$(basename "${filename}")' to '${HOME}/.themes/$(basename "${filename}")'"
done

# install icons
mk_dir "${HOME}/.icons"

info "copying icons..."
cp --recursive --force "/tmp/Kanagawa-GKT-Theme/icons/Kanagawa/" "${HOME}/.icons/Kanagawa" &&
  ok "copied icons"

# pick a theme to install
# filename=$(pick "select the theme to activate" /tmp/Kanagawa-GKT-Theme/themes/*)
pick_msg "select the theme to activate (0 quits program)"
select filename in $(fd . /tmp/Kanagawa-GKT-Theme/themes/ -td -d1 | xargs basename -a); do
  if [[ "${REPLY}" == "0" ]]; then
    exit
  elif [[ -z ${filename} ]]; then
    error "not a valid file"
  else
    ok "selected $(basename "${filename}")"
    break
  fi
done

info "applying theme..."
gsettings set org.cinnamon.desktop.interface icon-theme "Kanagawa" &&
  ok "applied icon theme"
gsettings set org.cinnamon.desktop.interface gtk-theme "$(basename "${filename}")" &&
  ok "applied gtk interface theme"
gsettings set org.cinnamon.theme name "$(basename "${filename}")" &&
  ok "applied cinnamon theme"

ok "DONE INSTALING DESKTOP THEMES"

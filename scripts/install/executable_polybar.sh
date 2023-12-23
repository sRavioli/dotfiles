#!/bin/bash -e

source "$(dirname "${BASH_SOURCE[0]}")/../lib/utils.sh"

info "INSTALLIING POLYBAR AND THEME"

for pkg in polybar rofi calc mpd; do
  install_pkg "${pkg}"
done
pip3 install --user pywal

info "cloning polybar themes"
git clone --depth=1 https://github.com/adi1090x/polybar-themes.git "${HOME}/polybar-themes" &&
  ok "clone successful"

cd "${HOME}/polybar-themes" || exit

info "making stetup file executable"
chmod +x "./setup.sh" &&
  ok "setup is executable"

info "running setup"
/bin/bash "./setup.sh" && ok "done"

cd "${XDG_CONFIG_HOME}/polybar" || exit

function search_replace() {
  local to_search="$1"
  local to_replace="$2"
  local sep="${3:-/}"

  rg --files-with-matches -e "${to_search}" |
    xargs -d "\n" sed -i "s${sep}${to_search}${sep}${to_replace}${sep}g" &&
    ok "replace successful"
}

brightess="$(ls -1 /sys/class/backlight/)"
confirm "replace brightess type 'amdgpu_bl0' with '${brightess}' (yours)" &&
  search_replace "amdgpu_bl0" "${brightess}"

power_supply="$(find /sys/class/power_supply/* | rg ".*(BAT\d)\$" -r '$1')"
confirm "replace battery hardware 'BAT1' with '${power_supply}' (yours)" &&
  search_replace "BAT1" "${power_supply}"

info "your should have a look at temperature sensors. those are your sensors:" &&
  sensors

info "now printing sensors"
for i in /sys/class/hwmon/hwmon*/temp*_input; do
  echo "$(<"$(dirname "$i")/name"): \
    $(cat "${i%_*}"_label 2>/dev/null || echo "$(basename "${i%_*}")") $(readlink -f "$i")"
done

temp_sensor="$(for i in /sys/class/hwmon/hwmon*/temp*_input; do
  echo "$(<"$(dirname "$i")/name"): \
    $(cat "${i%_*}"_label 2>/dev/null || echo "$(basename "${i%_*}")") $(readlink -f "$i")"
done | rg "coretemp:\s+Package id 0 " --replace '$1')"
info "this should be your cpu sensor: ${temp_sensor}"

confirm "replace temperatures sensor with '${temp_sensor}' (yours)" &&
  search_replace "/sys/devices/pci0000:00/0000:00:01.3/0000:01:00.0/hwmon/hwmon0/temp1_input" \
    "${temp_sensor}" "#"

network_interface="$(ip link show | rg "2: ([a-z0-9]+):.*\$" --replace '$1')"
confirm "replace network interface 'wlan0' with '${network_interface}' (yours)" &&
  search_replace "wlan0" "${network_interface}"

confirm "preview all possible themes?" && (
  for theme in ./*; do
    if [ -d "${theme}" ]; then
      basename "${theme}"
      bash ~/.config/polybar/launch.sh "--$(basename "${theme}")" &>/dev/null
      sleep 5
    fi
  done
  killall -p polybar
)

pick_msg "choose the theme use (0 quits program)"
select theme in $(fd . --type=d --maxdepth=1 | xargs basename -a); do
  if [[ "${REPLY}" == "0" ]]; then
    exit
  elif ! [ -d "${XDG_CONFIG_HOME}/polybar/${theme}" ]; then
    error "not a valid theme"
  else
    ok "selected $(basename "${theme}")"
    break
  fi
done

"${XDG_CONFIG_HOME}/polybar/${theme}/launch.sh" &>/dev/null

info "DONE INSTALLIING POLYBAR AND THEME"

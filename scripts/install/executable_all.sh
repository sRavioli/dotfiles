#!/bin/bash -e
# setups the machine with dependencies, desktop customization

dir="$(dirname "${BASH_SOURCE[0]}")"

/bin/bash -e "./${dir}/deps.sh"
/bin/bash -e "./${dir}/desktop.sh"
/bin/bash -e "./${dir}/plank.sh"
/bin/bash -e "./${dir}/polybar.sh"
/bin/bash -e "./${dir}/neovim.sh"

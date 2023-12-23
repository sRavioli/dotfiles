#!/bin/bash -e
# get installer to use

INSTALLER="/usr/local/bin/apt"
if command -v "nala" &>/dev/null; then
  INSTALLER="/usr/bin/nala"
fi

export INSTALLER

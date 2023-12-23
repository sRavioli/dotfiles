#!/bin/bash -e
# helpers to display messages

function msg() {
  local pad=$(((8 - ${#1} + 4) / 2))
  printf '[%*s%s%s%*s] %s\n' "${pad}" " " "$1" "$(tput sgr0)" "${pad}" " " "$2"
}

function info() { msg "$(tput setaf 4)INFO" "$1"; }
function warn() { msg "$(tput setaf 3)WARN" "$1"; }
function verbose() { msg "$(tput setaf 8)VERBOSE" "$1"; }

function ok() { msg "$(tput setaf 10)OK" "$1"; }
function error() { msg "$(tput setaf 9)ERROR" "$1"; }

function pick_msg() { msg "$(tput setaf 5)PICK" "$1"; }

function yes_or_no() {
  local head
  head="$(tput setaf 13)Y/N"
  local pad=$(((8 - ${#head} + 4) / 2))
  printf '[%*s%s%s%*s] %s' "${pad}" " " "${head}" "$(tput sgr0)" "${pad}" " " "$1"

  while true; do
    read -r -p " [y/n]: " yn
    case $yn in
    [Yy]*) return 0 ;;
    [Nn]*)
      error "operation aborted"
      return 1
      ;;
    esac
  done
}

function press_enter {
  info "$1. press enter to continue..."
  read -r -p ""
}

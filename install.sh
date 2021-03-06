#!/bin/sh
#
# This script should be run via curl:
#   sh -c "$(curl -fsSL https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/install.sh)"
# or via wget:
#   sh -c "$(wget -qO- https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/install.sh)"
# or via fetch:
#   sh -c "$(fetch -o - https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/install.sh)"
#
# As an alternative, you can first download the install script and run it afterwards:
#   wget https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/install.sh
#   sh install.sh

set -e

# Default settings
REPO=${REPO:-m-v-kalashnikov/setup-files}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-master}

TERMUX=false

command_exists() {
  command -v "$@" >/dev/null 2>&1
}

# The [ -t 1 ] check only works when the function is not called from
# a subshell (like in `$(...)` or `(...)`, so this hack redefines the
# function at the top level to always return false when stdout is not
# a tty.
if [ -t 1 ]; then
  is_tty() {
    true
  }
else
  is_tty() {
    false
  }
fi

# This function uses the logic from supports-hyperlinks[1][2], which is
# made by Kat Marchán (@zkat) and licensed under the Apache License 2.0.
# [1] https://github.com/zkat/supports-hyperlinks
# [2] https://crates.io/crates/supports-hyperlinks
#
# Copyright (c) 2021 Kat Marchán
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
supports_hyperlinks() {
  # $FORCE_HYPERLINK must be set and be non-zero (this acts as a logic bypass)
  if [ -n "$FORCE_HYPERLINK" ]; then
    [ "$FORCE_HYPERLINK" != 0 ]
    return $?
  fi

  # If stdout is not a tty, it doesn't support hyperlinks
  is_tty || return 1

  # DomTerm terminal emulator (domterm.org)
  if [ -n "$DOMTERM" ]; then
    return 0
  fi

  # VTE-based terminals above v0.50 (Gnome Terminal, Guake, ROXTerm, etc)
  if [ -n "$VTE_VERSION" ]; then
    [ $VTE_VERSION -ge 5000 ]
    return $?
  fi

  # If $TERM_PROGRAM is set, these terminals support hyperlinks
  case "$TERM_PROGRAM" in
  Hyper|iTerm.app|terminology|WezTerm) return 0 ;;
  esac

  # kitty supports hyperlinks
  if [ "$TERM" = xterm-kitty ]; then
    return 0
  fi

  # Windows Terminal or Konsole also support hyperlinks
  if [ -n "$WT_SESSION" ] || [ -n "$KONSOLE_VERSION" ]; then
    return 0
  fi

  return 1
}

fmt_link() {
  # $1: text, $2: url, $3: fallback mode
  if supports_hyperlinks; then
    printf '\033]8;;%s\a%s\033]8;;\a\n' "$2" "$1"
    return
  fi

  case "$3" in
  --text) printf '%s\n' "$1" ;;
  --url|*) fmt_underline "$2" ;;
  esac
}

fmt_underline() {
  is_tty && printf '\033[4m%s\033[24m\n' "$*" || printf '%s\n' "$*"
}

# shellcheck disable=SC2016 # backtick in single-quote
fmt_code() {
  is_tty && printf '`\033[2m%s\033[22m`\n' "$*" || printf '`%s`\n' "$*"
}

fmt_error() {
  printf '%sError: %s%s\n' "$BOLD$RED" "$*" "$RESET" >&2
}

setup_color() {
  # Only use colors if connected to a terminal
  if is_tty; then
    RED=$(printf '\033[38;5;196m')
    M_RED=$(printf '\033[31m')
    ORANGE=$(printf '\033[38;5;202m')
    GOLD=$(printf '\033[33m')
    YELLOW=$(printf '\033[38;5;226m')
    L_GREEN=$(printf '\033[38;5;082m')
    M_GREEN=$(printf '\033[32m')
    L_BLUE=$(printf '\033[34m')
    BLUE=$(printf '\033[38;5;021m')
    PURPLE=$(printf '\033[38;5;093m')
    L_PURPLE=$(printf '\033[38;5;163m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[m')
  else
    RED=""
    M_RED=""
    ORANGE=""
    GOLD=""
    YELLOW=""
    L_GREEN=""
    M_GREEN=""
    L_BLUE=""
    BLUE=""
    PURPLE=""
    L_PURPLE=""
    BOLD=""
    RESET=""
  fi
  LVL="---"
  PIPE="${L_BLUE}|"
  PIPE0="${PIPE}"
  PIPE1="${PIPE0}${LVL}${PIPE}"
  PIPE2="${PIPE1}${LVL}${PIPE}"
}

updating_system() {
  printf "%s Updating of system %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  if [ "$TERMUX" = true ]; then
    pkg update -y > /dev/null 2>&1
    pkg upgrade -y > /dev/null 2>&1
    pkg autoclean -y > /dev/null 2>&1
  elif command_exists brew; then
    brew update -f > /dev/null 2>&1
    brew upgrade > /dev/null 2>&1
  elif command_exists apt; then
    sudo apt update > /dev/null 2>&1
    sudo apt -y upgrade > /dev/null 2>&1
    sudo apt -y autoclean > /dev/null 2>&1
    sudo apt -y autoremove > /dev/null 2>&1
  fi

  printf "%s Updating of system %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

check_termux() {
  case "$PREFIX" in
    *com.termux*) TERMUX=true ;;
    *) TERMUX=false ;;
  esac
}

install_requirements() {
  printf "%s Installing of requirements %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  COMMON="htop git curl"

  if [ "$TERMUX" = true ]; then
    for requirement in $COMMON; do
      pkg install -y "$requirement" > /dev/null 2>&1
    done
  elif command_exists brew; then
    for requirement in $COMMON; do
      brew install "$requirement" > /dev/null 2>&1
    done
  elif command_exists apt; then
    for requirement in $COMMON; do
      sudo apt install -y "$requirement" > /dev/null 2>&1
    done
  fi

  printf "%s Installing of requirements %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

main() {
  setup_color
  clear

  printf "\n%s let's do some %s%sM%sA%sG%sI%sC%s\n%s\n" "$PIPE0" "$BOLD" "$RED" "$ORANGE" "$YELLOW" "$L_GREEN" "$PURPLE" "$RESET" "$PIPE"

  check_termux
  updating_system
  install_requirements

  printf "%s %sCongratulations!! %s we successfully configured %s%s a lot!%s\n" "$PIPE0" "$L_GREEN" "$L_BLUE" "$BOLD" "$YELLOW" "$RESET"
}




#main() {
#	# check if termux [termux_install & exit || pass]
#	case "$PREFIX" in
#    	*com.termux*) termux=true ;;
#    	*) termux=false ;;
#  	esac
#
#    if [ "$termux" == true ]; then
#	    pkg install -y libllvm git make build-essential
#	    git clone https://github.com/m-v-kalashnikov/setup-files.git
#	    cd setup-files && make termux_all
#		exit 0
#	fi
#
#	# check if apt exists [apt_install & exit || pass]
#	APT_PATH=""
#    which apt >> APT_PATH
#
#    case "$APT_PATH" in
#    	*apt*) apt=true ;;
#    	*) apt=false ;;
#  	esac
#
#	if [ "$apt" == true ]; then
#	    apt install -y libllvm git make build-essential
#	    git clone https://github.com/m-v-kalashnikov/setup-files.git
#	    cd setup-files && make termux_all
#		exit 0
#	fi
#
#	echo "This script wasn't designed for your system!"
#	exit 1
#}
#
main

#!/bin/sh

set -e

# Default settings
REPO=${REPO:-m-v-kalashnikov/setup-files}
REMOTE=${REMOTE:-https://github.com/${REPO}.git}
BRANCH=${BRANCH:-main}


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

  sudo apt update > /dev/null 2>&1
  sudo apt -y upgrade > /dev/null 2>&1
  sudo apt -y autoclean > /dev/null 2>&1
  sudo apt -y autoremove > /dev/null 2>&1

  printf "%s Updating of system %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

install_apt() {
#  sudo apt install -y "$@" > /dev/null 2>&1
  sudo apt install -y "$@"
}

setup_custom_config() {
  printf "%s Custom config setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  install_apt curl

  sudo rm -rf "$HOME"/.custom
  mkdir -p "$HOME"/.custom

  curl "https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/aliases.sh" --output "$HOME"/.custom/aliases.sh > /dev/null 2>&1
  curl "https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/configs.sh" --output "$HOME"/.custom/configs.sh > /dev/null 2>&1

  printf "%s Custom config setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

setup_zsh() {
  printf "%s ZSH setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  install_apt curl zsh

  cd "$HOME"
  sudo rm -rf "$HOME"/.oh-my-zs*
  sudo rm -rf "$(ls -a | grep zsh)"
  sudo rm -rf "$ZSH"
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh > /dev/null 2>&1
  sudo chsh -s "$(which zsh)"
  echo "\nif [[ -f $HOME/.custom/configs.sh ]]; then\n\tsource $HOME/.custom/configs.sh\nfi" >> "$HOME"/.zshrc

  printf "%s ZSH setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

setup_tmux() {
  printf "%s TMUX setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  install_apt git tmux

  cd "$HOME"
  sudo rm -rf "$(ls -a | grep tmux)"
  sudo rm -rf "$HOME"/.tmu*
  git clone https://github.com/gpakosz/.tmux.git > /dev/null 2>&1
  sudo ln -s -f .tmux/.tmux.conf
  sudo cp .tmux/.tmux.conf.local "$HOME"

  printf "%s TMUX setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

setup_vim() {
  printf "%s VIM setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  install_apt git curl vim

  cd "$HOME"
  sudo rm -rf "$(ls -a | grep vim)"
  sudo rm -rf "$HOME"/.vi*
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim > /dev/null 2>&1
  curl --silent --output .vimrc https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/.vimrc > /dev/null 2>&1
  vim +PluginInstall! +PluginClean! +qall

  printf "%s VIM setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

setup_go() {
  printf "%s GO setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  install_apt curl

  cd "$HOME"
  GO_ARCHIVE="go1.17.7.linux-amd64.tar.gz"
  GO_SLINK="https://dl.google.com/go/$GO_ARCHIVE"
  sudo rm -rf /usr/local/go
  curl -LO $GO_SLINK > /dev/null 2>&1
  sudo tar -C /usr/local -xzf "$GO_ARCHIVE" > /dev/null 2>&1
  echo '\n\n# go configurations\nexport GOPATH="$HOME/go"\nexport PATH="$PATH:/$GOPATH/bin"\nexport PATH="$PATH:/usr/local/go/bin"\n' >> "$HOME"/.custom/configs.sh
  . "$HOME"/.custom/configs.sh
  sudo rm -rf "$GO_ARCHIVE"

  printf "%s GO setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}

setup_bombardier() {
  printf "%s Bombardier setup %s%sstarted...%s\n%s\n%s" "$PIPE1" "$BOLD" "$M_GREEN" "$RESET" "$PIPE1" "$RESET"

  cd "$HOME"
#  go install github.com/codesenberg/bombardier@latest > /dev/null 2>&1
  go install github.com/codesenberg/bombardier@latest

  DURATION='--duration=10h'
  CONNECTIONS='--connections=300'
  RATE_LIMIT='--rate=1000'
  HEADERS='--header="user-agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/98.0.4758.109"'
  echo "\n\n# bombardier alias\nalias boom='clear && bombardier --latencies --http2 $CONNECTIONS $HEADERS $DURATION $RATE_LIMIT'\n" >> "$HOME"/.custom/aliases.sh

  printf "%s Bombardier setup %s%sfinished!%s\n%s\n%s" "$PIPE1" "$BOLD" "$L_GREEN" "$RESET" "$PIPE" "$RESET"
}



main() {
  setup_color
  clear

  printf "\n%s let's do some %s%sM%sA%sG%sI%sC%s\n%s\n" "$PIPE0" "$BOLD" "$RED" "$ORANGE" "$YELLOW" "$L_GREEN" "$PURPLE" "$RESET" "$PIPE"

  updating_system

  install_apt curl git

  setup_custom_config
  setup_zsh
  setup_tmux
  setup_go
#  setup_bombardier
  setup_vim

  . "$HOME"/.custom/configs.sh

  printf "%s %sCongratulations!! %s we successfully configured %s%s a lot!%s\n" "$PIPE0" "$L_GREEN" "$L_BLUE" "$BOLD" "$YELLOW" "$RESET"
#  sudo reboot
}

main
#!/bin/sh

set -e

install_db1000n() {
  cd "$HOME"
  export OSTYPE
  curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh | sh -s
  rm -rf "$HOME"/db1000n-*
}

setup_tmux() {
  git clone https://github.com/gpakosz/.tmux.git > /dev/null 2>&1
  sudo ln -s -f .tmux/.tmux.conf
  sudo cp .tmux/.tmux.conf.local "$HOME"
}

run_multiplex() {
  tmux new -s multiplex -d
  tmux split-window -h -t multiplex:0.0
  tmux split-window -v -t multiplex:0.1
  tmux split-window -v -t multiplex:0.1
  tmux split-window -v -t multiplex:0.2

  tmux send-keys -t multiplex:0.1 '"$HOME"/db1000n' Enter
  tmux send-keys -t multiplex:0.2 '"$HOME"/db1000n' Enter
  tmux send-keys -t multiplex:0.3 '"$HOME"/db1000n' Enter
  tmux send-keys -t multiplex:0.4 '"$HOME"/db1000n' Enter
}

INSTALL_DB1000N=yes
RUN_MULTIPLEX=yes
SETUP_TMUX=yes

main() {
  # Parse arguments
  while [ $# -gt 0 ]; do
    case $1 in
      --no-install-db1000n) INSTALL_DB1000N=no ;;
      --no-run-multiplex) RUN_MULTIPLEX=no ;;
      --no-setup-tmux) SETUP_TMUX=no ;;
    esac
    shift
  done

  if [ $INSTALL_DB1000N = yes ]; then
    install_db1000n
  fi

  if [ $RUN_MULTIPLEX = yes ]; then
    run_multiplex
  fi

  if [ $SETUP_TMUX = yes ]; then
    setup_tmux
  fi
}

main "$@"

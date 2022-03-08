#!/bin/sh

upadte_db1000n() {
  rm -rf ~/db1000n
  source <(curl https://raw.githubusercontent.com/Arriven/db1000n/main/install.sh)
  rm -rf db1000n-* md5*
}

clear() {
  tmux kill-session -t multiplex
  tmux new-session -ADs multiplex -d
}

run_in_pane() {
  i=1
  tmux new-window -t multiplex "$2"

  while [ $i -lt "$1" ]
  do
    tmux split-window -t multiplex:2 "$2"
    tmux select-layout -t multiplex:2 tiled

    i=$((i+1))
  done
}

main() {
  upadte_db1000n
  clear
  run_in_pane "$1" "$2"
  tmux new-window -t multiplex "$3"
  tmux kill-window -t multiplex:1
}

main "$1" "$2" "$3"


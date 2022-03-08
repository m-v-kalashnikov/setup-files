#!/bin/sh

set -e

clear() {
  {
    tmux kill-session -t multiplex > /dev/null 2>&1
  } || {
    true
  }
}

run_in_pane() {
  i=0

  while [ $i -lt "$1" ]
  do
    tmux new-window -t multiplex "$2"

    i=$((i+1))
  done
}

main() {
  clear
  tmux new-session -ADs multiplex -d "$3"
  run_in_pane "$1" "$2"
}

main "$1" "$2" "$3"


#!/bin/sh

set -e


# make grep output colorful
alias grep="grep --color=auto"


# update shortcut
alias update="sudo apt update && sudo apt -y upgrade && sudo apt -y autoclean && sudo apt -y autoremove"

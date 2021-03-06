#!/bin/sh

set -e

INSTALL=yes
RUN=yes

updating_system() {
  sudo apt update > /dev/null 2>&1
  sudo apt -y upgrade > /dev/null 2>&1
  sudo apt -y autoclean > /dev/null 2>&1
  sudo apt -y autoremove > /dev/null 2>&1
}

install_apt() {
  sudo apt install -y "$@" > /dev/null 2>&1
}

remove_apt() {
  {
    sudo apt remove "$@" > /dev/null 2>&1
  } || {
    true
  }
}


install_docker() {
  updating_system

  CLEAN="docker docker-engine docker.io containerd runc"

  for to_clean in $CLEAN; do
    remove_apt "$to_clean"
  done

  updating_system
  install_apt ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --yes --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  updating_system
  install_apt docker-ce docker-ce-cli containerd.io
  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"

  updating_system
}

run_db1000n() {
  newgrp docker
  if ! sudo docker ps | grep "db1000n" > /dev/null 2>&1; then
    if sudo docker ps --all | grep "db1000n" > /dev/null 2>&1; then
      sudo docker rm db1000n > /dev/null 2>&1
    fi
    sudo docker run --name db1000n --restart unless-stopped -d ghcr.io/arriven/db1000n > /dev/null 2>&1
  fi
}

main() {
  # Parse arguments
  while [ $# -gt 0 ]; do
    case $1 in
      --skip-install) INSTALL=no ;;
      --skip-run) RUN=no ;;
    esac
    shift
  done

  if [ $INSTALL = yes ]; then
    install_docker
  fi

  if [ $RUN = yes ]; then
    run_db1000n
  fi
}

main "$@"

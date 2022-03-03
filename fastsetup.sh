#!/bin/sh

set -e

updating_system() {
  sudo apt update > /dev/null 2>&1
  sudo apt -y upgrade > /dev/null 2>&1
  sudo apt -y autoclean > /dev/null 2>&1
  sudo apt -y autoremove > /dev/null 2>&1
}

install_apt() {
  sudo apt install -y "$@" > /dev/null 2>&1
}

install_docker() {
  updating_system

  sudo apt remove docker docker-engine docker.io containerd runc > /dev/null 2>&1

  updating_system
  install_apt ca-certificates curl gnupg lsb-release
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

  updating_system
  install_apt docker-ce docker-ce-cli containerd.io
  sudo groupadd -f docker
  sudo usermod -aG docker "$USER"

  updating_system

  sudo docker run --name db1000n -d ghcr.io/arriven/db1000n
}

run_db1000n() {
  if docker ps | grep "db1000n" > /dev/null 2>&1; then
    echo "Running..."
  else
    echo "Will run..."
    sudo docker run --name db1000n -d ghcr.io/arriven/db1000n
  fi
}

install_docker
run_db1000n
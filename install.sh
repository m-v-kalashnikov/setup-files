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

sudo apt install -y gcc git make build-essential
git clone https://github.com/m-v-kalashnikov/setup-files.git
cd setup-files && make ubuntu_all

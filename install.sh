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

main() {
	# check if termux [termux_install & exit || pass]
	case "$PREFIX" in
    	*com.termux*) termux=true ;;
    	*) termux=false ;;
  	esac

    if [ "$termux" == true ]; then
	    pkg install -y libllvm git make build-essential
	    git clone https://github.com/m-v-kalashnikov/setup-files.git
	    cd setup-files && make termux_all
		exit 0
	fi
	
	# check if apt exists [apt_install & exit || pass]
	APT_PATH=""
    which apt >> APT_PATH

    case "$APT_PATH" in
    	*apt*) apt=true ;;
    	*) apt=false ;;
  	esac
	
	if [ "$apt" == true ]; then
	    apt install -y libllvm git make build-essential
	    git clone https://github.com/m-v-kalashnikov/setup-files.git
	    cd setup-files && make termux_all
		exit 0
	fi
	
	echo "This script wasn't designed for your system!"
	exit 1
}

main

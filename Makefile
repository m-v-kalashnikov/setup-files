all:
	echo "Hello, World!"

start:
	echo -e "\033[0;96m Process started... \033[0m\n" && \
	cd $$HOME

finish:
	echo -e "\n\033[0;92m Process success! \033[0m"



ubuntu_all: start ubuntu_system_update ubuntu_install_reuirements ubuntu_zsh_full ubuntu_tmux_full ubuntu_vim_full finish

ubuntu_system_update:
	echo -e "\n\033[0;96m\t Updating system... \033[0m\n" && \
	sudo apt update && \
	sudo apt -y upgrade && \
	sudo apt -y autoclean && \
	sudo apt -y autoremove && \
	echo -e "\n\033[0;92m\t Updating system success! \033[0m\n"

ubuntu_install_reuirements:
	echo -e "\n\033[0;96m\t Installing required packages... \033[0m\n" && \
	sudo apt install -y gcc && \
	sudo apt install -y git && \
	sudo apt install -y vim && \
	sudo apt install -y zip && \
	sudo apt install -y zsh && \
	sudo apt install -y curl && \
	sudo apt install -y htop && \
	sudo apt install -y llvm && \
	sudo apt install -y make && \
	sudo apt install -y mosh && \
	sudo apt install -y wget && \
	sudo apt install -y tree && \
	sudo apt install -y tmux && \
	sudo apt install -y nginx && \
	sudo apt install -y unzip && \
	sudo apt install -y tk-dev && \
	sudo apt install -y xz-utils && \
	sudo apt install -y gnumeric && \
	sudo apt install -y libpq-dev && \
	sudo apt install -y python-dev && \
	sudo apt install -y libbz2-dev && \
	sudo apt install -y libffi-dev && \
	sudo apt install -y libssl-dev && \
	sudo apt install -y supervisor && \
	sudo apt install -y zlib1g-dev && \
	sudo apt install -y python3-dev && \
	sudo apt install -y libjpeg-dev && \
	sudo apt install -y liblzma-dev && \
	sudo apt install -y libxslt-dev && \
	sudo apt install -y libxml2-dev && \
	sudo apt install -y redis-server && \
	sudo apt install -y libxslt1-dev && \
	sudo apt install -y python3-lxml && \
	sudo apt install -y libsqlite3-dev && \
	sudo apt install -y build-essential && \
	sudo apt install -y libreadline-dev && \
	sudo apt install -y libncurses5-dev && \
	sudo apt install -y libfreetype6-dev && \
	sudo apt install -y libncursesw5-dev && \
	sudo apt install -y libcurl4-openssl-dev && \
	echo -e "\n\033[0;92m\t Installing required packages success! \033[0m\n"

ubuntu_zsh_clear:
	echo -e "\n\n\033[0;96m\t ZSH clearing... \033[0m\n\n" && \
	sudo rm -rf $(ls -a | grep zsh) && \
	echo -e "\n\n\033[0;92m\t ZSH clearing success! \033[0m"

ubuntu_zsh_install:
	echo -e "\n\n\033[0;96m\t ZSH installing... \033[0m\n\n" && \
	curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh && \
	echo -e "\n\n\033[0;92m\t ZSH installing success! \033[0m"

ubuntu_zsh_setup:
	echo -e "\n\033[0;96m\t ZSH setuping... \033[0m\n" && \
	chsh -s $(which zsh) && \
	echo "if [ -f ~/.custom/configrc ]: then\n source ~/.custom/configrc\nfi" >> ~/.zshrc && \
	echo -e "\n\033[0;92m\t ZSH setuping success! \033[0m\n"

ubuntu_zsh_full: ubuntu_zsh_clear ubuntu_zsh_install ubuntu_zsh_setup

ubuntu_tmux_clear:
	echo -e "\n\n\033[0;96m\t TMUX clearing... \033[0m\n\n" && \
	sudo rm -rf $(ls -a | grep tmux) && \
	echo -e "\n\n\033[0;92m\t TMUX clearing success! \033[0m"

ubuntu_tmux_install:
	echo -e "\n\n\033[0;96m\t TMUX installing... \033[0m\n\n" && \
	git clone https://github.com/gpakosz/.tmux.git && \
	echo -e "\n\n\033[0;92m\t TMUX installing success! \033[0m"

ubuntu_tmux_setup:
	echo -e "\n\033[0;96m\t TMUX setuping... \033[0m\n" && \
	sudo ln -s -f .tmux/.tmux.conf && \
	sudo cp .tmux/.tmux.conf.local . && \
	echo -e "\n\033[0;92m\t TMUX setuping success! \033[0m\n"

ubuntu_tmux_full: ubuntu_tmux_clear ubuntu_tmux_install ubuntu_tmux_setup

ubuntu_vim_clear:
	echo -e "\n\n\033[0;96m\t VIM clearing... \033[0m\n\n" && \
	sudo rm -rf $(ls -a | grep vim) && \
	echo -e "\n\n\033[0;92m\t VIM clearing success! \033[0m"

ubuntu_vim_install:
	echo -e "\n\n\033[0;96m\t VIM installing... \033[0m\n\n" && \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
	curl --silent --output .vimrc https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/.vimrc && \
	echo -e "\n\n\033[0;92m\t VIM installing success! \033[0m"

ubuntu_vim_setup:
	echo -e "\n\033[0;96m\t VIM setuping... \033[0m\n" && \
	vim +PluginInstall +qall && \
	echo -e "\n\033[0;92m\t VIM setuping success! \033[0m\n"

ubuntu_vim_full: ubuntu_vim_clear ubuntu_vim_install ubuntu_vim_setup




termux_all: start termux_system_update termux_install_reuirements termux_zsh_full termux_tmux_full termux_vim_full finish

termux_system_update:
	echo -e "\n\033[0;96m\t Updating system... \033[0m\n" && \
	pkg update && \
	pkg upgrade && \
	pkg autoclean && \
	echo -e "\n\033[0;92m\t Updating system success! \033[0m\n"

termux_install_reuirements:
	echo -e "\n\033[0;96m\t Installing required packages... \033[0m\n" && \
	pkg install -y libllvm && \
	pkg install -y git && \
	pkg install -y vim && \
	pkg install -y zip && \
	pkg install -y zsh && \
	pkg install -y curl && \
	pkg install -y htop && \
	pkg install -y llvm && \
	pkg install -y make && \
	pkg install -y mosh && \
	pkg install -y wget && \
	pkg install -y tree && \
	pkg install -y tmux && \
	pkg install -y nginx && \
	pkg install -y unzip && \
	pkg install -y libbz2 && \
	pkg install -y libffi && \
	pkg install -y liblzma && \
	pkg install -y libxml2 && \
	pkg install -y xz-utils && \
	pkg install -y build-essential && \
	echo -e "\n\033[0;92m\t Installing required packages success! \033[0m\n"

termux_zsh_clear:
	echo -e "\n\n\033[0;96m\t ZSH clearing... \033[0m\n\n" && \
	rm -rf $(ls -a | grep zsh) && \
	echo -e "\n\n\033[0;92m\t ZSH clearing success! \033[0m"

termux_zsh_install:
	echo -e "\n\n\033[0;96m\t ZSH installing... \033[0m\n\n" && \
	curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh && \
	echo -e "\n\n\033[0;92m\t ZSH installing success! \033[0m"

termux_zsh_setup:
	echo -e "\n\033[0;96m\t ZSH setuping... \033[0m\n" && \
	chsh -s $(which zsh) && \
	echo "if [ -f ~/.custom/configrc ]: then\n source ~/.custom/configrc\nfi" >> ~/.zshrc && \
	echo -e "\n\033[0;92m\t ZSH setuping success! \033[0m\n"

termux_zsh_full: termux_zsh_clear termux_zsh_install termux_zsh_setup

termux_tmux_clear:
	echo -e "\n\n\033[0;96m\t TMUX clearing... \033[0m\n\n" && \
	rm -rf $(ls -a | grep tmux) && \
	echo -e "\n\n\033[0;92m\t TMUX clearing success! \033[0m"

termux_tmux_install:
	echo -e "\n\n\033[0;96m\t TMUX installing... \033[0m\n\n" && \
	git clone https://github.com/gpakosz/.tmux.git && \
	echo -e "\n\n\033[0;92m\t TMUX installing success! \033[0m"

termux_tmux_setup:
	echo -e "\n\033[0;96m\t TMUX setuping... \033[0m\n" && \
	ln -s -f .tmux/.tmux.conf && \
	cp .tmux/.tmux.conf.local . && \
	echo -e "\n\033[0;92m\t TMUX setuping success! \033[0m\n"

termux_tmux_full: termux_tmux_clear termux_tmux_install termux_tmux_setup

termux_vim_clear:
	echo -e "\n\n\033[0;96m\t VIM clearing... \033[0m\n\n" && \
	rm -rf $(ls -a | grep vim) && \
	echo -e "\n\n\033[0;92m\t VIM clearing success! \033[0m"

termux_vim_install:
	echo -e "\n\n\033[0;96m\t VIM installing... \033[0m\n\n" && \
	git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
	curl --silent --output .vimrc https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/.vimrc && \
	echo -e "\n\n\033[0;92m\t VIM installing success! \033[0m"

termux_vim_setup:
	echo -e "\n\033[0;96m\t VIM setuping... \033[0m\n" && \
	vim +PluginInstall +qall && \
	echo -e "\n\033[0;92m\t VIM setuping success! \033[0m\n"

termux_vim_full: termux_vim_clear termux_vim_install termux_vim_setup

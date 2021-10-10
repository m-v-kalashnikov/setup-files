all: start system_update install_reuirements zsh_full tmux_full vim_full finish
  
start:
  echo -e "\033[0;96m Process started... \033[0m\n"

finish:
  echo -e "\n\033[0;92m Process success! \033[0m"  
  
system_update:
  echo -e "\n\033[0;96m\t Updating system... \033[0m\n" && \
  sudo apt update && \
  sudo apt -y upgrade && \
  sudo apt -y autoclean && \
  sudo apt -y autoremove
  echo -e "\n\033[0;92m\t Updating system success! \033[0m\n" && \
  
install_reuirements:
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

zsh_clear:
  echo -e "\n\n\033[0;96m\t ZSH clearing... \033[0m\n\n" && \
  sudo rm -rf $(ls -a | grep zsh)
  echo -e "\n\n\033[0;92m\t ZSH clearing success! \033[0m"

zsh_install:
  echo -e "\n\n\033[0;96m\t ZSH installing... \033[0m\n\n" && \
  curl -L https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh | sh && \
  echo -e "\n\n\033[0;92m\t ZSH installing success! \033[0m"

zsh_setup:
  echo -e "\n\033[0;96m\t ZSH setuping... \033[0m\n" && \
  chsh -s $(which zsh) && \
  echo "if [ -f ~/.custom/configrc ]: then\n source ~/.custom/configrc\nfi" >> ~/.zshrc
  echo -e "\n\033[0;92m\t ZSH setuping success! \033[0m\n"
  
zsh_full: zsh_clear zsh_install zsh_setup

tmux_clear:
  echo -e "\n\n\033[0;96m\t TMUX clearing... \033[0m\n\n" && \
  sudo rm -rf ~/.tmux && \
  echo -e "\n\n\033[0;92m\t TMUX clearing success! \033[0m"

tmux_install:
  echo -e "\n\n\033[0;96m\t TMUX installing... \033[0m\n\n" && \
  git clone https://github.com/gpakosz/.tmux.git && \
  echo -e "\n\n\033[0;92m\t TMUX installing success! \033[0m"

tmux_setup:
  echo -e "\n\033[0;96m\t TMUX setuping... \033[0m\n" && \
  sudo ln -s -f .tmux/.tmux.conf && \
  sudo cp .tmux/.tmux.conf.local . && \
  echo -e "\n\033[0;92m\t TMUX setuping success! \033[0m\n"
  
tmux_full: tmux_clear tmux_install tmux_setup

vim_clear:
  echo -e "\n\n\033[0;96m\t VIM clearing... \033[0m\n\n" && \
  sudo rm -rf \
      ~/.vim/bundle/Vundle.vim \
      ~/.vimrc \
      && \
  echo -e "\n\n\033[0;92m\t VIM clearing success! \033[0m"

vim_install:
  echo -e "\n\n\033[0;96m\t VIM installing... \033[0m\n\n" && \
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
  curl --silent --output .vimrc https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/.vimrc && \
  echo -e "\n\n\033[0;92m\t VIM installing success! \033[0m"

vim_setup:
  echo -e "\n\033[0;96m\t VIM setuping... \033[0m\n" && \
  sudo rm -rf \
      ~/.vim/bundle/Vundle.vim \
      ~/.vimrc \
      && \
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim && \
  curl --silent --output .vimrc https://raw.githubusercontent.com/m-v-kalashnikov/setup-files/main/.vimrc && \
  vim +PluginInstall +qall && \
  echo -e "\n\033[0;92m\t VIM setuping success! \033[0m\n"

vim_full: vim_clear vim_install vim_setup
  

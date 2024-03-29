#!/bin/zsh

# Install brew if necessary
if ! which brew
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Brewfile
brew update
brew tap homebrew/bundle
brew bundle --file=./Brewfile
brew cleanup
brew cask cleanup

# OSX
source $DOTFILES/.osx

# ZSH
chsh -s $(which zsh)
sh -c "$(wget https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"
[ ! -f $HOME/.zshrc ] && ln -nfs $HOME/dotfiles/.zshrc $HOME/.zshrc
source $HOME/.zshrc

# Anaconda
/opt/homebrew/anaconda3/bin/conda init zsh
source ~/.zshrc
conda config --set auto_activate_base false

# Poetry
mkdir $ZSH/plugins/poetry
poetry completions zsh > $ZSH/plugins/poetry/_poetry

# Pyenv
pyenv install 3.9.0
pyenv global 3.9.0 

# vimrc
vimrc_path="$HOME/.vimrc"
echo "set backspace=indent,eol,start" >> "$vimrc_path"
echo "Vim 설정이 업데이트되었습니다."

# .alias, .exports
[ ! -f $HOME/.alias ] && ln -nfs $HOME/dotfiles/.alias $HOME/.alias
[ ! -f $HOME/.exports ] && ln -nfs $HOME/dotfiles/.exports $HOME/.exports

printf '\n install success! \n'

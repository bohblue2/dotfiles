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

printf '\n install success! \n'

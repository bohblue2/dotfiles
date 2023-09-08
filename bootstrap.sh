
# Install brew if necessary
if ! which brew
then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Install Brewfile
brew bundle --file=./Brewfile

source $DOTFILES/.osx

printf '\n install success! \n'

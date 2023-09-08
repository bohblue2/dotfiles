export ZSH="${HOME}/.oh-my-zsh"

ZSH_THEME="robbyrussell"

source ${HOME}/.oh-my-zsh/antigen.zsh

antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle command-not-found
antigen bundle docker
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle zsh-users/zsh-completions
antigen bundle zsh-users/zsh-autosuggestions
antigen theme robbyrussell
antigen apply

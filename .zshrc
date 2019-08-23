#
# Executes commands at the start of an interactive session.
#
# Authors:
#   Sorin Ionescu <sorin.ionescu@gmail.com>
#

# Source Prezto.
if [[ -s "${ZDOTDIR:-$HOME}/.zprezto/init.zsh" ]]; then
  source "${ZDOTDIR:-$HOME}/.zprezto/init.zsh"
fi

source $HOME/.alias
source $HOME/.env
source $HOME/.functions

# Fix rm
unalias rm
alias rm="nocorrect rm"

# Fix cp
setopt clobber

# Autojump init
. .z_source/z.sh

# direnv
eval "$(direnv hook zsh)"

# Google Cloud SDK
if [ "$(uname -s)" '==' "Darwin" ]; then
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/completion.zsh.inc'
    source '/usr/local/Caskroom/google-cloud-sdk/latest/google-cloud-sdk/path.zsh.inc'
fi

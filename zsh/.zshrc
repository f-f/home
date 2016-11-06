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
. /usr/share/autojump/autojump.sh

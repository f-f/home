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

# Autocompletions
fpath=(~/.completions $fpath)
compinit

# Fix rm
unalias rm
alias rm="nocorrect rm"

# Fix cp
unalias cp
setopt clobber

# More alias
alias sysd="sudo systemctl"
alias ob="obsidian &"

# Autojump init
. ~/.z_source/z.sh

# direnv
eval "$(direnv hook zsh)"

# Cargo
export PATH="$PATH:$HOME/.cargo/bin"

# Erlang
export ERL_AFLAGS="-kernel shell_history enabled"

# NPM
NPM_PACKAGES="${HOME}/.npm-packages"
export PATH="$PATH:$NPM_PACKAGES/bin"
export NODE_PATH=~/.npm-packages/lib/node_modules

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

BR="/home/fabrizio/.config/broot/launcher/bash/br"
if test -f $BR; then
  source /home/fabrizio/.config/broot/launcher/bash/br
fi

# Homebrew
export PATH="/opt/homebrew/bin:$PATH"
export XDG_DATA_DIRS="/opt/homebrew/share:$XDG_DATA_DIRS"

## Patch the Paradox theme to display different colors on different hosts
function host_color {
  case "${HOST}" in
    augustus)  echo red ;;
    caesar)    echo green ;;
    claudius)  echo cyan ;;
    domitian)  echo yellow ;;
    nerva)     echo magenta ;;
    trajan)    echo 166 ;; # orange
    nero)      echo blue ;;
    tiberius)  echo 118 ;; # limegreen
    aurelius)  echo 135 ;; # purple
    *)         echo white ;;
  esac
}

## This is the secondary color, defaults to a nondescript blueish
function host_color2 {
  case "${HOST}" in
    augustus)  echo 75 ;;
    caesar)    echo 75 ;;
    claudius)  echo 75 ;;
    domitian)  echo 75 ;;
    nerva)     echo 75 ;;
    trajan)    echo 75 ;;
    nero)      echo 75 ;;
    tiberius)  echo magenta ;;
    aurelius)  echo 11 ;; # yellow
    *)         echo 75 ;;
  esac
}

# For more colors see: https://askubuntu.com/questions/27314/script-to-display-all-terminal-colors

function prompt_paradox_build_prompt {
  prompt_paradox_start_segment white black '%F{163}%D{%H}%F{176}:%F{163}%D{%M}%F{176}:%F{163}%D{%S}%f'
  prompt_paradox_start_segment black default '%(?::%F{red}✘ )%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)%F{$(host_color2)}%n%F{white}@%F{$(host_color)}%m%f'
  prompt_paradox_start_segment $(host_color2) black '$_prompt_paradox_pwd'

  if [[ -n "$git_info" ]]; then
    prompt_paradox_start_segment $(host_color) black '${(e)git_info[ref]}${(e)git_info[status]}'
  fi

  if [[ -n "$python_info" ]]; then
    prompt_paradox_start_segment white black '${(e)python_info[virtualenv]}'
  fi

  prompt_paradox_end_segment
}

RPROMPT=''

export PATH="$PATH:$HOME/.local/bin"

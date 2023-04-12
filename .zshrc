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

## Patch the Paradox theme to display different colors on different hosts
function host_color {
  case "${HOST}" in
    augustus) echo red ;;
    caesar) echo green ;;
    claudius) echo cyan ;;
    hadrianus) echo yellow ;;
    nerva) echo magenta ;;
    trajan) echo 166 ;; # orange
    nero) echo blue ;;
    tiberius) echo 118 ;; # limegreen
    *) echo white ;;
  esac
}

# Few more colors: 81 turquoise, 135 purple, 161 hotpink


function prompt_paradox_build_prompt {
  prompt_paradox_start_segment white black '%F{163}%D{%H}%F{176}:%F{163}%D{%M}%F{176}:%F{163}%D{%S}%f'
  prompt_paradox_start_segment black default '%(?::%F{red}✘ )%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)%F{75}%n%F{white}@%F{$(host_color)}%m%f'
  prompt_paradox_start_segment 75 black '$_prompt_paradox_pwd'

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

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

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

BR="/home/fabrizio/.config/broot/launcher/bash/br"
if test -f $BR; then
  source /home/fabrizio/.config/broot/launcher/bash/br
fi

## Patch the Paradox theme to display different colors on different hosts
function host_color {
  case "${HOST}" in
    augustus) echo yellow ;;
    caesar) echo green ;;
    claudius) echo cyan ;;
    nerva) echo magenta ;;
    trajan) echo red ;;
    *) echo white ;;
  esac
}

function prompt_paradox_build_prompt {
  prompt_paradox_start_segment black default '%(?::%F{red}✘ )%(!:%F{yellow}⚡ :)%(1j:%F{cyan}⚙ :)%F{blue}%n%F{white}@%F{$(host_color)}%m%f'
  prompt_paradox_start_segment blue black '$_prompt_paradox_pwd'

  if [[ -n "$git_info" ]]; then
    prompt_paradox_start_segment $(host_color) black '${(e)git_info[ref]}${(e)git_info[status]}'
  fi

  if [[ -n "$python_info" ]]; then
    prompt_paradox_start_segment white black '${(e)python_info[virtualenv]}'
  fi

  prompt_paradox_end_segment
}

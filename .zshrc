#!/usr/bin/env zsh
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

# Load Powerlevel10k instant prompt quietly
# typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${whoami}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${whoami}.zsh"
fi

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit $HOME/.p10k.zsh.
[[ ! -f $HOME/.p10k.zsh ]] || source $HOME/.p10k.zsh

#Custom Alias
alias p='cd $HOME/Desktop/projects'
alias t='cd $HOME/Desktop/testing'
alias r='cd $HOME/Desktop/repo'
alias ww='cd $HOME/Desktop/www'
alias v=nvim-kick
alias va=nvim-astro
alias c=clear
alias lg=lazygit
alias art='php artisan'
alias pn='pnpm'
alias pni='pnpm install'
alias pnd='pnpm dev'
alias pnb='pnpm build'
alias pns='pnpm start'

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"                   # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" # This loads nvm bash_completion
. "$HOME/.deno/env"

export PATH="/Users/hasib/.config/herd-lite/bin:$PATH"
export PHP_INI_SCAN_DIR="/Users/hasib/.config/herd-lite/bin:$PHP_INI_SCAN_DIR"
export PATH="$PATH:$(go env GOPATH)/bin"

# pnpm
export PNPM_HOME="/Users/hasib/Library/pnpm"
case ":$PATH:" in
*":$PNPM_HOME:"*) ;;
*) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end

# Config Switcher
alias nvim-kick="NVIM_APPNAME=kickstart nvim"
alias nvim-astro="NVIM_APPNAME=AstroNvim nvim"

function nvims() {
  items=("default" "kickstart" "AstroNvim")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config  " --height=~50% --layout=reverse --border --exit-0)
  if [[ -z $config ]]; then
    return 0
  elif [[ $config == "default" ]]; then
    config=""
  fi
  echo $config
  NVIM_APPNAME=$config nvim $@
}

bindkey -s ^a "nvims\n"

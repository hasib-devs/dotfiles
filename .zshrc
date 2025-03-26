#!/usr/bin/env zsh
# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

#Custom Alias
alias p='cd $HOME/projects'
alias t='cd $HOME/testing'
alias r='cd $HOME/repo'
alias ww='cd $HOME/www'
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

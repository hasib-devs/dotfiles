if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# Path to your Oh My Zsh installation.
export ZSH="$HOME/.oh-my-zsh"
# Add flutter to path
export PATH="$PATH:/Users/hasib/flutter/flutter/bin" 

ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting web-search)

source $ZSH/oh-my-zsh.sh

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

#Custom Alias
alias p='cd ~/Desktop/projects'
alias t='cd ~/Desktop/testing'
alias r='cd ~/Desktop/repo'
alias ww='cd ~/Desktop/www'
alias v=nvim
alias c=clear
alias lg=lazygit
alias art='php artisan'
alias pn='pnpm'
alias pni='pnpm install'
alias pnd='pnpm dev'
alias pnb='pnpm build'
alias pns='pnpm start'

# alias air='$(go env GOPATH)/bin/air'
# alias wails='$(go env GOPATH)/bin/wails'


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
. "/Users/hasib/.deno/env"
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


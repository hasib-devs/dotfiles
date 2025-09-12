# Dotfile

## Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install zsh, fzf, ripgrep, fd, lazygit
`brew install zsh fzf ripgrep fd lazygit`

# Install Oh My Zsh
`sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

# Auto suggestion plugin
`git clone https://github.com/zsh-users/zsh-autosuggestions.git $ZSH_CUSTOM/plugins/zsh-autosuggestions`

# Syntax highlighting plugin
`git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $ZSH_CUSTOM/plugins/zsh-syntax-highlighting`

# Install fzf-tab plugin
`git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab`

## Install MongoDB Homebrew Tap
`brew tap mongodb/brew`
`brew install mongodb-community`

# Install Redis
`brew install redis`

# Enable keyrepeat for browser
`defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false`

# Key Repeat speed
`defaults write -g InitialKeyRepeat -float 10.0`
`defaults write -g KeyRepeat -float 1.0`


## Vim-style Folding Commands:
```
zc: Fold the code block at the cursor's current position.
zo: Unfold the code block at the cursor's current position.
za: Toggle the fold state (fold or unfold) at the cursor's current position.
zf: Create a manual fold from a selected range of lines (enter visual mode v, select lines, then zf).
zd: Delete a manual fold at the cursor's current position.
zC: Fold recursively (folds the current region and all nested regions). 
zO: Unfold recursively (unfolds the current region and all nested regions). 
zm: Fold more (increases the fold level).
zr: Unfold more (decreases the fold level).
zM: Fold all regions in the editor.
zR: Unfold all regions in the editor.```
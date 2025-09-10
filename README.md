# Dotfile

## Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install zsh, fzf
`brew install zsh fzf`

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
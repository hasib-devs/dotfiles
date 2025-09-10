# Dotfile

## Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

## Install MongoDB Homebrew Tap
`brew tap mongodb/brew`

`brew install mongodb-community`


# Enable keyrepeat for browser
`defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false`

# Key Repeat speed
`defaults write -g InitialKeyRepeat -float 10.0`
`defaults write -g KeyRepeat -float 1.0`
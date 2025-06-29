#!/bin/bash

# =============================================================================
# macOS Setup Script
# =============================================================================
# This script sets up a fresh macOS system with all necessary development tools.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Setting up macOS..."

# Install Homebrew if not present
install_homebrew() {
  log_info "Checking for Homebrew..."

  if ! command -v brew &>/dev/null; then
    log_info "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [[ $(uname -m) == "arm64" ]]; then
      echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>~/.zprofile
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi

    log_success "Homebrew installed successfully"
  else
    log_info "Homebrew is already installed"
  fi

  # Update Homebrew
  log_info "Updating Homebrew..."
  brew update
}

# Install essential tools
install_essential_tools() {
  log_info "Installing essential development tools..."

  # Core tools
  local core_tools=(
    "git"
    "curl"
    "wget"
    "tree"
    "htop"
    "jq"
    "fzf"
    "ripgrep"
    "fd"
    "bat"
    "exa"
    "tldr"
    "tmux"
    "zsh"
    "zsh-completions"
    "zsh-syntax-highlighting"
    "zsh-autosuggestions"
  )

  for tool in "${core_tools[@]}"; do
    if ! brew list "$tool" &>/dev/null; then
      log_info "Installing $tool..."
      brew install "$tool"
    else
      log_info "$tool is already installed"
    fi
  done
}

# Install programming languages and tools
install_programming_tools() {
  log_info "Installing programming languages and tools..."

  # Node.js and npm via NVM
  if ! command -v node &>/dev/null; then
    log_info "Installing Node.js via NVM..."

    # Install NVM
    if [[ ! -d "$HOME/.nvm" ]]; then
      log_info "Installing NVM..."
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

      # Source NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi

    # Source NVM in current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node

    log_success "Node.js $(node --version) installed via NVM"
  else
    log_info "Node.js is already installed"
  fi

  # Install pnpm
  if ! command -v pnpm &>/dev/null; then
    log_info "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # Source pnpm
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"

    log_success "pnpm installed"
  else
    log_info "pnpm is already installed"
  fi

  # Python
  if ! command -v python3 &>/dev/null; then
    log_info "Installing Python..."
    brew install python
  fi

  # PHP 8.4 with extensions
  if ! command -v php &>/dev/null; then
    log_info "Installing PHP 8.4..."

    # Add PHP repository
    brew tap shivammathur/php

    # Install PHP 8.4
    brew install shivammathur/php/php@8.4

    # Link PHP 8.4
    brew link php@8.4 --force

    # Install PHP extensions
    log_info "Installing PHP extensions..."
    pecl install redis
    pecl install xdebug
    pecl install imagick

    # Install Composer
    if ! command -v composer &>/dev/null; then
      log_info "Installing Composer..."
      curl -sS https://getcomposer.org/installer | php
      sudo mv composer.phar /usr/local/bin/composer
      chmod +x /usr/local/bin/composer
    fi

    log_success "PHP 8.4 with extensions installed"
  else
    log_info "PHP is already installed"
  fi

  # Go (install from official source for latest version)
  if ! command -v go &>/dev/null; then
    log_info "Installing Go from official source..."
    local go_version="1.21.0"
    local arch="amd64"

    if [[ $(uname -m) == "arm64" ]]; then
      arch="arm64"
    fi

    curl -fsSL "https://go.dev/dl/go${go_version}.darwin-${arch}.pkg" -o /tmp/go.pkg
    sudo installer -pkg /tmp/go.pkg -target /
    rm /tmp/go.pkg

    log_success "Go $(go version) installed from official source"
  else
    log_info "Go is already installed"
  fi

  # Rust
  if ! command -v rustc &>/dev/null; then
    log_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
  fi

  # Neovim
  if ! command -v nvim &>/dev/null; then
    log_info "Installing Neovim..."
    brew install neovim
  fi

  # Docker (install from official source for latest version)
  if ! command -v docker &>/dev/null; then
    log_info "Installing Docker from official source..."
    # Download Docker Desktop for macOS
    curl -fsSL "https://desktop.docker.com/mac/main/amd64/Docker.dmg" -o /tmp/Docker.dmg
    hdiutil attach /tmp/Docker.dmg
    cp -R "/Volumes/Docker/Docker.app" /Applications/
    hdiutil detach "/Volumes/Docker"
    rm /tmp/Docker.dmg

    log_success "Docker installed from official source"
    log_info "Please start Docker Desktop from Applications folder"
  else
    log_info "Docker is already installed"
  fi

  # Install additional development tools from official sources
  install_dev_tools_from_official_sources
}

# Install development tools from official sources
install_dev_tools_from_official_sources() {
  log_info "Installing development tools from official sources..."

  # Terraform
  if ! command -v terraform &>/dev/null; then
    log_info "Installing Terraform..."
    local tf_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version')
    curl -fsSL "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_darwin_amd64.zip" -o /tmp/terraform.zip
    unzip -q /tmp/terraform.zip -d /tmp
    sudo mv /tmp/terraform /usr/local/bin/
    rm /tmp/terraform.zip
    log_success "Terraform ${tf_version} installed"
  fi

  # kubectl
  if ! command -v kubectl &>/dev/null; then
    log_info "Installing kubectl..."
    local k8s_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    curl -fsSL "https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/darwin/amd64/kubectl" -o /tmp/kubectl
    chmod +x /tmp/kubectl
    sudo mv /tmp/kubectl /usr/local/bin/
    log_success "kubectl ${k8s_version} installed"
  fi

  # Helm
  if ! command -v helm &>/dev/null; then
    log_info "Installing Helm..."
    curl -fsSL https://get.helm.sh/helm-v3.12.0-darwin-amd64.tar.gz -o /tmp/helm.tar.gz
    tar -xzf /tmp/helm.tar.gz -C /tmp
    sudo mv /tmp/darwin-amd64/helm /usr/local/bin/
    rm -rf /tmp/helm.tar.gz /tmp/darwin-amd64
    log_success "Helm 3.12.0 installed"
  fi

  # AWS CLI v2
  if ! command -v aws &>/dev/null; then
    log_info "Installing AWS CLI v2..."
    curl -fsSL "https://awscli.amazonaws.com/AWSCLIV2.pkg" -o /tmp/AWSCLIV2.pkg
    sudo installer -pkg /tmp/AWSCLIV2.pkg -target /
    rm /tmp/AWSCLIV2.pkg
    log_success "AWS CLI v2 installed"
  fi

  # GitHub CLI
  if ! command -v gh &>/dev/null; then
    log_info "Installing GitHub CLI..."
    brew install gh
  fi

  # Additional tools that are fine from Homebrew
  local brew_tools=(
    "tmux"
    "neofetch"
  )

  for tool in "${brew_tools[@]}"; do
    if ! brew list "$tool" &>/dev/null; then
      log_info "Installing $tool..."
      brew install "$tool"
    fi
  done
}

# Install GUI applications
install_gui_apps() {
  log_info "Installing GUI applications..."

  local gui_apps=(
    "visual-studio-code"
    "iterm2"
    "alfred"
    "rectangle"
    "spectacle"
    "the-unarchiver"
    "google-chrome"
    "firefox"
    "discord"
    "slack"
    "spotify"
  )

  for app in "${gui_apps[@]}"; do
    if ! brew list --cask "$app" &>/dev/null; then
      log_info "Installing $app..."
      brew install --cask "$app"
    fi
  done
}

# Configure macOS settings
configure_macos() {
  log_info "Configuring macOS settings..."

  # Show hidden files
  defaults write com.apple.finder AppleShowAllFiles YES

  # Show path bar in Finder
  defaults write com.apple.finder ShowPathbar -bool true

  # Show status bar in Finder
  defaults write com.apple.finder ShowStatusBar -bool true

  # Disable the "Are you sure you want to open this application?" dialog
  defaults write com.apple.LaunchServices LSQuarantine -bool false

  # Disable automatic capitalization
  defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool false

  # Disable smart dashes
  defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false

  # Disable automatic period substitution
  defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool false

  # Disable auto-correct
  defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false

  # Enable tap to click
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true

  # Enable three finger drag
  defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad TrackpadThreeFingerDrag -bool true

  # Restart affected applications
  killall Finder
  killall Dock
}

# Install language servers
install_language_servers() {
  log_info "Installing language servers..."

  # Node.js language servers
  if command -v npm &>/dev/null; then
    log_info "Installing Node.js language servers..."
    npm install -g typescript typescript-language-server lua-language-server

    # Install additional tools
    npm install -g @volar/vue-language-server
    npm install -g prettier eslint
  fi

  # Python language server
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python language server..."
    pip3 install python-lsp-server[all]
    pip3 install black flake8 mypy
  fi

  # Go tools
  if command -v go &>/dev/null; then
    log_info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
  fi

  # Rust tools
  if command -v rustup &>/dev/null; then
    log_info "Installing Rust tools..."
    rustup component add rust-analyzer
    rustup component add rust-src
  fi
}

# Main macOS setup
main() {
  install_homebrew
  install_essential_tools
  install_programming_tools
  install_gui_apps
  configure_macos
  install_language_servers

  log_success "macOS setup completed successfully!"
}

main "$@"

#!/bin/bash

echo "🛠️ Setting up your development environment..."
DOTFILES=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)

remove_existing() {
  local paths=(
    "$HOME/.config/nvim"
    "$HOME/.tmux.conf"
    "$HOME/.tmux"
    "$HOME/.zshrc"
    "$HOME/.gitconfig"
    "$HOME/.p10k.zsh"
    "$HOME/.oh-my-zsh"
    "$HOME/.nvm"
    "$HOME/.deno"
    "$HOME/.tmux/plugins/tpm"
  )
  for path in "${paths[@]}"; do
    if [ -e "$path" ]; then
      rm -rf "$path"
    fi
  done
}

create_symlinks() {
  ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
  ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
  ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
  ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
  echo "🔗 Symlink complete"
}

command_exists() {
  command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
  local managers=("apt" "yum" "dnf" "pacman" "apk" "brew")
  for manager in "${managers[@]}"; do
    if command_exists "$manager"; then
      echo "$manager"
      return
    fi
  done
  echo "unknown"
}

install_package() {
  local package=$1
  case "$PACKAGE_MANAGER" in
  apt) sudo apt update && sudo apt install -y "$package" ;;
  yum) sudo yum install -y "$package" ;;
  dnf) sudo dnf install -y "$package" ;;
  pacman) sudo pacman -Sy --noconfirm "$package" ;;
  apk) sudo apk add "$package" ;;
  brew) brew install "$package" ;;
  *) echo "❌ Unsupported package manager. Please install $package manually." && exit 1 ;;
  esac
}

install_nvm() {
  if [ ! -d "$HOME/.nvm" ]; then
    echo "📦 Installing NVM (Node Version Manager)..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  else
    echo "✅ NVM already installed."
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}

install_node() {
  if ! command_exists node; then
    echo "⬇️  Installing latest Node.js..."
    nvm install node
  else
    echo "✅ Node.js already installed: $(node -v)"
  fi
}

install_deno() {
  if ! command_exists deno; then
    echo "📥 Installing Deno..."
    curl -fsSL https://deno.land/install.sh | sh
  else
    echo "✅ Deno already installed: $(deno --version)"
  fi
}

install_lazygit() {
  if ! command_exists lazygit; then
    echo "📥 Installing Lazygit..."
    case "$PACKAGE_MANAGER" in
    apt)
      LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": *"v\K[^"]*')
      curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
      tar xf lazygit.tar.gz lazygit
      sudo install lazygit -D -t /usr/local/bin/
      ;;
    *) install_package lazygit ;;
    esac
  else
    echo "✅ Lazygit already installed."
  fi
}

install_tmux() {
  if ! command_exists tmux; then
    echo "📦 Installing Tmux..."
    install_package tmux
  else
    echo "✅ Tmux already installed."
  fi
}

install_tpm() {
  if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
    echo "Installing Tmux Plugin Manager (tpm)..."
    git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
  else
    echo "Tmux Plugin Manager (tpm) is already installed."
  fi
  "$HOME/.tmux/plugins/tpm/bin/install_plugins"
}

install_zsh() {
  if ! command_exists zsh; then
    echo "📦 Installing Zsh..."
    install_package zsh
  else
    echo "✅ Zsh already installed."
  fi
}

install_oh_my_zsh() {
  if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "🚀 Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
  else
    echo "✅ Oh My Zsh already installed."
  fi
}

install_powerlevel10k() {
  if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
    echo "🎨 Installing Powerlevel10k theme..."
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
      ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
  fi
}

install_zsh_plugins() {
  local plugins=("zsh-autosuggestions" "zsh-syntax-highlighting")
  for plugin in "${plugins[@]}"; do
    if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin" ]; then
      echo "🔍 Installing $plugin..."
      git clone https://github.com/zsh-users/$plugin "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/$plugin"
    fi
  done
}

# Install pnpm through npm
install_pnpm() {
  if ! command_exists pnpm; then
    echo "📦 Installing pnpm..."
    npm install -g pnpm
  else
    echo "✅ pnpm already installed."
  fi
}

# depends on platform install go
install_go() {
  if ! command_exists go; then
    echo "📦 Installing Go..."
    case "$PACKAGE_MANAGER" in
    apt)
      sudo apt update && sudo apt install -y golang-go
      ;;
    yum)
      sudo yum install -y golang
      ;;
    dnf)
      sudo dnf install -y golang
      ;;
    pacman)
      sudo pacman -Sy --noconfirm go
      ;;
    apk)
      sudo apk add go
      ;;
    brew)
      brew install go
      ;;
    *)
      echo "❌ Unsupported package manager. Please install Go manually."
      exit 1
      ;;
    esac
  else
    echo "✅ Go already installed."
  fi
}

install_go_bin() {
  if [ ! -d "$HOME/go/bin" ]; then
    echo "📦 Installing Go binaries..."
    mkdir -p "$HOME/go/bin"
    export GOPATH="$HOME/go"
    export PATH="$GOPATH/bin:$PATH"
  else
    echo "✅ Go binaries already installed."
  fi
}

# Install PHP
install_php() {
  if ! command_exists php; then
    echo "📦 Installing PHP..."
    case "$PACKAGE_MANAGER" in
    apt)
      sudo apt update && sudo apt install -y php
      ;;
    yum)
      sudo yum install -y php
      ;;
    dnf)
      sudo dnf install -y php
      ;;
    pacman)
      sudo pacman -Sy --noconfirm php
      ;;
    apk)
      sudo apk add php
      ;;
    brew)
      brew install php
      ;;
    *)
      echo "❌ Unsupported package manager. Please install PHP manually."
      exit 1
      ;;
    esac
  else
    echo "✅ PHP already installed."
  fi
}

# Install valet
install_valet() {
  if ! command_exists valet; then
    echo "📦 Installing Valet..."
    if command_exists composer; then
      composer global require laravel/valet
      valet install
    else
      echo "❌ Composer not found. Please install Composer first."
      exit 1
    fi
  else
    echo "✅ Valet already installed."
  fi
}

main() {
  remove_existing
  create_symlinks

  PACKAGE_MANAGER=$(detect_package_manager)

  if ! command_exists sudo; then
    echo "⚠️  sudo not found, attempting to install it..."
    install_package sudo
    echo "✅ sudo installed."
  fi

  for pkg in curl unzip neovim; do
    if ! command_exists "$pkg"; then
      echo "📦 Installing $pkg..."
      install_package "$pkg"
      echo "✅ $pkg installed."
    fi
  done

  install_nvm
  install_node
  install_deno
  install_go
  install_go_bin
  install_php
  install_valet
  install_package
  install_pnpm
  install_lazygit
  install_tmux
  install_tpm
  install_zsh
  install_oh_my_zsh
  install_powerlevel10k
  install_zsh_plugins

  echo "🎉 Environment setup complete!"
}

main

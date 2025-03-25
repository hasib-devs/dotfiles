#!/bin/bash

echo "🛠️ Setting up your development environment..."
DOTFILES=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
# Remove existing directories/files
if [ -d "$HOME/.config/nvim" ]; then
    rm -rf "$HOME/.config/nvim"
fi

if [ -f "$HOME/.tmux.conf" ]; then
    rm -rf "$HOME/.tmux.conf"
fi

if [ -d "$HOME/.tmux" ]; then
    rm -rf "$HOME/.tmux"
fi

if [ -d "$HOME/.zshrc" ]; then
    rm -rf "$HOME/.zshrc"
fi

if [ -d "$HOME/.gitconfig" ]; then
    rm -rf "$HOME/.gitconfig"
fi

# Symlink essential dotfiles
ln -sf "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -sf "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
ln -sf "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -sf "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"
echo "🔗 Symlink complete"

# Helper function: Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Detect the package manager
detect_package_manager() {
  if command_exists apt; then
    echo "apt"
  elif command_exists yum; then
    echo "yum"
  elif command_exists dnf; then
    echo "dnf"
  elif command_exists pacman; then
    echo "pacman"
  elif command_exists apk; then
    echo "apk"
  elif command_exists brew; then
    echo "brew"  # macOS uses Homebrew
  else
    echo "unknown"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)

# Ensure root privileges if sudo is not available
if ! command_exists sudo; then
  echo "⚠️  sudo not found, attempting to install it..."

  case "$PACKAGE_MANAGER" in
    apt) su -c "apt update && apt install -y sudo" ;;
    yum) su -c "yum install -y sudo" ;;
    dnf) su -c "dnf install -y sudo" ;;
    pacman) su -c "pacman -Sy --noconfirm sudo" ;;
    apk) su -c "apk add sudo" ;;
    brew) echo "Homebrew requires sudo for certain actions, but it should be pre-installed on macOS." ;;
    *)
      echo "❌ Unsupported package manager. Please install sudo manually."
      exit 1
      ;;
  esac

  echo "✅ sudo installed."
fi

# Ensure curl is installed
if ! command_exists curl; then
  echo "📦 Installing curl..."

  case "$PACKAGE_MANAGER" in
    apt) sudo apt update && sudo apt install -y curl ;;
    yum) sudo yum install -y curl ;;
    dnf) sudo dnf install -y curl ;;
    pacman) sudo pacman -Sy --noconfirm curl ;;
    apk) sudo apk add curl ;;
    brew) brew install curl ;;
    *)
      echo "❌ No supported package manager found. Install curl manually."
      exit 1
      ;;
  esac

  echo "✅ curl installed."
fi


# Ensure Neovim is installed
if ! command_exists nvim; then
  echo "📦 Installing Neovim..."

  case "$PACKAGE_MANAGER" in
    apt) sudo apt update && sudo apt install -y neovim ;;
    yum) sudo yum install -y neovim ;;
    dnf) sudo dnf install -y neovim ;;
    pacman) sudo pacman -Sy --noconfirm neovim ;;
    apk) sudo apk add neovim ;;
    brew) brew install neovim ;;
    *)
      echo "❌ Unsupported package manager. Please install Neovim manually."
      exit 1
      ;;
  esac

  echo "✅ Neovim installed successfully."
fi


# Step Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "✅ NVM already installed."
fi

# Load NVM environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install the latest Node.js version if not present
if ! command_exists node; then
  echo "⬇️  Installing latest Node.js..."
  nvm install node
else
  echo "✅ Node.js already installed: $(node -v)"
fi

# Step Install Deno if not present
if ! command_exists deno; then
  echo "📥 Installing Deno..."
  curl -fsSL https://deno.land/install.sh | sh
else
  echo "✅ Deno already installed: $(deno --version)"
fi

# Install Lazygit
if ! command_exists lazygit; then
  echo "📥 Installing Lazygit..."
  case "$PACKAGE_MANAGER" in
    apt)
      sudo add-apt-repository ppa:lazygit-team/release -y
      sudo apt update && sudo apt install -y lazygit
      ;;
    yum) sudo yum install -y lazygit ;;
    dnf) sudo dnf install -y lazygit ;;
    pacman) sudo pacman -Sy --noconfirm lazygit ;;
    apk) sudo apk add lazygit ;;
    brew) brew install lazygit ;;
    *)
      echo "❌ No supported package manager found. Install Lazygit manually."
      ;;
  esac
else
  echo "✅ Lazygit already installed."
fi
ZSHRC="$HOME/.zshrc"
# Ensure Zsh is installed
if ! command_exists zsh; then
  echo "📦 Installing Zsh..."

  case "$PACKAGE_MANAGER" in
    apt) sudo apt update && sudo apt install -y zsh ;;
    yum) sudo yum install -y zsh ;;
    dnf) sudo dnf install -y zsh ;;
    pacman) sudo pacman -Sy --noconfirm zsh ;;
    apk) sudo apk add zsh ;;
    brew) brew install zsh ;;
    *)
      echo "❌ Unsupported package manager. Install zsh manually."
      exit 1
      ;;
  esac

  echo "✅ Zsh installed successfully."
fi

# Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🚀 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

# Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Install Zsh Plugins
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "🔍 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "🖍️  Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Step Switch to Zsh if not already in Zsh
# if [ -z "$ZSH_VERSION" ]; then
#   echo "🔄 Switching to Zsh..."
#   exec zsh "$0"  # Restart script using Zsh
#   exit
# fi

# Step 3: Set Zsh as the default shell
# if [ "$SHELL" != "$(which zsh)" ]; then
#   echo "🔧 Setting Zsh as the default shell..."
#   chsh -s "$(which zsh)"
# fi

# Step 10: Source the new Zsh configuration
echo "🔄 Reloading Zsh configuration..."
source "$ZSHRC"

echo "🎉 Environment setup complete!"


#!/bin/bash

# Source the utils.sh file to use its functions
source "./utils.sh"

echo "🛠️ Setting up your development environment..."

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

# Ensure unzip is installed
if ! command_exists unzip; then
  echo "📦 Installing unzip..."

  case "$PACKAGE_MANAGER" in
  apt) sudo apt update && sudo apt install -y unzip ;;
  yum) sudo yum install -y unzip ;;
  dnf) sudo dnf install -y unzip ;;
  pacman) sudo pacman -Sy --noconfirm unzip ;;
  apk) sudo apk add unzip ;;
  brew) brew install unzip ;;
  *)
    echo "❌ No supported package manager found. Install unzip manually."
    exit 1
    ;;
  esac

  echo "✅ unzip installed."
fi

# Ensure fzf is installed
if ! command_exists fzf; then
  echo "📦 Installing fzf..."

  case "$PACKAGE_MANAGER" in
  apt) sudo apt update && sudo apt install -y fzf ;;
  yum) sudo yum install -y fzf ;;
  dnf) sudo dnf install -y fzf ;;
  pacman) sudo pacman -Sy --noconfirm fzf ;;
  apk) sudo apk add fzf ;;
  brew) brew install fzf ;;
  *)
    echo "❌ No supported package manager found. Install fzf manually."
    exit 1
    ;;
  esac

  echo "✅ fzf installed."
fi

# Remove existing directories/files
if [ -f "$HOME/.tmux.conf" ]; then
  rm "$HOME/.tmux.conf"
fi

if [ -f "$HOME/.zshrc" ]; then
  rm "$HOME/.zshrc"
fi

if [ -f "$HOME/.gitconfig" ]; then
  rm "$HOME/.gitconfig"
fi

if [ -f "$HOME/.p10k.zsh" ]; then
  rm "$HOME/.p10k.zsh"
fi

if [ -d "$HOME/.config/nvim" ]; then
  rm -rf "$HOME/.config/nvim"
fi

if [ -d "$HOME/.config/kickstart" ]; then
  rm -rf "$HOME/.config/kickstart"
fi

if [ -d "$HOME/.config/AstroNvim" ]; then
  rm -rf "$HOME/.config/AstroNvim"
fi

if [ -d "$HOME/.tmux" ]; then
  rm -rf "$HOME/.tmux"
fi

# Remove existing symlinks
if [ -L "$HOME/.tmux.conf" ]; then
  unlink "$HOME/.tmux.conf"
fi
if [ -L "$HOME/.zshrc" ]; then
  unlink "$HOME/.zshrc"
fi
if [ -L "$HOME/.gitconfig" ]; then
  unlink "$HOME/.gitconfig"
fi
if [ -L "$HOME/.p10k.zsh" ]; then
  unlink "$HOME/.p10k.zsh"
fi
if [ -L "$HOME/.config/nvim" ]; then
  unlink "$HOME/.config/nvim"
fi
if [ -L "$HOME/.config/kickstart" ]; then
  unlink "$HOME/.config/kickstart"
fi
if [ -L "$HOME/.config/AstroNvim" ]; then
  unlink "$HOME/.config/AstroNvim"
fi

# Create directories if they don't exist

# Symlink essential dotfiles
ln -s "$DOTFILES/.zshrc" "$HOME/.zshrc"
ln -s "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
ln -s "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
ln -s "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"

ln -s "$DOTFILES/nvim" "$HOME/.config/nvim"
ln -s "$DOTFILES/kickstart" "$HOME/.config/kickstart"
ln -s "$DOTFILES/AstroNvim" "$HOME/.config/AstroNvim"

echo "🔗 Symlink complete"

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

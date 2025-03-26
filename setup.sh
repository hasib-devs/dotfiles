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

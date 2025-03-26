#!/bin/bash

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
    echo "brew" # macOS uses Homebrew
  else
    echo "unknown"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)
DOTFILES=$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)
ZSHRC="$HOME/.zshrc"
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

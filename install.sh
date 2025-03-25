#!/bin/bash

echo "🛠️ Setting up your development environment..."

# Symlink essential dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

# Reload shell
source ~/.zshrc

echo "✅ Dotfiles setup completed!"


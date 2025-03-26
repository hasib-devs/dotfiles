#!/bin/bash

source "./utils.sh"

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

# Create directories if they don't exist
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/nvim"
mkdir -p "$HOME/.config/kickstart"
mkdir -p "$HOME/.config/AstroNvim"
mkdir -p "$HOME/.tmux"

cp "$DOTFILES/.zshrc" "$HOME/.zshrc"
cp "$DOTFILES/.p10k.zsh" "$HOME/.p10k.zsh"
cp "$DOTFILES/.gitconfig" "$HOME/.gitconfig"
cp "$DOTFILES/.tmux.conf" "$HOME/.tmux.conf"

cp -r "$DOTFILES/nvim" "$HOME/.config/nvim"
cp -r "$DOTFILES/kickstart" "$HOME/.config/kickstart"
cp -r "$DOTFILES/AstroNvim" "$HOME/.config/AstroNvim"

echo "🔗 Symlink complete"

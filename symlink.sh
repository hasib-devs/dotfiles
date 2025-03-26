#!/bin/bash

source "./utils.sh"

# Remove existing symlinks
if ls -l "$HOME/.tmux.conf"; then
    unlink "$HOME/.tmux.conf"
fi
if ls -l "$HOME/.zshrc"; then
    unlink "$HOME/.zshrc"
fi
if ls -l "$HOME/.gitconfig"; then
    unlink "$HOME/.gitconfig"
fi
if ls -l "$HOME/.p10k.zsh"; then
    unlink "$HOME/.p10k.zsh"
fi
if ls -l "$HOME/.config/nvim"; then
    unlink "$HOME/.config/nvim"
fi
if ls -l "$HOME/.config/kickstart"; then
    unlink "$HOME/.config/kickstart"
fi
if ls -l "$HOME/.config/AstroNvim"; then
    unlink "$HOME/.config/AstroNvim"
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

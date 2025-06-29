#!/bin/bash

# =============================================================================
# Neovim Setup Script
# =============================================================================
# This script sets up Neovim with the dotfiles configuration.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Setting up Neovim..."

# Check if Neovim is installed
check_neovim() {
  if ! command -v nvim &>/dev/null; then
    log_error "Neovim is not installed. Please install it first."
    log_info "On macOS: brew install neovim"
    log_info "On Ubuntu/Debian: sudo apt install neovim"
    log_info "On Fedora: sudo dnf install neovim"
    exit 1
  fi

  local nvim_version=$(nvim --version | head -n1 | cut -d' ' -f2)
  log_info "Neovim version: $nvim_version"

  # Check if version is at least 0.8.0
  if [[ "$(printf '%s\n' "0.8.0" "$nvim_version" | sort -V | head -n1)" != "0.8.0" ]]; then
    log_warning "Neovim version $nvim_version is older than 0.8.0"
    log_warning "Some features may not work properly"
  fi
}

# Create Neovim configuration directory
create_nvim_config() {
  log_info "Creating Neovim configuration directory..."

  local nvim_config_dir="$HOME/.config/nvim"

  # Backup existing configuration
  if [[ -d "$nvim_config_dir" ]]; then
    local backup_dir="$HOME/.config/nvim_backup_$(date +%Y%m%d_%H%M%S)"
    log_info "Backing up existing Neovim configuration to $backup_dir"
    mv "$nvim_config_dir" "$backup_dir"
  fi

  # Create configuration directory
  mkdir -p "$nvim_config_dir"

  log_success "Neovim configuration directory created"
}

# Copy dotfiles configuration
copy_nvim_config() {
  log_info "Copying Neovim configuration..."

  local dotfiles_nvim="$SCRIPT_DIR/../nvim"
  local nvim_config_dir="$HOME/.config/nvim"

  if [[ ! -d "$dotfiles_nvim" ]]; then
    log_error "Neovim configuration not found in dotfiles"
    exit 1
  fi

  # Copy all files from nvim directory
  cp -r "$dotfiles_nvim"/* "$nvim_config_dir/"

  log_success "Neovim configuration copied successfully"
}

# Install language servers and tools
install_language_servers() {
  log_info "Installing language servers and tools for Neovim..."

  # Source NVM if available
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi

  # Source pnpm if available
  if [[ -d "$HOME/.local/share/pnpm" ]]; then
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"
  fi

  # Node.js language servers and tools
  if command -v pnpm &>/dev/null; then
    log_info "Installing Node.js tools via pnpm..."
    pnpm add -g \
      typescript \
      typescript-language-server \
      lua-language-server \
      @volar/vue-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      bash-language-server \
      dockerfile-language-server-nodejs \
      vscode-json-languageserver \
      yaml-language-server \
      prettier \
      eslint \
      tree-sitter-cli
  elif command -v npm &>/dev/null; then
    log_info "Installing Node.js tools via npm..."
    npm install -g \
      typescript \
      typescript-language-server \
      lua-language-server \
      @volar/vue-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      bash-language-server \
      dockerfile-language-server-nodejs \
      vscode-json-languageserver \
      yaml-language-server \
      prettier \
      eslint \
      tree-sitter-cli
  else
    log_warning "Neither pnpm nor npm found. Node.js tools will not be installed."
    log_info "Please ensure NVM is properly configured and Node.js is installed."
  fi

  # Python tools (optional - user can install if needed)
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python tools..."
    pip3 install python-lsp-server[all]
    # Note: black, flake8, isort are commented out in config but can be installed here
    # pip3 install black flake8 mypy isort ruff
  else
    log_warning "pip3 not found. Python tools will not be installed."
  fi

  # Go tools
  if command -v go &>/dev/null; then
    log_info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install golang.org/x/tools/cmd/goimports@latest
    go install mvdan.cc/gofumpt@latest
  else
    log_warning "Go not found. Go tools will not be installed."
  fi

  # Rust tools
  if command -v rustup &>/dev/null; then
    log_info "Installing Rust tools..."
    rustup component add rust-analyzer
    rustup component add rust-src
  else
    log_warning "rustup not found. Rust tools will not be installed."
  fi

  # Additional formatters
  if command -v cargo &>/dev/null; then
    log_info "Installing Rust formatters..."
    cargo install stylua
  fi

  if command -v shfmt &>/dev/null; then
    log_info "shfmt found"
  else
    log_info "shfmt not found. Install with: go install mvdan.cc/sh/v3/cmd/shfmt@latest"
  fi
}

# Create Neovim data directory
create_nvim_data() {
  log_info "Creating Neovim data directory..."

  local nvim_data_dir="$HOME/.local/share/nvim"
  mkdir -p "$nvim_data_dir"

  log_success "Neovim data directory created"
}

# Test Neovim configuration
test_nvim_config() {
  log_info "Testing Neovim configuration..."

  # Test if Neovim starts without errors
  if nvim --headless -c "lua print('Neovim configuration test successful')" -c "quit" 2>/dev/null; then
    log_success "Neovim configuration test passed"
  else
    log_warning "Neovim configuration test failed. There may be some issues."
  fi
}

# Create Neovim aliases
create_nvim_aliases() {
  log_info "Creating Neovim aliases..."

  # Add aliases to shell configuration
  local aliases=(
    "alias vim='nvim'"
    "alias vi='nvim'"
    "alias v='nvim'"
    "alias nv='nvim'"
  )

  for alias in "${aliases[@]}"; do
    if ! grep -q "$alias" ~/.bashrc 2>/dev/null; then
      echo "$alias" >>~/.bashrc
    fi

    if ! grep -q "$alias" ~/.zshrc 2>/dev/null; then
      echo "$alias" >>~/.zshrc
    fi
  done

  log_success "Neovim aliases created"
}

# Main Neovim setup
main() {
  check_neovim
  create_nvim_config
  copy_nvim_config
  install_language_servers
  create_nvim_data
  create_nvim_aliases
  test_nvim_config

  log_success "Neovim setup completed successfully!"
  log_info "You can now start Neovim with: nvim"
  log_info "First run will install plugins automatically via lazy.nvim"
  log_info ""
  log_info "Key features available:"
  log_info "  - File explorer: <leader>e"
  log_info "  - Fuzzy finder: <leader>ff"
  log_info "  - Save file: <leader>w"
  log_info "  - Quit: <leader>q"
  log_info "  - LSP features: gd, K, <leader>ca, etc."
}

main "$@"

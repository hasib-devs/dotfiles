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

# Install language servers
install_language_servers() {
  log_info "Installing language servers for Neovim..."

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

  # Node.js language servers
  if command -v pnpm &>/dev/null; then
    log_info "Installing Node.js language servers via pnpm..."
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
      yaml-language-server
  elif command -v npm &>/dev/null; then
    log_info "Installing Node.js language servers via npm..."
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
      yaml-language-server
  else
    log_warning "Neither pnpm nor npm found. Node.js language servers will not be installed."
    log_info "Please ensure NVM is properly configured and Node.js is installed."
  fi

  # Python language server
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python language server..."
    pip3 install python-lsp-server[all]
    pip3 install black flake8 mypy isort ruff
  else
    log_warning "pip3 not found. Python language server will not be installed."
  fi

  # Go tools
  if command -v go &>/dev/null; then
    log_info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
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
}

# Install additional tools
install_additional_tools() {
  log_info "Installing additional tools for Neovim..."

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

  # Install tree-sitter CLI (for syntax highlighting)
  if command -v pnpm &>/dev/null; then
    log_info "Installing tree-sitter CLI via pnpm..."
    pnpm add -g tree-sitter-cli
  elif command -v npm &>/dev/null; then
    log_info "Installing tree-sitter CLI via npm..."
    npm install -g tree-sitter-cli
  fi

  # Install additional formatters
  if command -v pnpm &>/dev/null; then
    log_info "Installing additional formatters via pnpm..."
    pnpm add -g prettier eslint
  elif command -v npm &>/dev/null; then
    log_info "Installing additional formatters via npm..."
    npm install -g prettier eslint
  fi

  # Install additional Python tools
  if command -v pip3 &>/dev/null; then
    log_info "Installing additional Python tools..."
    pip3 install \
      pylsp-mypy \
      pylsp-rope \
      python-lsp-black \
      python-lsp-isort \
      python-lsp-ruff
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

# Install additional plugins (if using plugin manager)
install_plugins() {
  log_info "Installing Neovim plugins..."

  # Create plugins directory if it doesn't exist
  local plugins_dir="$HOME/.local/share/nvim/site/pack/packer/start"
  mkdir -p "$plugins_dir"

  # Install lazy.nvim (plugin manager)
  if [[ ! -d "$plugins_dir/lazy.nvim" ]]; then
    log_info "Installing lazy.nvim plugin manager..."
    git clone --filter=blob:none https://github.com/folke/lazy.nvim.git --branch=stable "$plugins_dir/lazy.nvim"
  fi

  log_success "Plugin manager installed"
}

# Create Neovim configuration
create_plugins_config() {
  log_info "Creating plugins configuration..."

  local nvim_config_dir="$HOME/.config/nvim"
  local plugins_file="$nvim_config_dir/lua/plugins.lua"

  # Create plugins.lua if it doesn't exist
  if [[ ! -f "$plugins_file" ]]; then
    cat >"$plugins_file" <<'EOF'
-- =============================================================================
-- Plugins Configuration
-- =============================================================================

return {
    -- Plugin manager
    {
        "folke/lazy.nvim",
        version = "*",
    },
    
    -- Colorscheme
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd([[colorscheme tokyonight]])
        end,
    },
    
    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "hrsh7th/nvim-cmp",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
    },
    
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
    },
    
    -- Telescope (fuzzy finder)
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
    },
    
    -- Git integration
    {
        "lewis6991/gitsigns.nvim",
    },
    
    -- Status line
    {
        "nvim-lualine/lualine.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    
    -- File explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
        },
    },
    
    -- Comments
    {
        "numToStr/Comment.nvim",
    },
    
    -- Surround
    {
        "kylechui/nvim-surround",
    },
    
    -- Auto pairs
    {
        "windwp/nvim-autopairs",
    },
    
    -- Indent guides
    {
        "lukas-reineke/indent-blankline.nvim",
    },
}
EOF
    log_success "Plugins configuration created"
  fi
}

# Main Neovim setup
main() {
  check_neovim
  create_nvim_config
  copy_nvim_config
  install_language_servers
  install_additional_tools
  create_nvim_data
  create_plugins_config
  install_plugins
  create_nvim_aliases
  test_nvim_config

  log_success "Neovim setup completed successfully!"
  log_info "You can now start Neovim with: nvim"
  log_info "First run will install plugins automatically"
}

main "$@"

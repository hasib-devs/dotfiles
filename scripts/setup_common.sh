#!/bin/bash

# =============================================================================
# Common Setup Script
# =============================================================================
# This script handles common setup tasks for both Linux and macOS.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Running common setup..."

# Create necessary directories
create_directories() {
  log_info "Creating necessary directories..."

  local directories=(
    "$HOME/.config"
    "$HOME/.local/bin"
    "$HOME/.local/share"
    "$HOME/.cache"
    "$HOME/.ssh"
    "$HOME/Projects"
    "$HOME/Documents"
    "$HOME/Downloads"
    "$HOME/Pictures"
    "$HOME/Music"
    "$HOME/Videos"
  )

  for dir in "${directories[@]}"; do
    if [[ ! -d "$dir" ]]; then
      log_info "Creating $dir"
      mkdir -p "$dir"
    fi
  done

  # Set proper permissions for SSH
  chmod 700 ~/.ssh
}

# Install additional tools
install_additional_tools() {
  log_info "Installing additional tools..."

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

  # Install tldr (if not already installed)
  if ! command -v tldr &>/dev/null; then
    if command -v pnpm &>/dev/null; then
      log_info "Installing tldr..."
      pnpm add -g tldr
    elif command -v npm &>/dev/null; then
      log_info "Installing tldr..."
      npm install -g tldr
    fi
  fi

  # Install additional Node.js tools
  if command -v pnpm &>/dev/null; then
    log_info "Installing additional Node.js tools via pnpm..."
    pnpm add -g \
      @volar/vue-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      typescript-eslint \
      @typescript-eslint/parser \
      @typescript-eslint/eslint-plugin
  elif command -v npm &>/dev/null; then
    log_info "Installing additional Node.js tools via npm..."
    npm install -g \
      @volar/vue-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      typescript-eslint \
      @typescript-eslint/parser \
      @typescript-eslint/eslint-plugin
  else
    log_warning "Neither pnpm nor npm found. Node.js tools will not be installed."
    log_info "Please ensure NVM is properly configured and Node.js is installed."
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

# Configure environment variables
configure_environment() {
  log_info "Configuring environment variables..."

  # Add local bin to PATH
  if ! grep -q "$HOME/.local/bin" ~/.bashrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.bashrc
  fi

  if ! grep -q "$HOME/.local/bin" ~/.zshrc 2>/dev/null; then
    echo 'export PATH="$HOME/.local/bin:$PATH"' >>~/.zshrc
  fi

  # Add Go bin to PATH
  if command -v go &>/dev/null; then
    if ! grep -q "$(go env GOPATH)/bin" ~/.bashrc 2>/dev/null; then
      echo 'export PATH="$(go env GOPATH)/bin:$PATH"' >>~/.bashrc
    fi

    if ! grep -q "$(go env GOPATH)/bin" ~/.zshrc 2>/dev/null; then
      echo 'export PATH="$(go env GOPATH)/bin:$PATH"' >>~/.zshrc
    fi
  fi

  # Add Rust cargo bin to PATH
  if [[ -d "$HOME/.cargo/bin" ]]; then
    if ! grep -q "$HOME/.cargo/bin" ~/.bashrc 2>/dev/null; then
      echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.bashrc
    fi

    if ! grep -q "$HOME/.cargo/bin" ~/.zshrc 2>/dev/null; then
      echo 'export PATH="$HOME/.cargo/bin:$PATH"' >>~/.zshrc
    fi
  fi

  # Configure NVM
  if [[ -d "$HOME/.nvm" ]]; then
    # Add NVM configuration to bashrc
    if ! grep -q "NVM_DIR" ~/.bashrc 2>/dev/null; then
      cat >>~/.bashrc <<'EOF'

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi

    # Add NVM configuration to zshrc
    if ! grep -q "NVM_DIR" ~/.zshrc 2>/dev/null; then
      cat >>~/.zshrc <<'EOF'

# NVM Configuration
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
EOF
    fi

    log_success "NVM configuration added to shell profiles"
  fi

  # Configure pnpm
  if [[ -d "$HOME/.local/share/pnpm" ]]; then
    # Add pnpm configuration to bashrc
    if ! grep -q "PNPM_HOME" ~/.bashrc 2>/dev/null; then
      cat >>~/.bashrc <<'EOF'

# pnpm Configuration
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
EOF
    fi

    # Add pnpm configuration to zshrc
    if ! grep -q "PNPM_HOME" ~/.zshrc 2>/dev/null; then
      cat >>~/.zshrc <<'EOF'

# pnpm Configuration
export PNPM_HOME="$HOME/.local/share/pnpm"
export PATH="$PNPM_HOME:$PATH"
EOF
    fi

    log_success "pnpm configuration added to shell profiles"
  fi

  # Set editor
  if command -v nvim &>/dev/null; then
    if ! grep -q "EDITOR=nvim" ~/.bashrc 2>/dev/null; then
      echo 'export EDITOR=nvim' >>~/.bashrc
    fi

    if ! grep -q "EDITOR=nvim" ~/.zshrc 2>/dev/null; then
      echo 'export EDITOR=nvim' >>~/.zshrc
    fi
  fi
}

# Configure Git defaults
configure_git_defaults() {
  log_info "Configuring Git defaults..."

  # Set default branch name
  git config --global init.defaultBranch main

  # Set default editor
  if command -v nvim &>/dev/null; then
    git config --global core.editor nvim
  fi

  # Set default pager
  if command -v bat &>/dev/null; then
    git config --global core.pager bat
  fi

  # Enable colorful output
  git config --global color.ui auto

  # Set default merge tool
  git config --global merge.tool vimdiff

  # Configure line endings
  git config --global core.autocrlf input

  # Set default push behavior
  git config --global push.default current
}

# Install shell plugins
install_shell_plugins() {
  log_info "Installing shell plugins..."

  # Install Oh My Zsh if zsh is available
  if command -v zsh &>/dev/null && [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    log_info "Installing Oh My Zsh..."
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
  fi

  # Install zsh-syntax-highlighting
  if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]]; then
    log_info "Installing zsh-syntax-highlighting..."
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git \
      "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
  fi

  # Install zsh-autosuggestions
  if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]]; then
    log_info "Installing zsh-autosuggestions..."
    git clone https://github.com/zsh-users/zsh-autosuggestions.git \
      "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
  fi

  # Install zsh-completions
  if [[ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-completions" ]]; then
    log_info "Installing zsh-completions..."
    git clone https://github.com/zsh-users/zsh-completions.git \
      "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
  fi
}

# Configure terminal
configure_terminal() {
  log_info "Configuring terminal..."

  # Set terminal colors (if supported)
  if [[ -n "$TERM" ]]; then
    # Enable 256 colors
    export TERM=xterm-256color
  fi

  # Set locale
  export LANG=en_US.UTF-8
  export LC_ALL=en_US.UTF-8
}

# Install additional language servers
install_additional_language_servers() {
  log_info "Installing additional language servers..."

  # Source NVM if available
  if [[ -d "$HOME/.nvm" ]]; then
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  fi

  # Install language servers for various file types
  if command -v pnpm &>/dev/null; then
    log_info "Installing additional language servers via pnpm..."
    pnpm add -g \
      bash-language-server \
      dockerfile-language-server-nodejs \
      vscode-json-languageserver \
      yaml-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      @volar/vue-language-server
  elif command -v npm &>/dev/null; then
    log_info "Installing additional language servers via npm..."
    npm install -g \
      bash-language-server \
      dockerfile-language-server-nodejs \
      vscode-json-languageserver \
      yaml-language-server \
      @tailwindcss/language-server \
      svelte-language-server \
      @volar/vue-language-server
  else
    log_warning "Neither pnpm nor npm found. Node.js language servers will not be installed."
    log_info "Please ensure NVM is properly configured and Node.js is installed."
  fi

  # Install Python language servers
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python language servers..."
    pip3 install \
      python-lsp-server[all] \
      black \
      flake8 \
      mypy \
      isort \
      ruff
  fi
}

# Configure development tools
configure_dev_tools() {
  log_info "Configuring development tools..."

  # Configure fzf
  if command -v fzf &>/dev/null; then
    # Enable fzf key bindings and fuzzy completion
    if [[ -f /usr/share/doc/fzf/examples/key-bindings.bash ]]; then
      source /usr/share/doc/fzf/examples/key-bindings.bash
      source /usr/share/doc/fzf/examples/completion.bash
    elif [[ -f /usr/share/fzf/key-bindings.bash ]]; then
      source /usr/share/fzf/key-bindings.bash
      source /usr/share/fzf/completion.bash
    fi
  fi

  # Configure ripgrep
  if command -v rg &>/dev/null; then
    # Create ripgrep config
    mkdir -p ~/.config/ripgrep
    cat >~/.config/ripgrep/ripgreprc <<EOF
# Ripgrep configuration
--smart-case
--hidden
--glob=!.git/*
--glob=!node_modules/*
--glob=!vendor/*
--glob=!target/*
--glob=!dist/*
--glob=!build/*
EOF
  fi
}

# Main common setup
main() {
  create_directories
  install_additional_tools
  configure_environment
  configure_git_defaults
  install_shell_plugins
  configure_terminal
  install_additional_language_servers
  configure_dev_tools

  log_success "Common setup completed successfully!"
}

main "$@"

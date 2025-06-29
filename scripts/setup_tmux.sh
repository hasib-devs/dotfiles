#!/bin/bash

# =============================================================================
# Tmux Setup Script
# =============================================================================

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Logging functions
log_info() {
  echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
  echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warning() {
  echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
  echo -e "${RED}[ERROR]${NC} $1"
}

# Install TPM (Tmux Plugin Manager)
install_tpm() {
  log_info "Installing Tmux Plugin Manager (TPM)..."

  local tpm_dir="$HOME/.tmux/plugins/tpm"

  if [[ ! -d "$tpm_dir" ]]; then
    git clone https://github.com/tmux-plugins/tpm "$tpm_dir"
    log_success "TPM installed successfully"
  else
    log_info "TPM is already installed"
  fi
}

# Install tmux configuration
install_tmux_config() {
  log_info "Installing tmux configuration..."

  local config_file="$HOME/.tmux.conf"
  local source_config="$(pwd)/.tmux.conf"

  if [[ -f "$source_config" ]]; then
    # Create backup if config already exists
    if [[ -f "$config_file" ]]; then
      log_info "Creating backup of existing tmux configuration..."
      cp "$config_file" "$config_file.backup.$(date +%Y%m%d_%H%M%S)"
    fi

    # Copy the configuration
    cp "$source_config" "$config_file"
    log_success "Tmux configuration installed"

    # Set proper permissions
    chmod 644 "$config_file"
  else
    log_error "Source tmux configuration not found at $source_config"
    return 1
  fi
}

# Install tmux plugins
install_tmux_plugins() {
  log_info "Installing tmux plugins..."

  # Start a tmux session to install plugins
  if command -v tmux &>/dev/null; then
    # Create a temporary session to install plugins
    tmux new-session -d -s temp_session
    tmux send-keys -t temp_session "tmux source-file ~/.tmux.conf" Enter
    tmux send-keys -t temp_session "prefix + I" Enter # Install plugins
    sleep 5                                           # Wait for plugin installation
    tmux kill-session -t temp_session

    log_success "Tmux plugins installed"
  else
    log_warning "tmux not found. Please install tmux first."
    return 1
  fi
}

# Create tmux aliases
create_tmux_aliases() {
  log_info "Creating tmux aliases..."

  local aliases=(
    "alias tm='tmux'"
    "alias tma='tmux attach'"
    "alias tml='tmux list-sessions'"
    "alias tmk='tmux kill-session'"
    "alias tmn='tmux new-session'"
  )

  for alias in "${aliases[@]}"; do
    if ! grep -q "$alias" ~/.bashrc 2>/dev/null; then
      echo "$alias" >>~/.bashrc
    fi

    if ! grep -q "$alias" ~/.zshrc 2>/dev/null; then
      echo "$alias" >>~/.zshrc
    fi
  done

  log_success "Tmux aliases created"
}

# Test tmux configuration
test_tmux_config() {
  log_info "Testing tmux configuration..."

  if command -v tmux &>/dev/null; then
    # Test if tmux starts without errors
    if tmux start-server \; list-sessions \; kill-server 2>/dev/null; then
      log_success "Tmux configuration test passed"
    else
      log_warning "Tmux configuration test failed. There may be some issues."
    fi
  else
    log_warning "tmux not found. Cannot test configuration."
  fi
}

# Main setup function
setup_tmux() {
  log_info "Setting up tmux..."

  # Check if tmux is installed
  if ! command -v tmux &>/dev/null; then
    log_error "tmux is not installed. Please install tmux first."
    log_info "Run the main setup script to install tmux: ./setup.sh"
    return 1
  fi

  # Install components
  install_tmux_config
  install_tpm
  create_tmux_aliases

  # Install plugins (this requires tmux to be running)
  log_info "To install tmux plugins, run: tmux source-file ~/.tmux.conf"
  log_info "Then press: prefix + I (capital I)"

  test_tmux_config

  log_success "Tmux setup completed!"
  log_info "Start tmux with: tmux"
  log_info "Attach to existing session with: tmux attach"
}

# Main execution
if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
  setup_tmux
fi

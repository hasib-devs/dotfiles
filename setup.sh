#!/bin/bash

# =============================================================================
# Dotfiles Setup Script
# =============================================================================
# This script sets up a fresh Linux or macOS system with all necessary tools
# and configurations for development.

set -e # Exit on any error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Script directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DOTFILES_DIR="$SCRIPT_DIR"

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

log_step() {
  echo -e "${PURPLE}[STEP]${NC} $1"
}

# Detect OS
detect_os() {
  if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    if [[ -f /etc/os-release ]]; then
      . /etc/os-release
      OS="$NAME"
      OS_VERSION="$VERSION_ID"
    else
      OS="Linux"
      OS_VERSION="unknown"
    fi
  elif [[ "$OSTYPE" == "darwin"* ]]; then
    OS="macOS"
    OS_VERSION=$(sw_vers -productVersion)
  else
    log_error "Unsupported operating system: $OSTYPE"
    exit 1
  fi

  log_info "Detected OS: $OS $OS_VERSION"
}

# Check if running as root
check_root() {
  if [[ $EUID -eq 0 ]]; then
    log_warning "This script should not be run as root"
    log_warning "Please run as a regular user with sudo privileges"
    exit 1
  fi
}

# Check prerequisites
check_prerequisites() {
  log_step "Checking prerequisites..."

  # Check if we're in the dotfiles directory
  if [[ ! -f "$DOTFILES_DIR/setup.sh" ]]; then
    log_error "Please run this script from the dotfiles directory"
    exit 1
  fi

  # Check if we have sudo access
  if ! sudo -n true 2>/dev/null; then
    log_warning "Please enter your password to continue..."
    sudo true
  fi

  log_success "Prerequisites check passed"
}

# Backup existing configurations
backup_existing() {
  log_step "Backing up existing configurations..."

  local backup_dir="$HOME/.dotfiles_backup_$(date +%Y%m%d_%H%M%S)"
  mkdir -p "$backup_dir"

  # Files to backup
  local files_to_backup=(
    "$HOME/.bashrc"
    "$HOME/.bash_profile"
    "$HOME/.zshrc"
    "$HOME/.gitconfig"
    "$HOME/.ssh/config"
    "$HOME/.config/nvim"
    "$HOME/.tmux.conf"
    "$HOME/.tmux"
  )

  for file in "${files_to_backup[@]}"; do
    if [[ -e "$file" ]]; then
      log_info "Backing up $file"
      cp -r "$file" "$backup_dir/"
    fi
  done

  log_success "Backup created at $backup_dir"
}

# Run setup scripts
run_setup_scripts() {
  log_info "Running setup scripts..."

  # Run OS-specific setup
  if [[ "$OS" == "macOS" ]]; then
    log_info "Running macOS setup..."
    bash scripts/setup_macos.sh
  else
    log_info "Running Linux setup..."
    bash scripts/setup_linux.sh
  fi

  # Run common setup
  log_info "Running common setup..."
  bash scripts/setup_common.sh

  # Run Neovim setup
  log_info "Running Neovim setup..."
  bash scripts/setup_neovim.sh

  # Run tmux setup
  log_info "Running tmux setup..."
  bash scripts/setup_tmux.sh

  # Run performance monitoring setup
  log_info "Running performance monitoring setup..."
  bash scripts/setup_performance.sh

  # Run shell setup
  log_info "Running shell setup..."
  bash scripts/setup_shell.sh

  # Run Git setup
  log_info "Running Git setup..."
  bash scripts/setup_git.sh

  # Run SSH setup
  log_info "Running SSH setup..."
  bash scripts/setup_ssh.sh

  # Run final setup
  log_info "Running final setup..."
  bash scripts/setup_final.sh
}

# Main setup function
main_setup() {
  log_step "Starting system setup..."
  run_setup_scripts
}

# Show help
show_help() {
  echo "Dotfiles Setup Script"
  echo ""
  echo "Usage: $0 [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  -h, --help     Show this help message"
  echo "  -b, --backup   Only backup existing configurations"
  echo "  -s, --skip-backup  Skip backup step"
  echo "  --os-only      Only run OS-specific setup"
  echo "  --neovim-only  Only setup Neovim"
  echo "  --tmux-only    Only setup tmux"
  echo "  --performance-only  Only setup performance monitoring"
  echo "  --shell-only   Only setup shell configuration"
  echo ""
  echo "Examples:"
  echo "  $0              # Full setup"
  echo "  $0 --backup     # Only backup"
  echo "  $0 --neovim-only # Only setup Neovim"
  echo "  $0 --tmux-only  # Only setup tmux"
  echo "  $0 --performance-only # Only setup performance monitoring"
}

# Parse command line arguments
SKIP_BACKUP=false
OS_ONLY=false
NEOVIM_ONLY=false
TMUX_ONLY=false
PERFORMANCE_ONLY=false
SHELL_ONLY=false

while [[ $# -gt 0 ]]; do
  case $1 in
  -h | --help)
    show_help
    exit 0
    ;;
  -b | --backup)
    backup_existing
    exit 0
    ;;
  -s | --skip-backup)
    SKIP_BACKUP=true
    shift
    ;;
  --os-only)
    OS_ONLY=true
    shift
    ;;
  --neovim-only)
    NEOVIM_ONLY=true
    shift
    ;;
  --tmux-only)
    TMUX_ONLY=true
    shift
    ;;
  --performance-only)
    PERFORMANCE_ONLY=true
    shift
    ;;
  --shell-only)
    SHELL_ONLY=true
    shift
    ;;
  *)
    log_error "Unknown option: $1"
    show_help
    exit 1
    ;;
  esac
done

# Main execution
main() {
  echo -e "${CYAN}"
  echo "=========================================="
  echo "    Dotfiles Setup Script"
  echo "=========================================="
  echo -e "${NC}"

  detect_os
  check_root
  check_prerequisites

  if [[ "$SKIP_BACKUP" == "false" ]]; then
    backup_existing
  fi

  if [[ "$OS_ONLY" == "true" ]]; then
    if [[ "$OS" == "macOS" ]]; then
      "$SCRIPT_DIR/scripts/setup_macos.sh"
    else
      "$SCRIPT_DIR/scripts/setup_linux.sh"
    fi
    exit 0
  fi

  if [[ "$NEOVIM_ONLY" == "true" ]]; then
    "$SCRIPT_DIR/scripts/setup_neovim.sh"
    exit 0
  fi

  if [[ "$TMUX_ONLY" == "true" ]]; then
    bash scripts/setup_tmux.sh
    exit 0
  fi

  if [[ "$PERFORMANCE_ONLY" == "true" ]]; then
    bash scripts/setup_performance.sh
    exit 0
  fi

  if [[ "$SHELL_ONLY" == "true" ]]; then
    "$SCRIPT_DIR/scripts/setup_shell.sh"
    exit 0
  fi

  main_setup

  echo -e "${CYAN}"
  echo "=========================================="
  echo "    Setup Complete!"
  echo "=========================================="
  echo -e "${NC}"
  log_success "Your system has been configured successfully!"
  log_info "Please restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
  log_info "You can now start using Neovim with: nvim"
}

# Run main function
main "$@"

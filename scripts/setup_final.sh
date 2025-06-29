#!/bin/bash

# =============================================================================
# Final Setup Script
# =============================================================================
# This script performs final setup tasks and provides completion instructions.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Running final setup..."

# Create completion script
create_completion_script() {
  log_info "Creating completion script..."

  cat >~/.local/bin/dotfiles-complete <<'EOF'
#!/bin/bash
echo "🎉 Dotfiles Setup Complete!"
echo "=========================="
echo ""
echo "Your system has been configured with:"
echo "✅ Essential development tools"
echo "✅ Programming languages (Node.js, Python, Go, Rust)"
echo "✅ Neovim with advanced configuration"
echo "✅ Shell configuration (bash/zsh)"
echo "✅ Git configuration with aliases"
echo "✅ SSH setup with key management"
echo ""
echo "Next steps:"
echo "1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
echo "2. Start using Neovim: nvim"
echo "3. Test your setup: git --version, node --version, etc."
echo ""
echo "Happy coding! 🚀"
EOF

  chmod +x ~/.local/bin/dotfiles-complete
  log_success "Completion script created"
}

# Create update script
create_update_script() {
  log_info "Creating update script..."

  cat >~/.local/bin/dotfiles-update <<'EOF'
#!/bin/bash
set -e

DOTFILES_DIR="$HOME/dotfiles"
if [[ ! -d "$DOTFILES_DIR" ]]; then
    echo "Error: Dotfiles directory not found"
    exit 1
fi

cd "$DOTFILES_DIR"
echo "Updating dotfiles..."
git pull origin main
./setup.sh --skip-backup
echo "Dotfiles updated successfully!"
EOF

  chmod +x ~/.local/bin/dotfiles-update
  log_success "Update script created"
}

# Create system info script
create_system_info_script() {
  log_info "Creating system information script..."

  cat >~/.local/bin/system-info <<'EOF'
#!/bin/bash
echo "System Information"
echo "=================="
echo "OS: $OSTYPE"
echo "Shell: $SHELL"
echo "User: $USER"
echo ""
echo "Installed Tools:"
for tool in git node python3 go rustc nvim docker; do
    if command -v "$tool" &> /dev/null; then
        echo "✅ $tool: $($tool --version 2>/dev/null | head -n1 || echo "installed")"
    else
        echo "❌ $tool: not installed"
    fi
done
EOF

  chmod +x ~/.local/bin/system-info
  log_success "System information script created"
}

# Create final summary
create_final_summary() {
  log_info "Creating final summary..."

  echo ""
  echo "🎉 Setup Complete!"
  echo "=================="
  echo ""
  echo "Your development environment has been configured!"
  echo ""
  echo "Available utilities:"
  echo "  dotfiles-complete     # Show completion instructions"
  echo "  dotfiles-update       # Update dotfiles"
  echo "  system-info           # Show system information"
  echo "  ssh-key-manager       # Manage SSH keys"
  echo ""
  echo "Next steps:"
  echo "1. Restart your terminal or run: source ~/.bashrc (or ~/.zshrc)"
  echo "2. Start using Neovim with: nvim"
  echo "3. Run 'dotfiles-complete' for detailed instructions"
  echo ""
  echo "Happy coding! 🚀"
  echo ""
}

# Main final setup
main() {
  create_completion_script
  create_update_script
  create_system_info_script
  create_final_summary

  log_success "Final setup completed successfully!"
}

main "$@"

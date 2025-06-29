#!/bin/bash

# =============================================================================
# SSH Setup Script
# =============================================================================
# This script sets up SSH configuration and keys.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Setting up SSH..."

# Create SSH directory
create_ssh_directory() {
  log_info "Creating SSH directory..."

  mkdir -p ~/.ssh
  chmod 700 ~/.ssh

  log_success "SSH directory created"
}

# Configure SSH config
configure_ssh_config() {
  log_info "Configuring SSH config..."

  local ssh_config="$HOME/.ssh/config"

  # Create SSH config if it doesn't exist
  if [[ ! -f "$ssh_config" ]]; then
    cat >"$ssh_config" <<'EOF'
# =============================================================================
# SSH Configuration
# =============================================================================

# Global settings
Host *
    # Security settings
    Protocol 2
    HashKnownHosts yes
    GSSAPIAuthentication no
    GSSAPIDelegateCredentials no
    
    # Performance settings
    Compression yes
    TCPKeepAlive yes
    ServerAliveInterval 60
    ServerAliveCountMax 3
    
    # Key settings
    AddKeysToAgent yes
    UseKeychain yes
    IdentitiesOnly yes
    
    # Connection settings
    ControlMaster auto
    ControlPath ~/.ssh/control-%h-%p-%r
    ControlPersist 10m
    
    # Logging
    LogLevel INFO

# GitHub
Host github.com
    HostName github.com
    User git
    IdentityFile ~/.ssh/id_ed25519_github
    IdentitiesOnly yes

# GitLab
Host gitlab.com
    HostName gitlab.com
    User git
    IdentityFile ~/.ssh/id_ed25519_gitlab
    IdentitiesOnly yes

# Bitbucket
Host bitbucket.org
    HostName bitbucket.org
    User git
    IdentityFile ~/.ssh/id_ed25519_bitbucket
    IdentitiesOnly yes

# Development servers
Host dev-*
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_dev
    IdentitiesOnly yes
    ForwardAgent yes

# Production servers
Host prod-*
    User ubuntu
    IdentityFile ~/.ssh/id_ed25519_prod
    IdentitiesOnly yes
    ForwardAgent no

# Local development
Host localhost
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
EOF

    chmod 600 "$ssh_config"
    log_success "SSH config created"
  else
    log_info "SSH config already exists"
  fi
}

# Generate SSH keys
generate_ssh_keys() {
  log_info "Generating SSH keys..."

  # Check if keys already exist
  local keys_exist=false
  for key_type in rsa ed25519; do
    if [[ -f "$HOME/.ssh/id_$key_type" ]]; then
      keys_exist=true
      break
    fi
  done

  if [[ "$keys_exist" == "true" ]]; then
    log_info "SSH keys already exist"
    read -p "Do you want to generate new SSH keys? (y/N): " generate_new
    if [[ ! "$generate_new" =~ ^[Yy]$ ]]; then
      return
    fi
  fi

  # Generate Ed25519 key (recommended)
  log_info "Generating Ed25519 SSH key..."
  read -p "Enter email for SSH key: " ssh_email
  read -p "Enter passphrase for SSH key (optional): " ssh_passphrase

  if [[ -n "$ssh_passphrase" ]]; then
    ssh-keygen -t ed25519 -C "$ssh_email" -f ~/.ssh/id_ed25519 -N "$ssh_passphrase"
  else
    ssh-keygen -t ed25519 -C "$ssh_email" -f ~/.ssh/id_ed25519 -N ""
  fi

  # Generate RSA key as backup
  log_info "Generating RSA SSH key as backup..."
  if [[ -n "$ssh_passphrase" ]]; then
    ssh-keygen -t rsa -b 4096 -C "$ssh_email" -f ~/.ssh/id_rsa -N "$ssh_passphrase"
  else
    ssh-keygen -t rsa -b 4096 -C "$ssh_email" -f ~/.ssh/id_rsa -N ""
  fi

  # Set proper permissions
  chmod 600 ~/.ssh/id_*
  chmod 644 ~/.ssh/id_*.pub

  log_success "SSH keys generated"
}

# Start SSH agent
start_ssh_agent() {
  log_info "Starting SSH agent..."

  # Start SSH agent if not running
  if [[ -z "$SSH_AUTH_SOCK" ]]; then
    eval "$(ssh-agent -s)"

    # Add SSH keys to agent
    for key in ~/.ssh/id_*; do
      if [[ -f "$key" && ! "$key" =~ \.pub$ ]]; then
        ssh-add "$key"
      fi
    done

    log_success "SSH agent started and keys added"
  else
    log_info "SSH agent already running"
  fi
}

# Configure SSH for different services
configure_ssh_services() {
  log_info "Configuring SSH for different services..."

  # Ask user which services they want to configure
  echo "Which services would you like to configure SSH for?"
  echo "1. GitHub"
  echo "2. GitLab"
  echo "3. Bitbucket"
  echo "4. All of the above"
  echo "5. None"

  read -p "Enter your choice (1-5): " service_choice

  case $service_choice in
  1 | 4)
    configure_github_ssh
    ;;
  2 | 4)
    configure_gitlab_ssh
    ;;
  3 | 4)
    configure_bitbucket_ssh
    ;;
  5)
    log_info "Skipping service configuration"
    ;;
  *)
    log_warning "Invalid choice. Skipping service configuration."
    ;;
  esac
}

# Configure GitHub SSH
configure_github_ssh() {
  log_info "Configuring GitHub SSH..."

  # Copy public key
  if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    echo "Your SSH public key for GitHub:"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Please copy this key and add it to your GitHub account:"
    echo "1. Go to https://github.com/settings/keys"
    echo "2. Click 'New SSH key'"
    echo "3. Paste the key above"
    echo "4. Give it a descriptive title"
    echo "5. Click 'Add SSH key'"
    echo ""
    read -p "Press Enter when you've added the key to GitHub..."

    # Test connection
    log_info "Testing GitHub SSH connection..."
    if ssh -T git@github.com 2>&1 | grep -q "successfully authenticated"; then
      log_success "GitHub SSH connection successful"
    else
      log_warning "GitHub SSH connection failed. Please check your key configuration."
    fi
  else
    log_error "SSH public key not found"
  fi
}

# Configure GitLab SSH
configure_gitlab_ssh() {
  log_info "Configuring GitLab SSH..."

  # Copy public key
  if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    echo "Your SSH public key for GitLab:"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Please copy this key and add it to your GitLab account:"
    echo "1. Go to https://gitlab.com/-/profile/keys"
    echo "2. Click 'Add new key'"
    echo "3. Paste the key above"
    echo "4. Give it a descriptive title"
    echo "5. Click 'Add key'"
    echo ""
    read -p "Press Enter when you've added the key to GitLab..."

    # Test connection
    log_info "Testing GitLab SSH connection..."
    if ssh -T git@gitlab.com 2>&1 | grep -q "Welcome to GitLab"; then
      log_success "GitLab SSH connection successful"
    else
      log_warning "GitLab SSH connection failed. Please check your key configuration."
    fi
  else
    log_error "SSH public key not found"
  fi
}

# Configure Bitbucket SSH
configure_bitbucket_ssh() {
  log_info "Configuring Bitbucket SSH..."

  # Copy public key
  if [[ -f ~/.ssh/id_ed25519.pub ]]; then
    echo "Your SSH public key for Bitbucket:"
    cat ~/.ssh/id_ed25519.pub
    echo ""
    echo "Please copy this key and add it to your Bitbucket account:"
    echo "1. Go to https://bitbucket.org/account/settings/ssh-keys/"
    echo "2. Click 'Add key'"
    echo "3. Paste the key above"
    echo "4. Give it a descriptive label"
    echo "5. Click 'Add key'"
    echo ""
    read -p "Press Enter when you've added the key to Bitbucket..."

    # Test connection
    log_info "Testing Bitbucket SSH connection..."
    if ssh -T git@bitbucket.org 2>&1 | grep -q "logged in as"; then
      log_success "Bitbucket SSH connection successful"
    else
      log_warning "Bitbucket SSH connection failed. Please check your key configuration."
    fi
  else
    log_error "SSH public key not found"
  fi
}

# Create SSH utilities
create_ssh_utilities() {
  log_info "Creating SSH utilities..."

  # Create SSH key management script
  cat >~/.local/bin/ssh-key-manager <<'EOF'
#!/bin/bash

# SSH Key Manager
# Usage: ssh-key-manager [add|list|remove|test]

case "$1" in
    "add")
        echo "Adding SSH key to agent..."
        ssh-add ~/.ssh/id_ed25519
        ssh-add ~/.ssh/id_rsa
        ;;
    "list")
        echo "SSH keys in agent:"
        ssh-add -l
        ;;
    "remove")
        echo "Removing all SSH keys from agent..."
        ssh-add -D
        ;;
    "test")
        echo "Testing SSH connections..."
        echo "GitHub:"
        ssh -T git@github.com
        echo "GitLab:"
        ssh -T git@gitlab.com
        echo "Bitbucket:"
        ssh -T git@bitbucket.org
        ;;
    *)
        echo "Usage: ssh-key-manager [add|list|remove|test]"
        ;;
esac
EOF

  chmod +x ~/.local/bin/ssh-key-manager

  log_success "SSH utilities created"
}

# Main SSH setup
main() {
  create_ssh_directory
  configure_ssh_config
  generate_ssh_keys
  start_ssh_agent
  configure_ssh_services
  create_ssh_utilities

  log_success "SSH setup completed successfully!"
  log_info "You can use 'ssh-key-manager' to manage your SSH keys"
  log_info "SSH config is available at ~/.ssh/config"
}

main "$@"

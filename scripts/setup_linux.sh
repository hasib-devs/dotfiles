#!/bin/bash

# =============================================================================
# Linux Setup Script
# =============================================================================
# This script sets up a fresh Linux system with all necessary development tools.

set -e

# Source common functions
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/../setup.sh"

log_step "Setting up Linux..."

# Detect Linux distribution
detect_distro() {
  if [[ -f /etc/os-release ]]; then
    . /etc/os-release
    DISTRO="$ID"
    DISTRO_VERSION="$VERSION_ID"
  else
    log_error "Could not detect Linux distribution"
    exit 1
  fi

  log_info "Detected distribution: $DISTRO $DISTRO_VERSION"
}

# Update package manager
update_package_manager() {
  log_info "Updating package manager..."

  case "$DISTRO" in
  "ubuntu" | "debian" | "linuxmint")
    sudo apt update
    sudo apt upgrade -y
    ;;
  "fedora")
    sudo dnf update -y
    ;;
  "centos" | "rhel" | "rocky" | "almalinux")
    sudo yum update -y
    ;;
  "arch" | "manjaro")
    sudo pacman -Syu --noconfirm
    ;;
  *)
    log_error "Unsupported distribution: $DISTRO"
    exit 1
    ;;
  esac
}

# Install essential packages
install_essential_packages() {
  log_info "Installing essential packages..."

  case "$DISTRO" in
  "ubuntu" | "debian" | "linuxmint")
    sudo apt install -y \
      git curl wget tree htop jq \
      build-essential cmake pkg-config \
      zsh zsh-completions \
      fzf ripgrep fd-find bat exa \
      tmux neofetch
    ;;
  "fedora")
    sudo dnf install -y \
      git curl wget tree htop jq \
      gcc gcc-c++ cmake pkgconfig \
      zsh zsh-completions \
      fzf ripgrep fd-find bat exa \
      tmux neofetch
    ;;
  "centos" | "rhel" | "rocky" | "almalinux")
    sudo yum install -y \
      git curl wget tree htop jq \
      gcc gcc-c++ cmake pkgconfig \
      zsh \
      tmux
    ;;
  "arch" | "manjaro")
    sudo pacman -S --noconfirm \
      git curl wget tree htop jq \
      base-devel cmake pkg-config \
      zsh zsh-completions \
      fzf ripgrep fd bat exa \
      tmux neofetch
    ;;
  esac
}

# Install programming languages
install_programming_languages() {
  log_info "Installing programming languages..."

  # Node.js via NVM
  if ! command -v node &>/dev/null; then
    log_info "Installing Node.js via NVM..."

    # Install NVM
    if [[ ! -d "$HOME/.nvm" ]]; then
      log_info "Installing NVM..."
      curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

      # Source NVM
      export NVM_DIR="$HOME/.nvm"
      [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
      [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
    fi

    # Source NVM in current session
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

    # Install latest LTS Node.js
    nvm install --lts
    nvm use --lts
    nvm alias default node

    log_success "Node.js $(node --version) installed via NVM"
  else
    log_info "Node.js is already installed"
  fi

  # Install pnpm
  if ! command -v pnpm &>/dev/null; then
    log_info "Installing pnpm..."
    curl -fsSL https://get.pnpm.io/install.sh | sh -

    # Source pnpm
    export PNPM_HOME="$HOME/.local/share/pnpm"
    export PATH="$PNPM_HOME:$PATH"

    log_success "pnpm installed"
  else
    log_info "pnpm is already installed"
  fi

  # Python
  if ! command -v python3 &>/dev/null; then
    log_info "Installing Python..."
    case "$DISTRO" in
    "ubuntu" | "debian" | "linuxmint")
      sudo apt install -y python3 python3-pip python3-venv
      ;;
    "fedora")
      sudo dnf install -y python3 python3-pip
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      sudo yum install -y python3 python3-pip
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm python python-pip
      ;;
    esac
  fi

  # PHP 8.4 with extensions
  if ! command -v php &>/dev/null; then
    log_info "Installing PHP 8.4..."

    case "$DISTRO" in
    "ubuntu" | "debian" | "linuxmint")
      # Add PHP repository
      sudo apt install -y software-properties-common
      sudo add-apt-repository ppa:ondrej/php -y
      sudo apt update

      # Install PHP 8.4 and extensions
      sudo apt install -y php8.4 php8.4-cli php8.4-fpm php8.4-mysql php8.4-pgsql \
        php8.4-sqlite3 php8.4-gd php8.4-imagick php8.4-curl php8.4-mbstring \
        php8.4-xml php8.4-zip php8.4-bcmath php8.4-intl php8.4-redis \
        php8.4-xdebug php8.4-opcache php8.4-json php8.4-common
      ;;
    "fedora")
      # Enable Remi repository for PHP 8.4
      sudo dnf install -y https://rpms.remirepo.net/fedora/remi-release-$(rpm -E %fedora).rpm
      sudo dnf module enable -y php:remi-8.4

      # Install PHP 8.4 and extensions
      sudo dnf install -y php php-cli php-fpm php-mysqlnd php-pgsql php-sqlite3 \
        php-gd php-imagick php-curl php-mbstring php-xml php-zip php-bcmath \
        php-intl php-redis php-xdebug php-opcache php-json php-common
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      # Enable Remi repository for PHP 8.4
      sudo dnf install -y https://rpms.remirepo.net/enterprise/remi-release-$(rpm -E %rhel).rpm
      sudo dnf module enable -y php:remi-8.4

      # Install PHP 8.4 and extensions
      sudo dnf install -y php php-cli php-fpm php-mysqlnd php-pgsql php-sqlite3 \
        php-gd php-imagick php-curl php-mbstring php-xml php-zip php-bcmath \
        php-intl php-redis php-xdebug php-opcache php-json php-common
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm php php-gd php-imagick php-redis php-xdebug
      ;;
    esac

    # Install Composer
    if ! command -v composer &>/dev/null; then
      log_info "Installing Composer..."
      curl -sS https://getcomposer.org/installer | php
      sudo mv composer.phar /usr/local/bin/composer
      chmod +x /usr/local/bin/composer
    fi

    log_success "PHP 8.4 with extensions installed"
  else
    log_info "PHP is already installed"
  fi

  # Go (install from official source for latest version)
  if ! command -v go &>/dev/null; then
    log_info "Installing Go from official source..."
    local go_version="1.21.0"
    curl -fsSL "https://go.dev/dl/go${go_version}.linux-amd64.tar.gz" -o /tmp/go.tar.gz
    sudo tar -C /usr/local -xzf /tmp/go.tar.gz
    rm /tmp/go.tar.gz

    # Add Go to PATH if not already there
    if ! grep -q "/usr/local/go/bin" ~/.bashrc 2>/dev/null; then
      echo 'export PATH="/usr/local/go/bin:$PATH"' >>~/.bashrc
    fi
    if ! grep -q "/usr/local/go/bin" ~/.zshrc 2>/dev/null; then
      echo 'export PATH="/usr/local/go/bin:$PATH"' >>~/.zshrc
    fi

    # Source the updated PATH
    export PATH="/usr/local/go/bin:$PATH"

    log_success "Go $(go version) installed from official source"
  else
    log_info "Go is already installed"
  fi

  # Rust
  if ! command -v rustc &>/dev/null; then
    log_info "Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source ~/.cargo/env
  fi
}

# Install Neovim
install_neovim() {
  log_info "Installing Neovim..."

  if ! command -v nvim &>/dev/null; then
    case "$DISTRO" in
    "ubuntu" | "debian" | "linuxmint")
      # Add Neovim PPA for latest version
      sudo add-apt-repository ppa:neovim-ppa/stable -y
      sudo apt update
      sudo apt install -y neovim
      ;;
    "fedora")
      sudo dnf install -y neovim
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      # Install from source for older distributions
      sudo yum install -y neovim
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm neovim
      ;;
    esac
  fi
}

# Install Docker
install_docker() {
  log_info "Installing Docker..."

  if ! command -v docker &>/dev/null; then
    case "$DISTRO" in
    "ubuntu" | "debian" | "linuxmint")
      # Install Docker
      curl -fsSL https://get.docker.com -o get-docker.sh
      sudo sh get-docker.sh
      sudo usermod -aG docker $USER
      rm get-docker.sh
      ;;
    "fedora")
      sudo dnf install -y docker
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo usermod -aG docker $USER
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      sudo yum install -y docker
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo usermod -aG docker $USER
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm docker
      sudo systemctl enable docker
      sudo systemctl start docker
      sudo usermod -aG docker $USER
      ;;
    esac
  fi
}

# Install additional development tools
install_dev_tools() {
  log_info "Installing additional development tools from official sources..."

  # Terraform
  if ! command -v terraform &>/dev/null; then
    log_info "Installing Terraform..."
    local tf_version=$(curl -s https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r '.current_version')
    curl -fsSL "https://releases.hashicorp.com/terraform/${tf_version}/terraform_${tf_version}_linux_amd64.zip" -o /tmp/terraform.zip
    unzip -q /tmp/terraform.zip -d /tmp
    sudo mv /tmp/terraform /usr/local/bin/
    rm /tmp/terraform.zip
    log_success "Terraform ${tf_version} installed"
  fi

  # kubectl
  if ! command -v kubectl &>/dev/null; then
    log_info "Installing kubectl..."
    local k8s_version=$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)
    curl -fsSL "https://storage.googleapis.com/kubernetes-release/release/${k8s_version}/bin/linux/amd64/kubectl" -o /tmp/kubectl
    chmod +x /tmp/kubectl
    sudo mv /tmp/kubectl /usr/local/bin/
    log_success "kubectl ${k8s_version} installed"
  fi

  # Helm
  if ! command -v helm &>/dev/null; then
    log_info "Installing Helm..."
    curl -fsSL https://get.helm.sh/helm-v3.12.0-linux-amd64.tar.gz -o /tmp/helm.tar.gz
    tar -xzf /tmp/helm.tar.gz -C /tmp
    sudo mv /tmp/linux-amd64/helm /usr/local/bin/
    rm -rf /tmp/helm.tar.gz /tmp/linux-amd64
    log_success "Helm 3.12.0 installed"
  fi

  # AWS CLI v2
  if ! command -v aws &>/dev/null; then
    log_info "Installing AWS CLI v2..."
    curl -fsSL "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o /tmp/awscliv2.zip
    unzip -q /tmp/awscliv2.zip -d /tmp
    sudo /tmp/aws/install
    rm -rf /tmp/awscliv2.zip /tmp/aws
    log_success "AWS CLI v2 installed"
  fi

  # GitHub CLI
  if ! command -v gh &>/dev/null; then
    log_info "Installing GitHub CLI..."
    case "$DISTRO" in
    "ubuntu" | "debian" | "linuxmint")
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list >/dev/null
      sudo apt update
      sudo apt install -y gh
      ;;
    "fedora")
      sudo dnf install -y gh
      ;;
    "centos" | "rhel" | "rocky" | "almalinux")
      # Install from official source for older distributions
      curl -fsSL https://cli.github.com/packages/rpm/gh.repo | sudo tee /etc/yum.repos.d/gh.repo
      sudo yum install -y gh
      ;;
    "arch" | "manjaro")
      sudo pacman -S --noconfirm github-cli
      ;;
    esac
  fi
}

# Install language servers
install_language_servers() {
  log_info "Installing language servers..."

  # Node.js language servers
  if command -v npm &>/dev/null; then
    log_info "Installing Node.js language servers..."
    npm install -g typescript typescript-language-server lua-language-server
    npm install -g prettier eslint
  fi

  # Python language server
  if command -v pip3 &>/dev/null; then
    log_info "Installing Python language server..."
    pip3 install python-lsp-server[all]
    pip3 install black flake8 mypy
  fi

  # Go tools
  if command -v go &>/dev/null; then
    log_info "Installing Go tools..."
    go install golang.org/x/tools/gopls@latest
    go install github.com/go-delve/delve/cmd/dlv@latest
  fi

  # Rust tools
  if command -v rustup &>/dev/null; then
    log_info "Installing Rust tools..."
    rustup component add rust-analyzer
    rustup component add rust-src
  fi
}

# Configure system settings
configure_system() {
  log_info "Configuring system settings..."

  # Set zsh as default shell
  if command -v zsh &>/dev/null; then
    if [[ "$SHELL" != "/bin/zsh" ]]; then
      log_info "Setting zsh as default shell..."
      chsh -s $(which zsh)
    fi
  fi

  # Create necessary directories
  mkdir -p ~/.config
  mkdir -p ~/.local/bin
  mkdir -p ~/.ssh

  # Set proper permissions
  chmod 700 ~/.ssh
}

# Main Linux setup
main() {
  detect_distro
  update_package_manager
  install_essential_packages
  install_programming_languages
  install_neovim
  install_docker
  install_dev_tools
  install_language_servers
  configure_system

  log_success "Linux setup completed successfully!"
}

main "$@"

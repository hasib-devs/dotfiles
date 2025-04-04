#!/usr/bin/env zsh

# Source the utils.sh file to use its functions
source "./utils.sh"

PACKAGE_MANAGER=$(detect_package_manager)

# Install latest version of Neovim through AppImage
if ! command_exists nvim; then
  echo "📦 Installing Neovim..."
  case "$PACKAGE_MANAGER" in
  apt) apt install neovim ;;
  yum) sudo yum install -y neovim ;;
  dnf) sudo dnf install -y neovim ;;
  pacman) sudo pacman -Sy --noconfirm neovim ;;
  apk) sudo apk add neovim ;;
  brew) brew install neovim ;;
  *)
    echo "❌ No supported package manager found. Install Neovim manually."
    exit 1
    ;;
  esac

  echo "✅ Neovim installed successfully."
else
  echo "✅ Neovim already installed: $(nvim --version | head -n1)"
fi

# Step Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.2/install.sh | bash
else
  echo "✅ NVM already installed."
fi

# Install the latest Node.js version if not present
if ! command_exists node; then
  echo "⬇️  Installing latest Node.js..."
  nvm install node
else
  echo "✅ Node.js already installed: $(node -v)"
fi

# Install PNPM (Node Package Manager) if not present
if ! command_exists pnpm; then
  echo "📦 Installing PNPM..."
  npm install -g pnpm
else
  echo "✅ PNPM already installed: $(pnpm -v)"
fi

# Step Install Deno if not present
if ! command_exists deno; then
  echo "📥 Installing Deno..."
  curl -fsSL https://deno.land/install.sh | sh
else
  echo "✅ Deno already installed: $(deno --version)"
fi

# Install PHP 8.4 PHP and related extensions
if ! command_exists php; then
  echo "📦 Installing PHP..."
  case "$PACKAGE_MANAGER" in
  apt)
    sudo apt update
    sudo apt install -y software-properties-common
    sudo add-apt-repository ppa:ondrej/php
    sudo apt update
    sudo apt install -y php8.4 php8.4-cli php8.4-fpm php8.4-mysql php8.4-xml php8.4-curl php8.4-mbstring php8.4-zip php8.4-bcmath
    ;;
  yum) sudo yum install -y php ;;
  dnf) sudo dnf install -y php ;;
  pacman) sudo pacman -Sy --noconfirm php ;;
  apk) sudo apk add php ;;
  brew) brew install php@8.4 ;;
  *)
    echo "❌ Unsupported package manager. Please install PHP manually."
    exit 1
    ;;
  esac

  echo "✅ PHP installed successfully."
fi

# Install latest Composer
if ! command_exists composer; then
  echo "📦 Installing Composer..."
  php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
  php composer-setup.php --install-dir=/usr/local/bin --filename=composer
  php -r "unlink('composer-setup.php');"
else
  echo "✅ Composer already installed: $(composer --version)"
fi

# Install latest version of Go if not present
if ! command_exists go; then
  echo "📦 Installing Go..."
  case "$PACKAGE_MANAGER" in
  apt)
    sudo apt update
    sudo apt install -y golang-go
    ;;
  yum) sudo yum install -y golang ;;
  dnf) sudo dnf install -y golang ;;
  pacman) sudo pacman -Sy --noconfirm go ;;
  apk) sudo apk add go ;;
  brew) brew install go ;;
  *)
    echo "❌ Unsupported package manager. Please install Go manually."
    exit 1
    ;;
  esac

  echo "✅ Go installed successfully."
fi

# Install Rust
if ! command_exists rustup; then
  echo "📦 Installing Rust..."
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
else
  echo "✅ Rust already installed: $(rustc --version)"
fi

# # Install Lazygit
if ! command_exists lazygit; then
  echo "📥 Installing Lazygit..."
  case "$PACKAGE_MANAGER" in
  apt)
    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | \grep -Po '"tag_name": *"v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_VERSION}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit -D -t /usr/local/bin/
    ;;
  yum) sudo yum install -y lazygit ;;
  dnf) sudo dnf install -y lazygit ;;
  pacman) sudo pacman -Sy --noconfirm lazygit ;;
  apk) sudo apk add lazygit ;;
  brew) brew install lazygit ;;
  *)
    echo "❌ No supported package manager found. Install Lazygit manually."
    ;;
  esac
else
  echo "✅ Lazygit already installed."
fi

# Install Tmux
if ! command_exists tmux; then
  echo "tmux not found, installing tmux..."
  if [[ "$OSTYPE" == "darwin"* ]]; then
    # For macOS
    brew install tmux
  elif [[ -x "$(command -v apt)" ]]; then
    # For Debian/Ubuntu
    sudo apt update
    sudo apt install -y tmux
  elif [[ -x "$(command -v pacman)" ]]; then
    # For Arch Linux
    sudo pacman -S tmux --noconfirm
  else
    echo "Unsupported package manager. Please install tmux manually."
    exit 1
  fi
else
  echo "✅ tmux is already installed."
fi

# Install Tmux Plugin Manager (TPM)
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
  echo "📦 Installing Tmux Plugin Manager (TPM)..."
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
else
  echo "✅ Tmux Plugin Manager (TPM) already installed."
fi

echo "🎉 Environment setup complete!"

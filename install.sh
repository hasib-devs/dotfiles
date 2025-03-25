#!/bin/bash

echo "🛠️ Setting up your development environment..."

# Detect the package manager
detect_package_manager() {
  if [ -x "$(command -v apt)" ]; then
    echo "apt"
  elif [ -x "$(command -v yum)" ]; then
    echo "yum"
  elif [ -x "$(command -v dnf)" ]; then
    echo "dnf"
  elif [ -x "$(command -v pacman)" ]; then
    echo "pacman"
  elif [ -x "$(command -v apk)" ]; then
    echo "apk"
  else
    echo "unknown"
  fi
}

PACKAGE_MANAGER=$(detect_package_manager)

# Ensure root privileges if sudo is not available
if ! command -v sudo &> /dev/null; then
  echo "⚠️  sudo not found, attempting to install it..."

  case "$PACKAGE_MANAGER" in
    apt) su -c "apt update && apt install -y sudo" ;;
    yum) su -c "yum install -y sudo" ;;
    dnf) su -c "dnf install -y sudo" ;;
    pacman) su -c "pacman -Sy --noconfirm sudo" ;;
    apk) su -c "apk add sudo" ;;
    *)
      echo "❌ Unsupported package manager. Please install sudo manually."
      exit 1
      ;;
  esac

  echo "✅ sudo installed."
fi

# Ensure curl is installed
if ! command -v curl &> /dev/null; then
  echo "📦 Installing curl..."

  if [ "$PACKAGE_MANAGER" = "apt" ]; then
    sudo apt update && sudo apt install -y curl
  elif [ "$PACKAGE_MANAGER" = "yum" ]; then
    sudo yum install -y curl
  elif [ "$PACKAGE_MANAGER" = "dnf" ]; then
    sudo dnf install -y curl
  elif [ "$PACKAGE_MANAGER" = "pacman" ]; then
    sudo pacman -Sy --noconfirm curl
  elif [ "$PACKAGE_MANAGER" = "apk" ]; then
    sudo apk add curl
  else
    echo "❌ No supported package manager found. Install curl manually."
    exit 1
  fi

  echo "✅ curl installed."
fi

# Symlink essential dotfiles
ln -sf ~/dotfiles/.zshrc ~/.zshrc
ln -sf ~/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/dotfiles/.tmux.conf ~/.tmux.conf

# Helper function: Check if a command exists
command_exists() {
  command -v "$1" >/dev/null 2>&1
}

# Step 1: Ensure Zsh is installed
if ! command_exists zsh; then
  echo "📦 Installing Zsh..."

  if command_exists apt; then
    sudo apt update && sudo apt install -y zsh
  elif command_exists brew; then
    brew install zsh
  elif command_exists yum; then
    sudo yum install -y zsh
  elif command_exists pacman; then
    sudo pacman -Sy --noconfirm zsh
  else
    echo "❌ No compatible package manager found. Install Zsh manually."
    exit 1
  fi

  echo "✅ Zsh installed successfully."
fi

# Step 2: Switch to Zsh if not already in Zsh
if [ -z "$ZSH_VERSION" ]; then
  echo "🔄 Switching to Zsh..."
  exec zsh "$0"  # Restart script using Zsh
  exit
fi

# Step 3: Set Zsh as the default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "🔧 Setting Zsh as the default shell..."
  chsh -s "$(which zsh)"
fi

# Step 4: Install Oh My Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "🚀 Installing Oh My Zsh..."
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" --unattended
else
  echo "✅ Oh My Zsh already installed."
fi

# Step 5: Install Powerlevel10k theme
if [ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]; then
  echo "🎨 Installing Powerlevel10k theme..."
  git clone --depth=1 https://github.com/romkatv/powerlevel10k.git \
    ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
fi

# Step 6: Install Zsh Plugins
PLUGINS_DIR="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"

# zsh-autosuggestions
if [ ! -d "$PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "🔍 Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$PLUGINS_DIR/zsh-autosuggestions"
fi

# zsh-syntax-highlighting
if [ ! -d "$PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "🖍️  Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Step 7: Install NVM (Node Version Manager)
if [ ! -d "$HOME/.nvm" ]; then
  echo "📦 Installing NVM (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
else
  echo "✅ NVM already installed."
fi

# Load NVM environment
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# Install the latest Node.js version if not present
if ! command_exists node; then
  echo "⬇️  Installing latest Node.js..."
  nvm install node
  nvm use node
  nvm alias default node
else
  echo "✅ Node.js already installed: $(node -v)"
fi

# Step 8: Install Deno if not present
if ! command_exists deno; then
  echo "📥 Installing Deno..."
  curl -fsSL https://deno.land/install.sh | sh
  export DENO_INSTALL="$HOME/.deno"
  export PATH="$DENO_INSTALL/bin:$PATH"
else
  echo "✅ Deno already installed: $(deno --version)"
fi

# Step 9: Install Lazygit
if ! command_exists lazygit; then
  echo "📥 Installing Lazygit..."
  if command_exists apt; then
    sudo add-apt-repository ppa:lazygit-team/release -y && sudo apt update && sudo apt install -y lazygit
  elif command_exists brew; then
    brew install jesseduffield/lazygit/lazygit
  elif command_exists yum; then
    sudo yum install -y lazygit
  elif command_exists pacman; then
    sudo pacman -Sy --noconfirm lazygit
  else
    echo "❌ No compatible package manager found. Install Lazygit manually."
  fi
else
  echo "✅ Lazygit already installed."
fi


# Step 10: Source the new Zsh configuration
echo "🔄 Reloading Zsh configuration..."
source ~/.zshrc

echo "🎉 Environment setup complete!"


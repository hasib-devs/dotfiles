# Dotfiles

A comprehensive, modular Neovim configuration with advanced features for web development and DevOps workflows. This setup includes automatic system configuration scripts for fresh Linux and macOS installations.

## 🚀 Quick Start

### For Fresh Systems

1. **Clone the repository:**

   ```bash
   git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
   cd ~/dotfiles
   ```

2. **Run the automatic setup:**

   ```bash
   ./setup.sh
   ```

   This will automatically:

   - Detect your operating system (Linux/macOS)
   - Install all necessary development tools
   - Configure Neovim with advanced features
   - Set up shell configurations (bash/zsh)
   - Configure Git with aliases and settings
   - Set up SSH keys and configuration
   - Install language servers for development

### For Existing Systems

If you only want to set up specific components:

```bash
# Only setup Neovim
./setup.sh --neovim-only

# Only setup tmux
./setup.sh --tmux-only

# Only setup shell configuration
./setup.sh --shell-only

# Only run OS-specific setup
./setup.sh --os-only

# Skip backup step
./setup.sh --skip-backup
```

## 📋 What's Included

### 🛠️ System Setup

- **macOS**: Homebrew, essential tools, GUI apps, system preferences
- **Linux**: Package managers (apt, dnf, yum, pacman), development tools
- **Common**: Programming languages, language servers, development utilities
- **Node.js**: Installed via NVM for latest LTS versions and version management
- **Development Tools**: Installed from official sources (Terraform, kubectl, Helm, AWS CLI, Docker, Go) for latest versions

### 🎯 Neovim Configuration

- **Plugin-free**: Pure Lua configuration for maximum performance
- **LSP Support**: TypeScript, Python, Go, Rust, and more
- **Advanced Features**:
  - Fuzzy file finding and project-wide search
  - Git integration with blame, diff, status
  - Advanced text manipulation and multiple cursors
  - Project management and workspace handling
  - Testing integration for multiple languages
  - Performance monitoring and optimization

### 🐚 Shell Configuration

- **Bash & Zsh**: Optimized configurations with aliases
- **Oh My Zsh**: Enhanced shell experience with plugins
- **Custom Aliases**: Development, Git, Docker, Kubernetes shortcuts

### 🔧 Development Tools

- **Git**: Comprehensive configuration with aliases and hooks
- **SSH**: Key management and service configuration
- **Language Servers**: Full IDE-like experience for multiple languages

## 🎮 Features

### **Core Development Tools**

- **Node.js** (via NVM for latest versions)
- **pnpm** (fast, disk space efficient package manager)
- **Python 3** with pip and virtual environments
- **PHP 8.4** with essential extensions (Redis, Xdebug, Imagick, etc.)
- **Go** (latest version from official source)
- **Rust** (via rustup)
- **Docker** (latest version from official source)
- **Terraform** (latest version from official source)
- **kubectl** (latest version from official source)
- **Helm** (latest version from official source)
- **AWS CLI** (latest version from official source)
- **GitHub CLI** (latest version from official source)

### **Development Environment**

- **Neovim** with modular Lua configuration
- **tmux** with TPM (Tmux Plugin Manager) and optimized configuration
- **Git** with optimized configuration
- **SSH** key generation and configuration
- **Shell** configuration (bash/zsh)
- **Language servers** for enhanced development experience

### Advanced Search & Navigation

- **Fuzzy File Finder**: `Ctrl+P` - Find files instantly
- **Project Search**: `Ctrl+Shift+F` - Search across entire project
- **Recent Files**: `Ctrl+Shift+R` - Quick access to recent files
- **Buffer Picker**: `Ctrl+B` - Switch between open buffers
- **Line Jumping**: `Ctrl+G` - Jump to specific line numbers
- **Bookmarks**: `Ctrl+M` - Save and jump to bookmarks

### Git Integration

- **Status**: `Space+g+s` - View Git status
- **Blame**: `Space+g+b` - Show line-by-line blame
- **Diff**: `Space+g+d` - View changes
- **Branch**: `Space+g+b` - Manage branches
- **Commit**: `Space+g+c` - Create commits
- **Push/Pull**: `Space+g+p` - Push and pull changes
- **Stash**: `Space+g+t` - Manage stashes

### Advanced Text Manipulation

- **Multiple Cursors**: `Ctrl+N` - Add multiple cursors
- **Text Objects**: Enhanced text object selection
- **Macro Management**: Record and replay macros
- **Code Folding**: `Space+z` - Fold/unfold code blocks
- **Text Transformations**: `Space+t` - Transform text case, format
- **Comment Management**: `Space+c` - Toggle comments

### Project Management

- **Project Detection**: Automatic project type detection
- **Workspace Management**: `Space+p+w` - Manage workspaces
- **Build Automation**: `Space+p+b` - Run build commands
- **Templates**: `Space+p+t` - Use project templates
- **Environment Management**: `Space+p+e` - Manage environments

### Testing Integration

- **Multi-language Support**: Jest, Mocha, pytest, unittest, go test, cargo test
- **Test Execution**: `Space+t+r` - Run tests
- **Coverage**: `Space+t+c` - View test coverage
- **Watch Mode**: `Space+t+w` - Run tests in watch mode
- **Debugging**: `Space+t+d` - Debug tests

### Performance Optimization

- **Real-time Monitoring**: `Space+p+m` - Monitor performance
- **Resource Tracking**: Track memory and CPU usage
- **Optimization Suggestions**: Get performance tips
- **Startup Analysis**: Analyze Neovim startup time
- **Profiling**: Profile code execution

## 🔧 Command Line Options

The setup script supports various options for selective installation:

```bash
# Full setup (default)
./setup.sh

# Only backup existing configurations
./setup.sh --backup

# Skip backup step
./setup.sh --skip-backup

# Only run OS-specific setup
./setup.sh --os-only

# Only setup Neovim
./setup.sh --neovim-only

# Only setup tmux
./setup.sh --tmux-only

# Only setup shell configuration
./setup.sh --shell-only

# Show help
./setup.sh --help
```

## 🔧 Setup Scripts

### Main Setup (`setup.sh`)

The main orchestrator that runs all setup steps:

- OS detection and validation
- Backup existing configurations
- Run OS-specific setup
- Configure all components
- Provide completion instructions

### OS-Specific Scripts

- **`scripts/setup_macos.sh`**: macOS-specific installation and configuration
- **`scripts/setup_linux.sh`**: Linux distribution-specific setup

### Component Scripts

- **`scripts/setup_common.sh`**: Shared configurations and tools
- **`scripts/setup_neovim.sh`**: Neovim installation and configuration
- **`scripts/setup_tmux.sh`**: Tmux installation and configuration
- **`scripts/setup_shell.sh`**: Shell configuration and aliases
- **`scripts/setup_git.sh`**: Git configuration and user setup
- **`scripts/setup_ssh.sh`**: SSH keys and service configuration
- **`scripts/setup_final.sh`**: Final utilities and completion

## 🛠️ Available Utilities

After setup, you'll have access to these utilities:

```bash
# Show completion instructions
dotfiles-complete

# Update dotfiles
dotfiles-update

# Show system information
system-info

# Manage SSH keys
ssh-key-manager

# Check development environment
dev-check
```

## 📁 Project Structure

```
dotfiles/
├── setup.sh                 # Main setup script
├── .tmux.conf              # Tmux configuration
├── scripts/                 # Setup scripts
│   ├── setup_macos.sh      # macOS setup
│   ├── setup_linux.sh      # Linux setup
│   ├── setup_common.sh     # Common setup
│   ├── setup_neovim.sh     # Neovim setup
│   ├── setup_tmux.sh       # Tmux setup
│   ├── setup_shell.sh      # Shell setup
│   ├── setup_git.sh        # Git setup
│   ├── setup_ssh.sh        # SSH setup
│   └── setup_final.sh      # Final setup
├── nvim/                   # Neovim configuration
│   ├── init.lua           # Main Neovim config
│   ├── lua/
│   │   ├── core/          # Core settings
│   │   └── features/      # Feature modules
│   └── README.md          # Neovim documentation
└── README.md              # This file
```

## 🎯 Key Bindings

### Navigation

- `Ctrl+P` - Fuzzy file finder
- `Ctrl+Shift+F` - Project-wide search
- `Ctrl+Shift+R` - Recent files
- `Ctrl+B` - Buffer picker
- `Ctrl+G` - Line jumping
- `Ctrl+M` - Bookmarks

### Git (Space+g)

- `s` - Status
- `b` - Blame
- `d` - Diff
- `c` - Commit
- `p` - Push/Pull
- `t` - Stash

### Text Manipulation (Space+t)

- `m` - Multiple cursors
- `f` - Code folding
- `t` - Text transformations
- `c` - Comments

### Project Management (Space+p)

- `w` - Workspace management
- `b` - Build automation
- `t` - Templates
- `e` - Environment management

### Testing (Space+t)

- `r` - Run tests
- `c` - Coverage
- `w` - Watch mode
- `d` - Debug

## 🎯 Customization

### Node.js Management with NVM

The setup installs Node.js via NVM (Node Version Manager) for better version control:

```bash
# List installed Node.js versions
nvm list

# Install a specific version
nvm install 18.17.0

# Use a specific version
nvm use 18.17.0

# Set default version
nvm alias default 18.17.0

# Install latest LTS
nvm install --lts
```

### Development Tool Management

The setup installs development tools from official sources to ensure latest versions:

```bash
# Check tool versions
terraform --version
kubectl version --client
helm version
aws --version
docker --version
go version

# Update tools (when needed)
# Terraform: Download new version from https://www.terraform.io/downloads
# kubectl: Download from https://kubernetes.io/docs/tasks/tools/
# Helm: Download from https://helm.sh/docs/intro/install/
# AWS CLI: Download from https://aws.amazon.com/cli/
# Docker: Update via Docker Desktop or download from https://www.docker.com/
# Go: Download from https://go.dev/dl/
```

### Neovim Configuration

Edit `~/.config/nvim/` to customize Neovim:

- `init.lua` - Main configuration
- `lua/core/` - Core settings
- `lua/features/` - Feature modules

### Tmux Configuration

- `~/.tmux.conf` - Tmux configuration with TPM plugins
- `~/.tmux/plugins/` - Tmux plugins directory
- **Plugins included**:
  - `tmux-plugins/tpm` - Plugin manager
  - `christoomey/vim-tmux-navigator` - Seamless vim/tmux navigation
  - `jimeh/tmux-themepack` - Beautiful themes
  - `tmux-plugins/tmux-resurrect` - Session persistence
  - `tmux-plugins/tmux-continuum` - Automatic session saving

### Shell Configuration

- `~/.bashrc` - Bash configuration
- `~/.zshrc` - Zsh configuration
- `~/.bash_aliases` - Shell aliases

### Git Configuration

- `~/.gitconfig` - Git settings and aliases
- `~/.gitignore_global` - Global ignore patterns

## 🚨 Troubleshooting

### Common Issues

1. **Setup fails**: Check logs and run individual scripts
2. **Neovim errors**: Check LSP installation and configuration
3. **SSH issues**: Verify key generation and service configuration
4. **Shell problems**: Restart terminal or source configuration files
5. **Tmux plugins not working**: After tmux setup, start tmux and press `Ctrl+a` then `I` (capital I) to install plugins

### Backup and Recovery

- Backups are automatically created in `~/.dotfiles_backup_*`
- **Backed up files include**:
  - Shell configurations (`~/.bashrc`, `~/.zshrc`)
  - Git configuration (`~/.gitconfig`)
  - SSH configuration (`~/.ssh/config`)
  - Neovim configuration (`~/.config/nvim`)
  - Tmux configuration (`~/.tmux.conf`, `~/.tmux`)
- Use `dotfiles-update` to update your configuration

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the setup scripts
5. Submit a pull request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Neovim community for the excellent editor
- Lua community for the powerful scripting language
- All the developers who contributed to the tools and libraries used

---

**Happy coding! 🚀**

For detailed setup instructions, run `dotfiles-complete` after installation.

## 📦 Package Managers

### **Node.js Package Management**

- **NVM**: Node Version Manager for installing and managing Node.js versions
- **pnpm**: Fast, disk space efficient package manager (preferred over npm)
- **npm**: Available as fallback if pnpm is not available

### **System Package Managers**

- **macOS**: Homebrew
- **Ubuntu/Debian**: apt
- **Fedora**: dnf
- **CentOS/RHEL/Rocky/AlmaLinux**: yum/dnf
- **Arch/Manjaro**: pacman

### **Language-Specific Package Managers**

- **Python**: pip3
- **PHP**: Composer
- **Go**: go install
- **Rust**: cargo

## 🛠️ Tools Installed

### **Development Languages & Runtimes**

- **Node.js**: Latest LTS via NVM
- **pnpm**: Fast package manager for Node.js
- **Python 3**: Latest version with pip
- **PHP 8.4**: Latest version with essential extensions
  - Redis extension
  - Xdebug for debugging
  - Imagick for image processing
  - MySQL, PostgreSQL, SQLite support
  - GD, cURL, mbstring, XML, ZIP, BCMath, Intl
  - OPcache for performance
- **Go**: Latest version from official source
- **Rust**: Latest version via rustup

### **DevOps & Cloud Tools**

- **Docker**: Latest version from official source
- **Terraform**: Latest version from official source
- **kubectl**: Latest version from official source
- **Helm**: Latest version from official source
- **AWS CLI**: Latest version from official source
- **GitHub CLI**: Latest version from official source

### **Development Tools**

- **Neovim**: Latest version with modular Lua configuration
- **tmux**: Terminal multiplexer with TPM and optimized configuration
- **Git**: Latest version with optimized configuration
- **Composer**: PHP package manager
- **Language servers**: For enhanced development experience

## 🎯 Usage

### **Node.js Development**

```bash
# Use pnpm for package management (recommended)
pnpm install
pnpm add package-name
pnpm run dev

# Or use npm as fallback
npm install
npm install package-name
npm run dev
```

### **PHP Development**

```bash
# Check PHP version and extensions
php --version
php -m

# Use Composer for PHP packages
composer install
composer require package-name
composer update
```

### **Python Development**

```bash
# Create virtual environment
python3 -m venv venv
source venv/bin/activate

# Install packages
pip3 install package-name
```

### **Go Development**

```bash
# Initialize module
go mod init project-name

# Install dependencies
go mod tidy
go get package-name
```

### **Rust Development**

```bash
# Create new project
cargo new project-name

# Build and run
cargo build
cargo run
```

### **tmux Usage**

```bash
# Start tmux
tmux

# Attach to existing session
tmux attach
# or
tma

# List sessions
tmux list-sessions
# or
tml

# Create new session
tmux new-session
# or
tmn

# Kill session
tmux kill-session
# or
tmk

# Key bindings (prefix: Ctrl+a)
# | - Split vertically
# - - Split horizontally
# j/k/h/l - Resize panes
# m - Maximize/restore pane
# l - Last window
# r - Reload config

# Install plugins (after first setup)
# 1. Start tmux: tmux
# 2. Press: Ctrl+a, then I (capital I)
# 3. Wait for plugin installation to complete
```

# Dotfiles

A comprehensive dotfiles configuration for development environments, featuring a modular Neovim setup with modern plugins and automated system configuration scripts.

## 🚀 Features

### Neovim Configuration

- **Plugin-Based Architecture**: Fully modular plugin system using Lazy.nvim
- **Modern Development Environment**: Complete IDE-like experience with LSP support
- **OneDark Theme**: Beautiful dark theme with enhanced visual feedback
- **Advanced Navigation**: Telescope fuzzy finder, Harpoon quick navigation, LSP Saga
- **Multi-Language Support**: TypeScript, Go, Rust, Python, Lua, and more
- **Git Integration**: Gitsigns, diff view, and conflict resolution
- **Performance Optimized**: Lazy loading and efficient resource usage

### Plugin Modules

- **Completion**: nvim-cmp with LSP integration and snippets
- **Multi-language**: Mason, LSP servers, Conform.nvim formatting
- **Code Actions**: Advanced code action and refactoring support
- **Symbol Navigation**: LSP Saga for enhanced symbol navigation
- **Development**: DAP debugging and development tools
- **UI Enhancements**: OneDark theme, Lualine, Neo-tree file explorer
- **Search**: Telescope fuzzy finder and Harpoon navigation
- **Text Manipulation**: Comments, surround, auto-pairs, case conversion
- **Project Management**: Neo-tree, project detection, workspace management
- **Performance**: Performance monitoring and optimization tools
- **Git**: Gitsigns, blame, diff, and conflict resolution
- **Window Management**: Smart splits, terminal integration, window navigation
- **Editing Enhancements**: Treesitter, text objects, and advanced editing

### System Tools

- **Shell Configuration**: Enhanced shell setup with aliases and functions
- **Git Configuration**: Optimized Git settings and workflow
- **SSH Setup**: Secure SSH configuration and key management
- **tmux Integration**: Terminal multiplexer with TPM and custom config
- **Performance Monitoring**: System and development monitoring tools
- **Development Tools**: Node.js, Go, Rust, Python, and more

## 📦 Installation

### Quick Setup

```bash
# Clone the repository
git clone <repository-url> ~/.dotfiles
cd ~/.dotfiles

# Run the full setup
./setup.sh

# Or run individual components
./setup.sh --neovim-only    # Only setup Neovim
./setup.sh --tmux-only      # Only setup tmux
./setup.sh --performance-only # Only setup performance monitoring
```

### Manual Setup

```bash
# Setup Neovim only
bash scripts/setup_neovim.sh

# Setup tmux only
bash scripts/setup_tmux.sh

# Setup performance monitoring
bash scripts/setup_performance.sh

# Setup shell configuration
bash scripts/setup_shell.sh

# Setup Git configuration
bash scripts/setup_git.sh

# Setup SSH configuration
bash scripts/setup_ssh.sh
```

## 🎯 Key Bindings

### Neovim

#### Basic Operations

- **`<leader>w`** - Save file
- **`<leader>W`** - Save all files
- **`<leader>q`** - Quit
- **`<leader>Q`** - Quit all
- **`<leader>wq`** - Save and quit
- **`<leader>wQ`** - Save all and quit

#### File & Buffer Management

- **`<leader>e`** - Toggle file explorer (Neo-tree)
- **`<leader>ff`** - Find files (Telescope)
- **`<leader>fg`** - Live grep (Telescope)
- **`<leader>fb`** - Find buffer (Telescope)
- **`<leader>h/l`** - Previous/Next buffer

#### Navigation

- **`<C-h/j/k/l>`** - Navigate between windows
- **`gd`** - Go to definition
- **`gr`** - Show references
- **`K`** - Hover documentation
- **`<leader>rn`** - Rename symbol
- **`<leader>ca`** - Code actions

#### Search & Navigation

- **`<leader>a`** - Add file to Harpoon
- **`<leader>1-4`** - Go to Harpoon file 1-4
- **`<leader>ss`** - Show Harpoon menu

#### Text Manipulation

- **`<leader>/`** - Toggle comment
- **`<leader>cs`** - Surround with
- **`<leader>~`** - Toggle case
- **`<A-j/k>`** - Move line up/down

#### Git Integration

- **`]c/[c`** - Next/Previous git hunk
- **`<leader>hp`** - Preview git hunk
- **`<leader>hs`** - Stage git hunk

### tmux

- **`Ctrl+b`** - Prefix key
- **`Ctrl+b c`** - Create new window
- **`Ctrl+b n`** - Next window
- **`Ctrl+b p`** - Previous window
- **`Ctrl+b %`** - Split vertically
- **`Ctrl+b "`** - Split horizontally
- **`Ctrl+b h/j/k/l`** - Navigate panes

## 🔧 Configuration

### Neovim Structure

```
nvim/
├── init.lua                 # Main entry point and basic settings
├── lua/
│   └── plugins/            # Plugin modules
│       ├── init.lua        # Plugin manager setup
│       ├── completion.lua  # Code completion
│       ├── multi_language.lua # LSP servers
│       ├── code_actions.lua # Code actions
│       ├── symbol_navigation.lua # Navigation
│       ├── development.lua # Development tools
│       ├── ui_enhancements.lua # UI improvements
│       ├── search.lua      # Search tools
│       ├── text_manipulation.lua # Text editing
│       ├── project_management.lua # Project tools
│       ├── performance.lua # Performance tools
│       ├── git.lua         # Git integration
│       ├── window_management.lua # Window management
│       └── editing_enhancements.lua # Editing features
├── lazy-lock.json         # Plugin lock file
└── README.md              # Neovim documentation
```

### Language Support

- **TypeScript/JavaScript**: Full LSP support with Prettier formatting
- **Go**: gopls with goimports and gofumpt
- **Rust**: rust-analyzer with rustfmt
- **Python**: pyright with optional formatters
- **Lua**: lua-language-server with stylua
- **Shell**: bash-language-server with shfmt
- **Web**: HTML, CSS, JSON, YAML with Prettier
- **And more**: Docker, PHP, Ruby, etc.

### System Scripts

```
scripts/
├── setup.sh               # Main setup script
├── setup_neovim.sh        # Neovim configuration
├── setup_shell.sh         # Shell configuration
├── setup_git.sh           # Git configuration
├── setup_ssh.sh           # SSH configuration
├── setup_tmux.sh          # tmux configuration
├── setup_performance.sh   # Performance monitoring
├── setup_common.sh        # Common utilities
├── setup_macos.sh         # macOS-specific setup
└── setup_linux.sh         # Linux-specific setup
```

## 🛠️ Customization

### Adding New Plugins

1. Create a new module in `nvim/lua/plugins/`
2. Add the module to the plugin list in `nvim/lua/plugins/init.lua`
3. Configure the plugin in your new module

### Modifying Keymaps

- Global keymaps: `nvim/init.lua`
- Plugin-specific keymaps: Individual plugin modules

### Changing Theme

Edit `nvim/lua/plugins/ui_enhancements.lua` to change the colorscheme.

### System Configuration

- **Shell**: Edit `scripts/setup_shell.sh` for shell customization
- **tmux**: Edit `scripts/setup_tmux.sh` for tmux configuration
- **Git**: Edit `scripts/setup_git.sh` for Git settings

## 📋 Requirements

### System Requirements

- **Neovim**: Version 0.8.0 or higher
- **Node.js**: For LSP servers and formatters
- **Git**: For version control
- **tmux**: For terminal multiplexing (optional)

### Optional Tools

- **Go**: For Go development
- **Rust**: For Rust development
- **Python**: For Python development
- **pnpm/npm**: For Node.js tools
- **Docker**: For container development
- **Terraform**: For infrastructure as code
- **kubectl**: For Kubernetes development
- **Helm**: For Kubernetes package management
- **AWS CLI**: For AWS development
- **GitHub CLI**: For GitHub integration

## 🔄 Updates

### Updating Plugins

```bash
# Start Neovim and update plugins
nvim
:Lazy sync
```

### Updating Configuration

```bash
# Pull latest changes
git pull origin main

# Re-run setup for specific components
./setup.sh --neovim-only
```

### Updating System Tools

```bash
# Update all system tools
./setup.sh

# Update specific components
./setup.sh --performance-only
```

## 🐛 Troubleshooting

### Common Issues

1. **Plugin errors**: Run `:Lazy sync` in Neovim
2. **LSP not working**: Check if language servers are installed with `:Mason`
3. **Performance issues**: Check `:Lazy profile` for slow plugins
4. **Setup script errors**: Check system requirements and permissions

### Debug Mode

```bash
# Start Neovim with debug info
nvim --startuptime startup.log

# Check setup script execution
bash -x scripts/setup_neovim.sh
```

### System-Specific Issues

#### macOS

- Ensure Xcode Command Line Tools are installed
- Check Homebrew installation
- Verify shell is set to zsh

#### Linux

- Check package manager availability
- Verify system dependencies
- Ensure proper permissions

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🤝 Contributing

### Development Setup

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

### Code Style Guidelines

- Use consistent indentation (2 spaces for Lua, 4 for shell)
- Follow language-specific naming conventions
- Add descriptive comments
- Keep functions focused and small
- Use meaningful variable names

## 📞 Support

- **Issues**: Report bugs and feature requests on GitHub
- **Discussions**: Join community discussions for help
- **Documentation**: Check README files and inline comments
- **Examples**: See the configuration files for usage examples

---

**Happy coding! 🚀**

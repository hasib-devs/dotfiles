# Neovim Configuration

A modern, modular Neovim configuration built with pure Lua and powered by Lazy.nvim plugin manager. This configuration provides a complete development environment with comprehensive language support, advanced navigation, and productivity tools.

## 🚀 Features

### Core Architecture

- **Plugin-Based Design**: Fully modular plugin architecture using Lazy.nvim
- **Lazy Loading**: Efficient plugin loading for optimal performance
- **Modern UI**: OneDark theme with enhanced visual feedback
- **LSP-First**: Comprehensive Language Server Protocol integration
- **Performance Optimized**: Minimal startup time with efficient resource usage

### Plugin Modules

#### 🎯 Completion & Intelligence

- **nvim-cmp**: Advanced code completion with LSP integration
- **LuaSnip**: Snippet engine with friendly-snippets
- **lspkind**: Icons for completion menu
- **Smart Suggestions**: Context-aware completion and suggestions

#### 🌍 Multi-Language Support

- **Mason**: LSP, DAP, and linter management
- **nvim-lspconfig**: Language server configuration
- **Conform.nvim**: Code formatting with fallback support
- **null-ls**: Linting and code actions

**Supported Languages:**

- **TypeScript/JavaScript**: Full LSP support with Prettier formatting
- **Go**: gopls with goimports and gofumpt
- **Rust**: rust-analyzer with rustfmt
- **Python**: pyright with optional formatters
- **Lua**: lua-language-server with stylua
- **Shell**: bash-language-server with shfmt
- **Web**: HTML, CSS, JSON, YAML with Prettier
- **And more**: Docker, PHP, Ruby, etc.

#### 🔍 Search & Navigation

- **Telescope**: Fuzzy finder for files, buffers, and live grep
- **Harpoon**: Quick navigation between frequently used files
- **LSP Saga**: Enhanced LSP navigation with floating windows
- **Symbol Navigation**: Advanced symbol search and navigation

#### 🎨 User Interface

- **OneDark**: Beautiful dark theme
- **Lualine**: Enhanced status line with Git and LSP info
- **Indent-blankline**: Indentation guides
- **Neo-tree**: Modern file explorer with Git integration
- **Bufferline**: Tab-like buffer display

#### ✏️ Text Manipulation

- **Comment.nvim**: Smart commenting with NERDCommenter-style
- **nvim-surround**: Surround text with brackets, quotes, etc.
- **nvim-autopairs**: Automatic bracket pairing
- **text-case.nvim**: Case conversion with Telescope integration
- **mini.indentscope**: Indentation scope highlighting

#### 🪟 Window Management

- **smart-splits.nvim**: Enhanced window splitting and navigation
- **mini.move**: Move lines and selections between windows
- **Toggleterm**: Integrated terminal with multiple modes
- **Window Navigation**: Seamless window switching

#### 🚀 Editing Enhancements

- **Treesitter**: Advanced syntax highlighting and text objects
- **nvim-treesitter-context**: Show code context
- **nvim-ts-autotag**: Auto-close HTML/JSX tags
- **nvim-ts-rainbow**: Rainbow parentheses
- **Enhanced Text Objects**: Better text selection and manipulation

#### 📁 Project Management

- **Neo-tree**: File explorer with Git integration
- **Project Detection**: Automatic project type detection
- **Workspace Management**: Multi-workspace support
- **Build Integration**: Language-specific build commands

#### 🔧 Development Tools

- **DAP**: Debug adapter protocol support
- **DAP UI**: Enhanced debugging interface
- **Development Workflow**: Streamlined development experience

#### 📊 Performance & Monitoring

- **Performance Tracking**: Monitor startup time and resource usage
- **Optimization Tools**: Performance analysis and recommendations
- **Resource Monitoring**: Real-time system resource tracking

#### 🐙 Git Integration

- **Gitsigns**: Git status in the gutter
- **Git Blame**: Inline blame information
- **Diff View**: Enhanced diff visualization
- **Conflict Resolution**: Git conflict management tools

## 📦 Installation

### Prerequisites

- Neovim 0.8.0 or higher
- Git (for version control features)
- Node.js (for LSP servers and formatters)

### Quick Start

1. **Clone the configuration**:

   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

2. **Install Language Servers** (recommended):

   ```bash
   # Start Neovim - Mason will install LSP servers automatically
   nvim

   # Or install manually:
   npm install -g typescript typescript-language-server prettier
   go install golang.org/x/tools/gopls@latest
   rustup component add rust-analyzer
   pip install black isort
   ```

3. **First Run**:
   ```bash
   nvim
   # Lazy.nvim will bootstrap automatically
   # Mason will install LSP servers on first use
   ```

### Configuration Structure

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
└── README.md              # This documentation
```

## ⌨️ Key Mappings

### Basic Operations

| Key          | Mode   | Description       |
| ------------ | ------ | ----------------- |
| `<leader>w`  | Normal | Save file         |
| `<leader>W`  | Normal | Save all files    |
| `<leader>q`  | Normal | Quit              |
| `<leader>Q`  | Normal | Quit all          |
| `<leader>wq` | Normal | Save and quit     |
| `<leader>wQ` | Normal | Save all and quit |

### File & Buffer Management

| Key          | Mode   | Description                            |
| ------------ | ------ | -------------------------------------- |
| `<leader>e`  | Normal | Toggle file explorer (Neo-tree)        |
| `<leader>v`  | Normal | Open file explorer in vertical split   |
| `<leader>s`  | Normal | Open file explorer in horizontal split |
| `<leader>ff` | Normal | Find file (Telescope)                  |
| `<leader>fg` | Normal | Live grep (Telescope)                  |
| `<leader>fb` | Normal | Find buffer (Telescope)                |
| `<leader>fh` | Normal | Find help (Telescope)                  |
| `<leader>fo` | Normal | Find old files (Telescope)             |
| `<leader>fm` | Normal | Find marks (Telescope)                 |

### Navigation

| Key           | Mode   | Description              |
| ------------- | ------ | ------------------------ |
| `<C-h/j/k/l>` | Normal | Navigate between windows |
| `<leader>h`   | Normal | Previous buffer          |
| `<leader>l`   | Normal | Next buffer              |
| `<leader>1-9` | Normal | Go to buffer 1-9         |
| `<leader>0`   | Normal | Go to last buffer        |

### Language Server Protocol (LSP)

| Key          | Mode   | Description              |
| ------------ | ------ | ------------------------ |
| `gd`         | Normal | Go to definition         |
| `gr`         | Normal | Show references          |
| `K`          | Normal | Show hover documentation |
| `<leader>rn` | Normal | Rename symbol            |
| `<leader>ca` | Normal | Show code actions        |
| `<leader>f`  | Normal | Format code              |
| `<leader>D`  | Normal | Go to type definition    |
| `[d`         | Normal | Previous diagnostic      |
| `]d`         | Normal | Next diagnostic          |
| `<leader>e`  | Normal | Show diagnostic in float |

### Search & Navigation

| Key           | Mode   | Description            |
| ------------- | ------ | ---------------------- |
| `<leader>a`   | Normal | Add file to Harpoon    |
| `<leader>1-4` | Normal | Go to Harpoon file 1-4 |
| `<leader>5-8` | Normal | Go to Harpoon file 5-8 |
| `<leader>9`   | Normal | Go to Harpoon file 9   |
| `<leader>0`   | Normal | Go to Harpoon file 10  |
| `<leader>ss`  | Normal | Show Harpoon menu      |
| `<leader>sp`  | Normal | Previous Harpoon file  |
| `<leader>sn`  | Normal | Next Harpoon file      |

### Window Management

| Key              | Mode   | Description             |
| ---------------- | ------ | ----------------------- |
| `<leader>wv`     | Normal | Vertical split          |
| `<leader>ws`     | Normal | Horizontal split        |
| `<leader>wc`     | Normal | Close window            |
| `<leader>wo`     | Normal | Close other windows     |
| `<leader>=`      | Normal | Equalize window sizes   |
| `<leader>m`      | Normal | Maximize current window |
| `<C-Up/Down>`    | Normal | Resize window height    |
| `<C-Left/Right>` | Normal | Resize window width     |

### Terminal Integration

| Key          | Mode     | Description                            |
| ------------ | -------- | -------------------------------------- |
| `<leader>tt` | Normal   | Toggle terminal                        |
| `<leader>tj` | Normal   | Terminal in horizontal split           |
| `<leader>tl` | Normal   | Terminal in vertical split             |
| `<C-/>`      | Normal   | Terminal in vertical split (60% width) |
| `<ESC>`      | Terminal | Exit terminal mode                     |

### Text Manipulation

| Key          | Mode          | Description                 |
| ------------ | ------------- | --------------------------- |
| `<leader>/`  | Normal/Visual | Toggle comment              |
| `<leader>cs` | Normal/Visual | Surround with               |
| `<leader>ds` | Normal        | Delete surrounding          |
| `<leader>ys` | Normal/Visual | Add surrounding             |
| `<leader>~`  | Normal/Visual | Toggle case                 |
| `<leader>tc` | Normal/Visual | Convert case                |
| `<A-j/k>`    | Normal/Visual | Move line/selection up/down |
| `<leader>dl` | Normal/Visual | Duplicate line/selection    |

### Git Integration

| Key          | Mode   | Description       |
| ------------ | ------ | ----------------- |
| `<leader>gb` | Normal | Toggle git blame  |
| `<leader>gd` | Normal | Show git diff     |
| `<leader>gs` | Normal | Show git status   |
| `]c`         | Normal | Next git hunk     |
| `[c`         | Normal | Previous git hunk |
| `<leader>hp` | Normal | Preview git hunk  |
| `<leader>hs` | Normal | Stage git hunk    |
| `<leader>hu` | Normal | Undo git hunk     |

### Project Management

| Key          | Mode   | Description                        |
| ------------ | ------ | ---------------------------------- |
| `<leader>pi` | Normal | Show project information           |
| `<leader>ps` | Normal | Apply project settings             |
| `<leader>wa` | Normal | Add current directory to workspace |
| `<leader>wl` | Normal | List all workspaces                |
| `<leader>bi` | Normal | Install dependencies               |
| `<leader>bb` | Normal | Build project                      |
| `<leader>bt` | Normal | Run tests                          |
| `<leader>bd` | Normal | Start development server           |

### Performance & Debugging

| Key          | Mode   | Description                  |
| ------------ | ------ | ---------------------------- |
| `<leader>pm` | Normal | Show performance metrics     |
| `<leader>pp` | Normal | Start performance profiling  |
| `<leader>ps` | Normal | Stop performance profiling   |
| `<leader>po` | Normal | Optimize settings            |
| `<leader>pr` | Normal | Reset settings               |
| `<leader>pa` | Normal | Analyze startup time         |
| `<leader>mm` | Normal | Start resource monitoring    |
| `<leader>ms` | Normal | Stop resource monitoring     |
| `<leader>md` | Normal | Show monitoring data         |
| `<leader>or` | Normal | Generate optimization report |

## 🔧 Configuration

### Plugin Management

The configuration uses Lazy.nvim for plugin management with the following features:

- **Lazy Loading**: Plugins load only when needed
- **Dependency Management**: Automatic dependency resolution
- **Performance Monitoring**: Built-in performance tracking
- **Update Management**: Easy plugin updates and rollbacks

### Adding New Plugins

1. **Create a new module** in `lua/plugins/`:

   ```lua
   -- lua/plugins/myplugin.lua
   return {
       "author/plugin-name",
       event = "VeryLazy",
       config = function()
           -- Plugin configuration
       end,
   }
   ```

2. **Add to plugin list** in `lua/plugins/init.lua`:
   ```lua
   local plugin_modules = {
       -- ... existing modules
       "myplugin",
   }
   ```

### Modifying Keymaps

- **Global keymaps**: Edit `init.lua`
- **Plugin-specific keymaps**: Edit individual plugin modules

### Changing Theme

Edit `lua/plugins/ui_enhancements.lua` to change the colorscheme:

```lua
-- Change from OneDark to another theme
colorscheme = "tokyonight",
```

### Language-Specific Configuration

Add language-specific settings in plugin modules:

```lua
-- Example: Python-specific settings in multi_language.lua
vim.api.nvim_create_autocmd("FileType", {
    pattern = "python",
    callback = function()
        vim.bo.tabstop = 4
        vim.bo.shiftwidth = 4
    end,
})
```

## 🐛 Troubleshooting

### Common Issues

#### Plugin Errors

1. **Update plugins**:

   ```vim
   :Lazy sync
   ```

2. **Check plugin status**:

   ```vim
   :Lazy
   ```

3. **Profile startup time**:
   ```vim
   :Lazy profile
   ```

#### LSP Not Working

1. **Check Language Server Installation**:

   ```vim
   :Mason
   ```

2. **Install missing servers**:

   ```vim
   :MasonInstall lua-language-server
   :MasonInstall typescript-language-server
   ```

3. **Check LSP status**:
   ```vim
   :LspInfo
   ```

#### Performance Issues

1. **Check startup time**:

   ```bash
   nvim --startuptime startup.log
   ```

2. **Profile plugins**:

   ```vim
   :Lazy profile
   ```

3. **Disable problematic plugins**:
   Comment out plugins in `lua/plugins/init.lua`

### Debug Commands

```vim
-- Check LSP clients
:LspInfo

-- Check diagnostics
:LspDiagnostics

-- Check keymaps
:verbose map <key>

-- Check settings
:set <option>?

-- Check runtime path
:lua print(vim.inspect(vim.opt.runtimepath:get()))

-- Check plugin status
:Lazy
```

## 🤝 Contributing

### Development Setup

1. **Fork the repository**
2. **Create a feature branch**:

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**:

   - Follow the existing code style
   - Add appropriate documentation
   - Test thoroughly

4. **Submit a pull request**:
   - Provide clear description of changes
   - Include testing instructions
   - Update documentation if needed

### Code Style Guidelines

- Use consistent indentation (2 spaces)
- Follow Lua naming conventions
- Add descriptive comments
- Keep functions focused and small
- Use meaningful variable names

### Testing

- Test on different Neovim versions
- Verify LSP functionality
- Check keymap conflicts
- Test performance impact

## 📄 License

This configuration is open source and available under the MIT License. See the LICENSE file for details.

## 🙏 Acknowledgments

- Neovim team for the excellent editor
- LSP community for language server support
- Plugin authors for their amazing work
- Neovim community for inspiration and best practices

## 📞 Support

- **Issues**: Report bugs and feature requests on GitHub
- **Discussions**: Join community discussions for help
- **Documentation**: Check this README and inline comments
- **Examples**: See the configuration files for usage examples

---

**Happy coding with Neovim! 🚀**

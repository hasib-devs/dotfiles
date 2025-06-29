# Neovim Configuration

A modern, modular Neovim configuration built with pure Lua, designed for productivity and extensibility. This configuration provides a complete development environment without external plugins, focusing on built-in Neovim capabilities and LSP integration.

## 🚀 Features

### Core Architecture
- **Modular Design**: Clean separation of concerns with dedicated modules for each feature
- **Zero Dependencies**: No external plugins required - everything uses built-in Neovim capabilities
- **LSP-First**: Comprehensive Language Server Protocol integration for multiple languages
- **Performance Optimized**: Minimal startup time with efficient resource usage

### Language Support
- **Multi-Language LSP**: Lua, TypeScript/JavaScript, Go, and extensible for more
- **Intelligent Completion**: Context-aware code completion and suggestions
- **Real-time Diagnostics**: Live error checking, warnings, and code quality feedback
- **Code Actions**: Automated refactoring, quick fixes, and code improvements
- **Symbol Navigation**: Go to definition, find references, and symbol search

### User Interface
- **Custom Statusline**: Git integration, LSP status, file information, and dynamic layout
- **Enhanced Visual Feedback**: Syntax highlighting, diagnostic indicators, and progress notifications
- **Smart Indentation**: Language-specific indentation rules and auto-formatting
- **File Management**: Integrated file explorer and buffer management

### Development Workflow
- **Git Integration**: Inline blame, diff views, status display, and workflow shortcuts
- **Advanced Search**: Project-wide search, fuzzy file finding, and intelligent navigation
- **Text Manipulation**: Multiple cursors, enhanced text objects, and macro management
- **Project Management**: Automatic project detection, workspace management, build automation, and task execution
- **Testing Integration**: Multi-language test runner support, coverage reporting, and debugging capabilities
- **Performance Optimization**: Real-time monitoring, resource tracking, optimization suggestions, and startup analysis

## 📦 Installation

### Prerequisites
- Neovim 0.8.0 or higher
- Git (for version control features)
- Language servers (optional but recommended)

### Quick Start
1. **Clone the configuration**:
   ```bash
   git clone <repository-url> ~/.config/nvim
   ```

2. **Install Language Servers** (recommended):
   ```bash
   # Lua
   npm install -g lua-language-server

   # TypeScript/JavaScript
   npm install -g typescript typescript-language-server

   # Go
   go install golang.org/x/tools/gopls@latest

   # Python (optional)
   pip install python-lsp-server

   # Rust (optional)
   rustup component add rust-analyzer
   ```

3. **Start Neovim**:
   ```bash
   nvim
   ```

### Configuration Structure
```
nvim/
├── init.lua                 # Main entry point and module loader
├── lua/
│   ├── core/               # Core functionality modules
│   │   ├── settings.lua    # Editor settings and preferences
│   │   ├── keymaps.lua     # Key mappings and shortcuts
│   │   └── autocmds.lua    # Auto-commands and event handlers
│   └── features/           # Feature-specific modules
│       ├── lsp.lua         # Language Server Protocol
│       ├── statusline.lua  # Custom statusline
│       ├── search.lua      # Advanced search and navigation
│       ├── git.lua         # Git integration
│       ├── text.lua        # Text manipulation features
│       ├── project.lua     # Project management
│       ├── debug.lua       # Debugging support
│       ├── testing.lua     # Testing integration
│       ├── docs.lua        # Documentation tools
│       └── performance.lua # Performance optimization
└── README.md              # This documentation
```

## ⌨️ Key Mappings

### Navigation & Movement
| Key | Mode | Description |
|-----|------|-------------|
| `<C-h/j/k/l>` | Normal | Navigate between windows |
| `<leader>e` | Normal | Open file explorer |
| `<leader>v` | Normal | Open file explorer in vertical split |
| `<leader>s` | Normal | Open file explorer in horizontal split |
| `<leader>ff` | Normal | Find file by name |
| `<leader>fb` | Normal | Find buffer by name |
| `<leader>fg` | Normal | Search for text pattern in files |

### Language Server Protocol (LSP)
| Key | Mode | Description |
|-----|------|-------------|
| `gd` | Normal | Go to definition |
| `gr` | Normal | Show references |
| `K` | Normal | Show hover documentation |
| `<leader>rn` | Normal | Rename symbol |
| `<leader>ca` | Normal | Show code actions |
| `<leader>cf` | Normal | Format code |
| `<leader>cd` | Normal | Go to declaration |
| `<leader>ci` | Normal | Go to implementation |
| `<leader>ct` | Normal | Go to type definition |
| `<leader>cs` | Normal | Show signature help |
| `[d` | Normal | Previous diagnostic |
| `]d` | Normal | Next diagnostic |
| `<leader>xd` | Normal | Open diagnostics location list |
| `<leader>xe` | Normal | Show diagnostic in float |

### File Operations
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>w` | Normal | Save current file |
| `<leader>W` | Normal | Save all files |
| `<leader>q` | Normal | Close current window |
| `<leader>Q` | Normal | Quit Neovim |
| `<leader>wq` | Normal | Save and close |
| `<leader>c` | Normal | Close current buffer |

### Window Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>wv` | Normal | Vertical split |
| `<leader>ws` | Normal | Horizontal split |
| `<leader>wc` | Normal | Close window |
| `<leader>wo` | Normal | Close other windows |
| `<leader>=` | Normal | Equalize window sizes |
| `<leader>m` | Normal | Maximize current window |
| `<C-Up/Down>` | Normal | Resize window height |
| `<C-Left/Right>` | Normal | Resize window width |

### Buffer Management
| Key | Mode | Description |
|-----|------|-------------|
| `<S-l>` | Normal | Next buffer |
| `<S-h>` | Normal | Previous buffer |
| `<leader>bl` | Normal | List all buffers |
| `<leader><leader>` | Normal | Switch to last buffer |

### Terminal Integration
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | Normal | Open terminal |
| `<leader>tj` | Normal | Terminal in horizontal split |
| `<leader>tl` | Normal | Terminal in vertical split |
| `<C-/>` | Normal | Terminal in vertical split (60% width) |
| `<ESC>` | Terminal | Exit terminal mode |

### Text Manipulation
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>y` | Normal/Visual | Yank to system clipboard |
| `<leader>Y` | Normal | Yank entire file |
| `<leader>ao` | Normal | Add empty line below |
| `<leader>aO` | Normal | Add empty line above |
| `<leader>dl` | Normal/Visual | Duplicate line/selection |
| `<A-j/k>` | Normal/Visual | Move line/selection up/down |
| `<leader>~` | Normal/Visual | Toggle case |
| `<leader>s` | Visual | Sort lines |
| `<leader>S` | Visual | Sort lines (reverse) |

### Search & Replace
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>h` | Normal | Clear search highlighting |
| `<leader>rw` | Normal | Replace word under cursor |
| `<leader>rW` | Normal | Replace word globally |
| `*` | Visual | Search for selected text |
| `#` | Visual | Search for selected text backwards |

### Tab Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tn` | Normal | Create new tab |
| `<leader>tc` | Normal | Close current tab |
| `<leader>tl` | Normal | Next tab |
| `<leader>th` | Normal | Previous tab |
| `<leader>t1-5` | Normal | Go to tab 1-5 |

### Quickfix & Location Lists
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>xo` | Normal | Open quickfix list |
| `<leader>xc` | Normal | Close quickfix list |
| `<leader>xn` | Normal | Next quickfix item |
| `<leader>xp` | Normal | Previous quickfix item |

### Utility
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>so` | Normal | Reload Neovim configuration |
| `<leader>sv` | Normal | Reload vimrc file |
| `jk` | Insert | Exit insert mode |
| `jj` | Insert | Exit insert mode |

### Project Management
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>pi` | Normal | Show project information |
| `<leader>ps` | Normal | Apply project settings |
| `<leader>wa` | Normal | Add current directory to workspace |
| `<leader>wl` | Normal | List all workspaces |
| `<leader>bi` | Normal | Install dependencies |
| `<leader>bb` | Normal | Build project |
| `<leader>bt` | Normal | Run tests |
| `<leader>bd` | Normal | Start development server |

### Testing
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>tt` | Normal | Run all tests |
| `<leader>tf` | Normal | Run tests for current file |
| `<leader>tl` | Normal | Run test at current line |
| `<leader>tc` | Normal | Run tests with coverage |
| `<leader>tw` | Normal | Run tests in watch mode |
| `<leader>tr` | Normal | Show test results |
| `<leader>td` | Normal | Debug test |
| `<leader>ti` | Normal | Show test info |

### Performance
| Key | Mode | Description |
|-----|------|-------------|
| `<leader>pm` | Normal | Show performance metrics |
| `<leader>pp` | Normal | Start performance profiling |
| `<leader>ps` | Normal | Stop performance profiling |
| `<leader>po` | Normal | Optimize settings |
| `<leader>pr` | Normal | Reset settings |
| `<leader>pa` | Normal | Analyze startup time |
| `<leader>mm` | Normal | Start resource monitoring |
| `<leader>ms` | Normal | Stop resource monitoring |
| `<leader>md` | Normal | Show monitoring data |
| `<leader>or` | Normal | Generate optimization report |

## 🔧 Configuration

### Core Settings
The configuration is organized into logical modules:

#### `core/settings.lua`
Contains all editor settings and preferences:
- **Editor appearance**: Line numbers, cursor line, color column
- **Indentation**: Smart indentation with language-specific rules
- **Search**: Case-insensitive search with smart case
- **Performance**: Optimized for speed and responsiveness
- **File handling**: Undo history, backup settings, swap files

#### `core/keymaps.lua`
Defines all key mappings and shortcuts:
- **Navigation**: Window, buffer, and file navigation
- **Text operations**: Copy, paste, and text manipulation
- **LSP integration**: Language server specific mappings
- **Utility**: Quick access to common operations

#### `core/autocmds.lua`
Handles automatic behaviors:
- **Terminal integration**: Special handling for terminal buffers
- **File type detection**: Language-specific settings
- **LSP integration**: Automatic LSP client management
- **Performance monitoring**: Startup time and resource usage

### Feature Modules

#### `features/lsp.lua`
Comprehensive Language Server Protocol support:
```lua
-- Supported languages
- Lua (lua-language-server)
- TypeScript/JavaScript (typescript-language-server)
- Go (gopls)
- Extensible for additional languages

-- Features
- Auto-completion with snippet support
- Real-time diagnostics and error checking
- Code actions and refactoring
- Symbol navigation and search
- Auto-formatting on save
- Enhanced UI with floating windows
```

#### `features/statusline.lua`
Custom statusline with rich information:
```lua
-- Information displayed
- Current mode (NORMAL, INSERT, VISUAL, etc.)
- File name and path
- Git branch and status
- LSP server status
- File type and encoding
- Cursor position and percentage
- Modified and readonly indicators
```

#### `features/search.lua`
Advanced search and navigation (stub for future implementation):
```lua
-- Planned features
- Fuzzy file finding
- Project-wide text search
- Recent files navigation
- Bookmarks and favorites
- Buffer picker
- Line jumping
- Directory navigation
```

#### `features/git.lua`
Git integration features (stub for future implementation):
```lua
-- Planned features
- Inline blame display
- Diff views and staging
- Git status and log
- Branch management
- Commit and push operations
- Stash management
- Workflow shortcuts
```

#### `features/text.lua`
Advanced text manipulation (stub for future implementation):
```lua
-- Planned features
- Multiple cursors
- Enhanced text objects
- Macro management
- Code folding
- Text transformations
- Comment management
```

#### `features/project.lua`
Comprehensive project management system:
```lua
-- Project Detection
- Automatic detection of project types (Node.js, Python, Go, Rust, Docker, Terraform)
- Project-specific settings application
- Git repository detection

-- Workspace Management
- Add/remove workspaces
- List and switch between workspaces
- Project information display

-- Build Automation
- Language-specific build commands
- Install dependencies
- Run tests
- Start development servers
- Build projects

-- Key Features
- Auto-apply project settings on buffer enter
- Floating window for project information
- Quick access to common build tasks
- Workspace persistence across sessions
```

**Keymaps:**
- `<leader>pi` - Show project information
- `<leader>ps` - Apply project settings
- `<leader>wa` - Add current directory to workspace
- `<leader>wl` - List all workspaces
- `<leader>bi` - Install dependencies
- `<leader>bb` - Build project
- `<leader>bt` - Run tests
- `<leader>bd` - Start development server

#### `features/debug.lua`
Debugging support (stub for future implementation):
```lua
-- Planned features
- Debug adapter protocol
- Breakpoint management
- Variable inspection
- Call stack navigation
- Debug console
- Watch expressions
```

#### `features/testing.lua`
Comprehensive testing integration system:
```lua
-- Test Runner Support
- Jest, Mocha for Node.js
- pytest, unittest for Python
- go test for Go
- cargo test for Rust

-- Test Execution
- Run all tests in project
- Run tests for current file
- Run test at current line
- Run tests with coverage
- Run tests in watch mode

-- Test Management
- Automatic test runner detection
- Test results display
- Coverage reporting
- Test debugging support
- Test file detection
```

**Keymaps:**
- `<leader>tt` - Run all tests
- `<leader>tf` - Run tests for current file
- `<leader>tl` - Run test at current line
- `<leader>tc` - Run tests with coverage
- `<leader>tw` - Run tests in watch mode
- `<leader>tr` - Show test results
- `<leader>td` - Debug test
- `<leader>ti` - Show test info

#### `features/docs.lua`
Documentation tools (stub for future implementation):
```lua
-- Planned features
- Documentation generation
- API documentation
- Help system
- Code documentation
- Reference lookup
- Documentation search
```

#### `features/performance.lua`
Comprehensive performance optimization system:
```lua
-- Performance Monitoring
- Real-time memory usage tracking
- System resource monitoring
- Startup time analysis
- Slow function detection

-- Optimization Tools
- Automatic settings optimization
- Performance profiling
- Resource usage alerts
- Optimization recommendations

-- Analysis Features
- Startup time breakdown
- Memory usage history
- System load tracking
- Performance reports
```

**Keymaps:**
- `<leader>pm` - Show performance metrics
- `<leader>pp` - Start performance profiling
- `<leader>ps` - Stop performance profiling
- `<leader>po` - Optimize settings
- `<leader>pr` - Reset settings
- `<leader>pa` - Analyze startup time
- `<leader>mm` - Start resource monitoring
- `<leader>ms` - Stop resource monitoring
- `<leader>md` - Show monitoring data
- `<leader>or` - Generate optimization report

## 🎯 Customization

### Adding New Features
1. **Create a new module** in `lua/features/`:
   ```lua
   -- lua/features/myfeature.lua
   local function setup()
       -- Your feature implementation
   end
   
   return { setup = setup }
   ```

2. **Add to init.lua**:
   ```lua
   require("features.myfeature").setup()
   ```

### Modifying Keymaps
Edit `lua/core/keymaps.lua` to customize keybindings:
```lua
-- Example: Add a custom keymap
map("n", "<leader>my", function()
    -- Your custom function
end, { desc = "My custom action" })
```

### Changing Settings
Modify `lua/core/settings.lua` to adjust editor behavior:
```lua
-- Example: Change indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
```

### Language-Specific Configuration
Add language-specific settings in `core/settings.lua`:
```lua
-- Example: Python-specific settings
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

#### LSP Not Working
1. **Check Language Server Installation**:
   ```bash
   # Verify installation
   which lua-language-server
   which typescript-language-server
   which gopls
   ```

2. **Check LSP Configuration**:
   - Verify file types are supported
   - Check LSP server settings in `features/lsp.lua`
   - Ensure proper on_attach function

3. **Debug LSP Issues**:
   ```lua
   -- Add to init.lua for debugging
   vim.lsp.set_log_level("DEBUG")
   ```

#### Keymaps Not Working
1. **Check for Conflicts**:
   - Verify no duplicate keymap definitions
   - Check mode-specific mappings
   - Ensure leader key is set correctly

2. **Debug Keymaps**:
   ```lua
   -- Check current keymaps
   :verbose map <leader>w
   ```

#### Performance Issues
1. **Monitor Startup Time**:
   ```lua
   -- Add to init.lua
   vim.schedule(function()
       print("Startup time:", vim.fn.reltimefloat(vim.fn.reltime()))
   end)
   ```

2. **Check Resource Usage**:
   - Monitor memory usage
   - Check for memory leaks
   - Optimize heavy operations

### Debugging Commands
```lua
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
- Contributors and maintainers of language servers
- Neovim community for inspiration and best practices

## 📞 Support

- **Issues**: Report bugs and feature requests on GitHub
- **Discussions**: Join community discussions for help
- **Documentation**: Check this README and inline comments
- **Examples**: See the configuration files for usage examples

---

**Happy coding with Neovim! 🚀**

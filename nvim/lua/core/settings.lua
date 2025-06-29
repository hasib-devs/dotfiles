-- =============================================================================
-- Core Settings
-- =============================================================================

-- NOTE: Only core/editor settings should be defined here.
--       Plugin-specific settings should be placed in the relevant plugin config file under nvim/lua/plugins/.

local opt = vim.opt

-- =============================================================================
-- GENERAL SETTINGS
-- =============================================================================

-- Editor appearance
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.cursorlineopt = "line" -- Only highlight the line number
opt.signcolumn = "yes" -- Keep signcolumn on by default
opt.colorcolumn = "80" -- Show column guide
opt.scrolloff = 8 -- Keep 8 lines above/below cursor
opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
opt.wrap = false -- Don't wrap long lines
opt.linebreak = true -- Break lines at word boundaries when wrapping is enabled
opt.showbreak = "↪ " -- Show break indicator

-- Indentation
opt.expandtab = true -- Use spaces instead of tabs
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.autoindent = true
opt.smartindent = true

-- Search settings
opt.hlsearch = true -- Enable search highlighting
opt.incsearch = true -- Enable incremental search
opt.ignorecase = true -- Case-insensitive searching
opt.smartcase = true -- Case-sensitive when capital letters are used
opt.magic = true -- Use magic patterns

-- File handling
opt.undofile = true -- Save undo history
opt.backup = false -- Don't create backup files
opt.writebackup = false -- Don't create backup files while writing
opt.swapfile = false -- Don't create swap files
opt.hidden = true -- Allow switching buffers without saving
opt.confirm = true -- Ask for confirmation before quitting

-- Performance
opt.lazyredraw = true -- Don't redraw while executing macros
opt.updatetime = 300 -- Faster completion (default: 4000ms)
opt.timeoutlen = 300 -- Faster key sequence completion (default: 1000ms)

-- UI improvements
opt.termguicolors = true -- Enable true color support
opt.wildmenu = true -- Command-line completion
opt.wildmode = "longest:full,full"
opt.showmode = false -- Don't show mode in command line (handled by statusline)
opt.showcmd = true -- Show partial command in status line
opt.ruler = true -- Show cursor position
opt.laststatus = 2 -- Always show status line
opt.cmdheight = 1 -- Height of command bar
opt.pumheight = 10 -- Maximum number of items in completion menu

-- File type specific
opt.syntax = "on"
opt.encoding = "UTF-8"
opt.fileencoding = "UTF-8"
opt.mouse = "a" -- Enable mouse in all modes
opt.title = true -- Set window title
opt.splitright = true -- Open new splits to the right
opt.splitbelow = true -- Open new splits below
opt.path:append("**") -- Search in subdirectories
opt.completeopt = "menuone,noselect" -- Better completion

-- Whitespace visualization
opt.list = true
opt.listchars = { 
    tab = "» ", 
    trail = "·", 
    nbsp = "␣",
    extends = "›",
    precedes = "‹"
}

-- Preview substitutions live
opt.inccommand = "split"
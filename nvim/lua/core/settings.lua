-- =============================================================================
-- GENERAL SETTINGS
-- =============================================================================

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Editor appearance
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.cursorline = true
vim.opt.cursorlineopt = "line" -- Only highlight the line number
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.colorcolumn = "80" -- Show column guide
vim.opt.scrolloff = 8 -- Keep 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep 8 columns left/right of cursor
vim.opt.wrap = false -- Don't wrap long lines
vim.opt.linebreak = true -- Break lines at word boundaries when wrapping is enabled
vim.opt.showbreak = "↪ " -- Show break indicator

-- Indentation
vim.opt.expandtab = true -- Use spaces instead of tabs
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.autoindent = true
vim.opt.smartindent = true

-- Search settings
vim.opt.hlsearch = true   -- Enable search highlighting
vim.opt.incsearch = true  -- Enable incremental search
vim.opt.ignorecase = true -- Case-insensitive searching
vim.opt.smartcase = true  -- Case-sensitive when capital letters are used
vim.opt.magic = true      -- Use magic patterns

-- File handling
vim.opt.undofile = true     -- Save undo history
vim.opt.backup = false      -- Don't create backup files
vim.opt.writebackup = false -- Don't create backup files while writing
vim.opt.swapfile = false    -- Don't create swap files
vim.opt.hidden = true       -- Allow switching buffers without saving
vim.opt.confirm = true      -- Ask for confirmation before quitting

-- Performance
vim.opt.lazyredraw = true -- Don't redraw while executing macros
vim.opt.updatetime = 300  -- Faster completion (default: 4000ms)
vim.opt.timeoutlen = 300  -- Faster key sequence completion (default: 1000ms)

-- UI improvements
vim.opt.termguicolors = true -- Enable true color support
vim.opt.wildmenu = true      -- Command-line completion
vim.opt.wildmode = "longest:full,full"
vim.opt.showmode = false     -- Don't show mode in command line (handled by statusline)
vim.opt.showcmd = true       -- Show partial command in status line
vim.opt.ruler = true         -- Show cursor position
vim.opt.laststatus = 2       -- Always show status line
vim.opt.cmdheight = 1        -- Height of command bar
vim.opt.pumheight = 10       -- Maximum number of items in completion menu

-- File type specific
vim.opt.syntax = "on"
vim.opt.encoding = "UTF-8"
vim.opt.fileencoding = "UTF-8"
vim.opt.mouse = "a"                      -- Enable mouse in all modes
vim.opt.title = true                     -- Set window title
vim.opt.splitright = true                -- Open new splits to the right
vim.opt.splitbelow = true                -- Open new splits below
vim.opt.path:append("**")                -- Search in subdirectories
vim.opt.completeopt = "menuone,noselect" -- Better completion

-- Whitespace visualization
vim.opt.list = true
vim.opt.listchars = {
    tab = "» ",
    trail = "·",
    nbsp = "␣",
    extends = "›",
    precedes = "‹"
}

-- Preview substitutions live
vim.opt.inccommand = "split"

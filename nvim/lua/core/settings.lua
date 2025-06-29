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

-- =============================================================================
-- ENHANCED FEATURES
-- =============================================================================

-- Enhanced clipboard integration
local function setup_clipboard()
    -- Check if system clipboard is available
    if vim.fn.has('clipboard') == 1 then
        opt.clipboard = "unnamedplus"
    elseif vim.fn.has('macunix') == 1 then
        opt.clipboard = "unnamed"
    end
end

-- Smart indentation for different file types
local function setup_filetype_indentation()
    local filetype_indent = {
        python = { tabstop = 4, shiftwidth = 4 },
        javascript = { tabstop = 2, shiftwidth = 2 },
        typescript = { tabstop = 2, shiftwidth = 2 },
        json = { tabstop = 2, shiftwidth = 2 },
        yaml = { tabstop = 2, shiftwidth = 2 },
        lua = { tabstop = 2, shiftwidth = 2 },
        html = { tabstop = 2, shiftwidth = 2 },
        css = { tabstop = 2, shiftwidth = 2 },
        scss = { tabstop = 2, shiftwidth = 2 },
        go = { tabstop = 4, shiftwidth = 4 },
        rust = { tabstop = 4, shiftwidth = 4 },
        c = { tabstop = 4, shiftwidth = 4 },
        cpp = { tabstop = 4, shiftwidth = 4 },
        java = { tabstop = 4, shiftwidth = 4 },
        php = { tabstop = 4, shiftwidth = 4 },
        ruby = { tabstop = 2, shiftwidth = 2 },
        sh = { tabstop = 4, shiftwidth = 4 },
        markdown = { tabstop = 2, shiftwidth = 2 },
    }
    
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            local ft = vim.bo.filetype
            local settings = filetype_indent[ft]
            if settings then
                vim.bo.tabstop = settings.tabstop
                vim.bo.shiftwidth = settings.shiftwidth
            end
        end,
    })
end

-- Smart comment handling
local function setup_smart_comments()
    -- Auto-format comments for different file types
    local comment_formats = {
        lua = "-- %s",
        python = "# %s",
        javascript = "// %s",
        typescript = "// %s",
        go = "// %s",
        rust = "// %s",
        json = "// %s",
        yaml = "// %s",
        html = "<!-- %s -->",
        css = "/* %s */",
        scss = "/* %s */",
        markdown = "<!-- %s -->",
        c = "// %s",
        cpp = "// %s",
        java = "// %s",
        php = "// %s",
        sh = "# %s",
        vim = "\" %s",
    }
    
    vim.api.nvim_create_autocmd("FileType", {
        pattern = "*",
        callback = function()
            local ft = vim.bo.filetype
            local format = comment_formats[ft]
            if format then
                vim.bo.commentstring = format
            end
        end,
    })
end

-- Enhanced search with better highlighting
local function setup_search_highlighting()
    -- Custom highlight groups for better search
    vim.api.nvim_set_hl(0, "Search", { fg = "#000000", bg = "#ffff00", bold = true })
    vim.api.nvim_set_hl(0, "IncSearch", { fg = "#000000", bg = "#ffaa00", bold = true })
    vim.api.nvim_set_hl(0, "CurSearch", { fg = "#000000", bg = "#00ff00", bold = true })
end

-- Initialize enhanced features
vim.schedule(function()
    setup_clipboard()
    setup_filetype_indentation()
    setup_smart_comments()
    setup_search_highlighting()
end)

-- Set colorscheme (if available)
vim.schedule(function()
    pcall(cmd, "colorscheme default")
end) 
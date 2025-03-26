local o = vim.opt

o.number = true
o.relativenumber = true
o.expandtab = true
o.shiftwidth = 4
o.tabstop = 4
o.softtabstop = 4
o.cursorline = true
o.undofile = true -- Save undo history
o.confirm = true
o.wildmenu = true
o.wildmode = "longest:full,full"
o.termguicolors = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
o.ignorecase = true
o.smartcase = true

o.syntax = "on"
o.autoindent = true
o.encoding = "UTF-8"
o.mouse = "a"
o.title = true
o.splitright = true
o.splitbelow = true
o.path:append("**")
o.hidden = true
o.signcolumn = "yes" -- Keep signcolumn on by default

-- Decrease update time
-- o.updatetime = 250

-- Decrease mapped sequence wait time
-- o.timeoutlen = 300
-- Don't show the mode, since it's already in the status line
o.showmode = false

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
o.inccommand = "split"

vim.o.sessionoptions = "blank,buffers,curdir,folds,help,tabpages,winsize,winpos,terminal,localoptions"
vim.api.nvim_set_hl(0, "BufferLineError", { fg = "#FF6C6B" }) -- Error: Red
vim.api.nvim_set_hl(0, "BufferLineWarning", { fg = "#ECBE7B" }) -- Warning: Yellow
vim.api.nvim_set_hl(0, "BufferLineHint", { fg = "#98be65" }) -- Hint: Green
vim.api.nvim_set_hl(0, "BufferLineInfo", { fg = "#51afef" }) -- Info: Blue

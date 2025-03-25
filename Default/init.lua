vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
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

-- Enable search highlighting
o.hlsearch = true
-- Enable incremental search (show matches as you type)
o.incsearch = true

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

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
o.list = true
o.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
o.inccommand = "split"

-- Save
map({ "n", "i", "v" }, "<C-s>", ": w <cr><ESC>", { desc = "Save" })
map({ "n", "i", "v" }, "<leader>w", ":w<cr><ESC>", { desc = "Save" })
map({ "n", "i", "v" }, "<leader>W", ":wa<cr><ESC>", { desc = "Save All" })
map({ "i" }, "jk", "<Esc>:w<cr>", { desc = "Save" })

-- Quit
map("n", "<leader>Q", ":qa<CR>", { desc = "Quit All" })
map("n", "<leader>q", ":q<CR>", { desc = "Quite", silent = true })

-- Exit insert mode
map("i", "jj", "<ESC>", { desc = "Exit Insert Mode" })

-- Window Navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left split" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right split" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to below split" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to above split" })

-- Clear highlights on search when pressing <Esc> in normal mode
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Hide search highlight", silent = true })

-- Diagnostic keymaps
map("n", "<leader>xd", vim.diagnostic.setloclist, { desc = "Open diagnostic list", silent = true })
map("n", "<leader>xo", ":copen<CR>", { desc = "Open quickfix list", silent = true })
map("n", "<leader>xc", ":cclose<CR>", { desc = "Close quickfix list", silent = true })

-- Buffer
map("n", "<S-l>", ":bn<CR>", { desc = "Next Buffer", silent = true })
map("n", "<S-h>", ":bp<CR>", { desc = "Prev Buffer", silent = true })
map("n", "<leader>bl", ":ls<CR>", { desc = "Buffers List", silent = true })

-- Open Explorer
map("n", "<leader>e", ":Ex<CR>", { desc = "Explorer", silent = true })
-- Delete current buffer
map("n", "<leader>c", function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buf = vim.api.nvim_get_current_buf()

	if #buffers <= 1 then
	vim.cmd(":Ex") -- Open dashboard
	else
		vim.cmd("bdelete " .. current_buf)
	end
end, { desc = "Delete buffer", silent = true })

-- Add an empty line
map("n", "<leader>ao", "o<Esc>k", { desc = "Add empty line below", silent = true })
map("n", "<leader>aO", "O<Esc>j", { desc = "Add empty line above", silent = true })

-- Terminal
map("n", "<leader>tt", ":term<CR>i", { desc = "Open Terminal" })
map("n", "<leader>tj", ":20split | term<CR>i", { desc = "Open Terminal Bottom" })
map("n", "<leader>tl", ":60vsplit | term<CR>i", { desc = "Open Terminal Right" })
map("n", "<C-/>", ":60vsplit | term<CR>i", { desc = "Open Terminal Right" })
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal default" })

-- Find Files
map("n", "<leader>ff", ":e ", { desc = "Find files" })
map("n", "<leader>fb", ":b ", { desc = "Find buffers" })

-- Search Text
map("n", "<leader>fg", ":vimgrep ", { desc = "Find buffers" })

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	o.clipboard = "unnamedplus"
end)

-- Navigate diagnostics
map('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })

-- LSP actions
map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition" })
map('n', 'gr', vim.lsp.buf.references, { desc = "Go to references" })
map('n', 'K', vim.lsp.buf.hover, { desc = "Hover documentation" })
map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol" })
map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action" })

-- Source Neovim
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { desc = "Open Terminal Right" })


-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.opt_local.number = false
    vim.opt_local.relativenumber = false
  end,
})

-- Create an autocommand to highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",  -- Highlight group (default is yellowish)
      timeout = 150,         -- Duration in milliseconds (default: 150)
      on_visual = true,      -- Also highlight in Visual mode (default: true)
    })
  end,
})

-- Stop comment on new line
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "o", "r" }) -- Stop continuing comments on new lines
	end,
})

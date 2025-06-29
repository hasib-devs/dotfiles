-- =============================================================================
-- Neovim Configuration
-- =============================================================================

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Basic settings to prevent jumping
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.cursorline = false
vim.opt.cursorcolumn = false
vim.opt.relativenumber = false
vim.opt.number = true
vim.opt.wrap = false
vim.opt.linebreak = true
vim.opt.breakindent = true

-- Basic keymaps for saving and quitting
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>wQ", "<cmd>wqa<cr>", { desc = "Save all and quit" })

require("plugins")

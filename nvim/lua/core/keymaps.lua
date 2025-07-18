-- Basic keymaps for saving and quitting
vim.keymap.set("n", "<leader>w", "<cmd>w<cr>", { desc = "Save file" })
vim.keymap.set("n", "<leader>W", "<cmd>wa<cr>", { desc = "Save all files" })
vim.keymap.set("n", "<leader>q", "<cmd>q<cr>", { desc = "Quit" })
vim.keymap.set("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit all" })
vim.keymap.set("n", "<leader>wq", "<cmd>wq<cr>", { desc = "Save and quit" })
vim.keymap.set("n", "<leader>wQ", "<cmd>wqa<cr>", { desc = "Save all and quit" })


-- Move lines up and down
vim.keymap.set("n", "<A-j>", "<cmd>lua require('mini.move').move_line('down')<cr>",
  { desc = "Move line down" })
vim.keymap.set("n", "<A-k>", "<cmd>lua require('mini.move').move_line('up')<cr>", { desc = "Move line up" })
vim.keymap.set("v", "<A-j>", "<cmd>lua require('mini.move').move_selection('down')<cr>",
  { desc = "Move selection down" })
vim.keymap.set("v", "<A-k>", "<cmd>lua require('mini.move').move_selection('up')<cr>",
  { desc = "Move selection up" })

-- Enhanced navigation
vim.keymap.set("n", "j", "gj", { desc = "Move down (display line)" })
vim.keymap.set("n", "k", "gk", { desc = "Move up (display line)" })
vim.keymap.set("v", "j", "gj", { desc = "Move down (display line)" })
vim.keymap.set("v", "k", "gk", { desc = "Move up (display line)" })

-- Jump to last change
vim.keymap.set("n", "g;", "g;zz", { desc = "Jump to last change (centered)" })
vim.keymap.set("n", "g,", "g,zz", { desc = "Jump to next change (centered)" })


vim.keymap.set('n', '<leader>gb', "<cmd>lua require('gitsigns').toggle_current_line_blame()<cr>",
  { desc = 'Toggle git blame' })
vim.keymap.set('n', '<leader>gp', "<cmd>lua require('gitsigns').preview_hunk()<cr>", { desc = 'Preview hunk' })
vim.keymap.set('n', '<leader>gr', "<cmd>lua require('gitsigns').reset_hunk()<cr>", { desc = 'Reset hunk' })
vim.keymap.set('n', '<leader>gs', "<cmd>lua require('gitsigns').stage_hunk()<cr>", { desc = 'Stage hunk' })
vim.keymap.set('n', '<leader>gu', "<cmd>lua require('gitsigns').undo_stage_hunk()<cr>", { desc = 'Undo stage hunk' })

vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Open diffview' })
vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history' })
vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' })

vim.keymap.set('n', '<leader>go', '<cmd>GitConflictChooseOurs<cr>', { desc = 'Choose ours' })
vim.keymap.set('n', '<leader>gt', '<cmd>GitConflictChooseTheirs<cr>', { desc = 'Choose theirs' })
vim.keymap.set('n', '<leader>gn', '<cmd>GitConflictNextConflict<cr>', { desc = 'Next conflict' })
vim.keymap.set('n', '<leader>gp', '<cmd>GitConflictPrevConflict<cr>', { desc = 'Prev conflict' })


-- Keymaps for LSP Saga
vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = "LSP Finder" })
vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" })
vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek Type Definition" })
vim.keymap.set("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "Go to Type Definition" })
vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })
vim.keymap.set("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { desc = "Range Code Action" })
vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Outline" })
vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Documentation" })


vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate to left window" })
vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate to right window" })
vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate to window below" })
vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate to window above" })

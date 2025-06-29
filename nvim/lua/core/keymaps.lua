-- =============================================================================
-- Core Keymaps
-- =============================================================================

-- NOTE: Only core/editor keymaps that cannot be handled by plugins should be defined here.
--       All plugin-specific keymaps are now handled in their respective plugin modules.

local map = vim.keymap.set

-- =============================================================================
-- ESSENTIAL EDITOR KEYMAPS
-- =============================================================================

-- File operations (basic save/quit that plugins can't handle)
map("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
map("n", "<leader>W", ":wa<CR>", { desc = "Save all open files" })
map("n", "<leader>q", ":q<CR>", { desc = "Close current window" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Close all windows and quit" })
map("n", "<leader>wq", ":wq<CR>", { desc = "Save current file and close window" })

-- Basic undo/redo (plugins can enhance but not replace)
map("n", "<leader>u", ":undo<CR>", { desc = "Undo last change" })
map("n", "<leader>r", ":redo<CR>", { desc = "Redo last undone change" })
map("n", "<leader>z", "u", { desc = "Undo last change" })
map("n", "<leader>Z", "<C-r>", { desc = "Redo last undone change" })

-- Basic text manipulation (core functionality)
map("n", "J", "mzJ`z", { desc = "Join current line with next line (preserve cursor)" })
map("n", "<leader>ao", "o<ESC>k", { desc = "Add empty line below current line", silent = true })
map("n", "<leader>aO", "O<ESC>j", { desc = "Add empty line above current line", silent = true })

-- Configuration reload (essential for development)
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { desc = "Reload Neovim configuration" })
map("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "Reload vimrc file" })

-- Clear search highlighting (basic functionality)
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })

-- =============================================================================
-- MINIMAL ENHANCEMENTS
-- =============================================================================

-- Enhanced search (basic improvements that don't require plugins)
local function setup_basic_search_enhancements()
    -- Center screen on search results
    map("n", "n", "nzz", { desc = "Next search result (centered)" })
    map("n", "N", "Nzz", { desc = "Previous search result (centered)" })
    
    -- Jump to last change (centered)
    map("n", "g;", "g;zz", { desc = "Jump to last change (centered)" })
    map("n", "g,", "g,zz", { desc = "Jump to next change (centered)" })
end

-- Initialize basic enhancements
vim.schedule(function()
    setup_basic_search_enhancements()
end) 
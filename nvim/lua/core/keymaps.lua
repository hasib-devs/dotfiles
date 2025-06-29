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
-- Ensure Lua can find modules in nvim/lua
-- local config = vim.fn.stdpath("config")
-- package.path = config .. "/lua/?.lua;" .. config .. "/lua/?/init.lua;" .. package.path

-- =============================================================================
-- Neovim Configuration
-- =============================================================================

-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- =============================================================================
-- CORE MODULES
-- =============================================================================

-- Load core modules first
require("core.settings")
require("core.keymaps")
require("core.autocmds")

-- =============================================================================
-- PLUGINS
-- =============================================================================

-- Load plugin configuration (includes lazy.nvim bootstrap)
require("plugins")

-- =============================================================================
-- STARTUP MESSAGE
-- =============================================================================

-- Print startup completion message
-- vim.schedule(function()
--     print("🎉 Neovim configuration loaded successfully!")
--     print("📚 Use <leader>hh for help")
--     print("⚡ Use <leader>pm for performance metrics")
--     print("🔧 Use <leader>pl to load project config")
-- end)
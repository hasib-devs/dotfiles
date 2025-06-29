-- Ensure Lua can find modules in nvim/lua
-- local config = vim.fn.stdpath("config")
-- package.path = config .. "/lua/?.lua;" .. config .. "/lua/?/init.lua;" .. package.path

-- =============================================================================
-- Neovim Configuration
-- =============================================================================

-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- =============================================================================
-- CORE MODULES
-- =============================================================================

-- Set up runtime path to find lua modules
local config_dir = vim.fn.stdpath("config")
vim.opt.runtimepath:prepend(config_dir)

-- Set leader keys
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Local variables for cleaner code
local map = vim.keymap.set
local opt = vim.opt
local cmd = vim.cmd

-- Load core modules
require("core.settings")
require("core.keymaps")
require("core.autocmds")

-- =============================================================================
-- FEATURE MODULES
-- =============================================================================

-- Load feature modules
require("features.lsp").setup()
require("features.statusline").setup()
require("features.search").setup()
require("features.git").setup()
require("features.text").setup()
require("features.project").setup()
require("features.debug").setup()
require("features.testing").setup()
require("features.docs").setup()
require("features.performance").setup()

-- =============================================================================
-- PLUGINS
-- =============================================================================

-- Initialize lazy.nvim
require("lazy").setup("plugins")

-- Print startup completion message
vim.schedule(function()
    print("🎉 Neovim configuration loaded successfully!")
    print("📚 Use <leader>hh for help")
    print("⚡ Use <leader>pm for performance metrics")
    print("🔧 Use <leader>pl to load project config")
end)
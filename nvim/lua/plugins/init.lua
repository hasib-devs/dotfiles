-- =============================================================================
-- Plugins Module Initialization
-- =============================================================================

-- This file serves as the entry point for the plugins module
-- Individual plugin configurations are loaded from separate files

-- =============================================================================
-- Plugin Management with Lazy.nvim
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

-- Plugin configurations
local plugins = {}

-- Load modular plugin configurations
local plugin_modules = {
    "completion", 
    "multi_language",
    "code_actions",
    "symbol_navigation",
    "development",
    "ui_enhancements",
    "search",
    "text_manipulation",
    "project_management",
    "performance",
    "git",
    "window_management",
    "editing_enhancements",
}

for _, module in ipairs(plugin_modules) do
    local success, module_plugins = pcall(require, "plugins." .. module)
    if success then
        for _, plugin in ipairs(module_plugins) do
            table.insert(plugins, plugin)
        end
    else
        vim.notify("Failed to load plugin module: " .. module, vim.log.levels.WARN)
    end
end

-- Initialize lazy.nvim
require("lazy").setup(plugins, {
    ui = {
        border = "rounded",
        icons = {
            loaded = "●",
            not_loaded = "○",
            cmd = "⌘",
            config = "⚙",
            event = "📅",
            ft = "📂",
            init = "⚡",
            keys = "🎹",
            plugin = "🔌",
            runtime = "💻",
            source = "📄",
            start = "🚀",
            task = "📋",
            lazy = "💤 ",
        },
    },
    performance = {
        rtp = {
            disabled_plugins = {
                "gzip",
                "matchit",
                "matchparen",
                "netrwPlugin",
                "tarPlugin",
                "tohtml",
                "tutor",
                "zipPlugin",
            },
        },
    },
})

return {} 
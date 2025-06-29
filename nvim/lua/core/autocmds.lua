-- =============================================================================
-- Core Autocommands
-- =============================================================================

-- NOTE: Only core/editor autocommands should be defined here.
--       Plugin-specific autocommands should be placed in the relevant plugin config file under nvim/lua/plugins/.

-- Disable line numbers in terminal buffers
vim.api.nvim_create_autocmd("TermOpen", {
    pattern = "*",
    callback = function()
        vim.opt.number = false
        vim.opt.relativenumber = false
        vim.opt.signcolumn = "no"
    end,
})

-- Highlight yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
    pattern = "*",
    callback = function()
        vim.highlight.on_yank({
            higroup = "IncSearch",
            timeout = 150,
            on_visual = true,
        })
    end,
})

-- Stop comment continuation on new lines
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({ "o", "r" })
    end,
})

-- Auto-resize splits when window is resized
vim.api.nvim_create_autocmd("VimResized", {
    pattern = "*",
    command = "wincmd =",
})

-- Return to last edit position when opening files
vim.api.nvim_create_autocmd("BufReadPost", {
    pattern = "*",
    callback = function()
        local last_pos = vim.fn.line("'\"")
        if last_pos > 0 and last_pos <= vim.fn.line("$") then
            vim.fn.setpos(".", vim.fn.getpos("'\""))
        end
    end,
})

-- Auto-save on focus lost
vim.api.nvim_create_autocmd("FocusLost", {
    pattern = "*",
    command = "silent! wall",
})

-- Print startup time
vim.schedule(function()
    local start_time = vim.fn.reltime()
    vim.api.nvim_create_autocmd("VimEnter", {
        pattern = "*",
        callback = function()
            local elapsed = vim.fn.reltimefloat(vim.fn.reltime(start_time))
            print(string.format("Neovim loaded in %.3f seconds", elapsed))
        end,
        once = true,
    })
end) 
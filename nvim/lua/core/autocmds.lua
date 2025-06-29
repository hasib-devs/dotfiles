-- =============================================================================
-- Core Autocommands
-- =============================================================================

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

-- Enhanced LSP diagnostic configuration
vim.diagnostic.config({
    virtual_text = {
        enabled = true,
        spacing = 4,
        prefix = "●",
        source = "if_many",
        format = function(diagnostic)
            if diagnostic.source == "typescript" then
                return string.format("%s [TS]", diagnostic.message)
            elseif diagnostic.source == "gopls" then
                return string.format("%s [Go]", diagnostic.message)
            elseif diagnostic.source == "lua_ls" then
                return string.format("%s [Lua]", diagnostic.message)
            else
                return diagnostic.message
            end
        end,
    },
    signs = {
        enabled = true,
        priority = 10,
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        enabled = true,
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
        max_width = 80,
        max_height = 20,
        format = function(diagnostic)
            if diagnostic.source == "typescript" then
                return string.format("[TS] %s", diagnostic.message)
            elseif diagnostic.source == "gopls" then
                return string.format("[Go] %s", diagnostic.message)
            elseif diagnostic.source == "lua_ls" then
                return string.format("[Lua] %s", diagnostic.message)
            else
                return diagnostic.message
            end
        end,
    },
})

-- LSP progress notification
vim.api.nvim_create_autocmd("User", {
    pattern = "LspProgressUpdate",
    callback = function()
        vim.cmd("redrawstatus")
    end,
})

-- LSP status indicator
vim.api.nvim_create_autocmd("User", {
    pattern = "LspStatusUpdate",
    callback = function()
        vim.cmd("redrawstatus")
    end,
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
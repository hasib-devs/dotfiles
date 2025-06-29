-- =============================================================================
-- Development-Specific Plugins
-- =============================================================================

return {
    -- Better list
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        event = "VeryLazy",
        config = function()
            require("trouble").setup({
                icons = false,
                fold_open = "v",
                fold_closed = ">",
                indent_lines = false,
                signs = {
                    error = "error",
                    warning = "warn",
                    hint = "hint",
                    information = "info",
                },
                use_diagnostic_signs = false,
                action_keys = {
                    refresh = "r",
                    toggle_preview = "P",
                    switch_selection = "<tab>",
                    open_in_browser = "gx",
                    copy_to_clipboard = "<C-c>",
                    toggle_fold = { "za", "zA" },
                    jump = { "<cr>", "<tab>" },
                    open_split = { "<c-x>" },
                    open_vsplit = { "<c-v>" },
                    open_tab = { "<c-t>" },
                    jump_close = { "o" },
                    toggle_mode = "m",
                    switch_selection = { "<space>" },
                    refresh = "R",
                    toggle_preview = "P",
                    hover = "K",
                    preview = "p",
                    close_folds = { "zM", "zm" },
                    open_folds = { "zR", "zr" },
                    toggle_fold = { "zA", "za" },
                    previous = "k",
                    next = "j",
                },
            })
        end,
    },
} 
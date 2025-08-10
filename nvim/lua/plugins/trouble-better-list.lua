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

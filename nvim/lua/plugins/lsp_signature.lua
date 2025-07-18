-- LSP Signature for enhanced signature help
return {
    {
        "ray-x/lsp_signature.nvim",
        event = "VeryLazy",
        opts = {
            bind = true,
            handler_opts = {
                border = "rounded",
            },
            hint_enable = true,
            hint_prefix = "🐼 ",
            hint_scheme = "String",
            hi_parameter = "Search",
            max_height = 12,
            max_width = 120,
            padding = " ",
            toggle_key = "<C-k>",
        },
    },
}

-- =============================================================================
-- Enhanced Code Actions Plugins
-- =============================================================================

return {
    -- LSP Signature for enhanced signature help
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

    -- LSP Saga for enhanced LSP UI
    {
        "glepnir/lspsaga.nvim",
        event = "VeryLazy",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        config = function()
            require("lspsaga").setup({
                ui = {
                    border = "rounded",
                    winblend = 0,
                    expand = "▶",
                    collapse = "▼",
                    preview = "╭",
                    code_action = "💡",
                    diagnostic = "🐛",
                    incoming = "📥",
                    outgoing = "📤",
                    colors = {
                        normal_bg = "#002b36",
                        title_bg = "#afd700",
                        red = "#e06c75",
                        magenta = "#b392f0",
                        orange = "#d19a66",
                        yellow = "#ffcc7b",
                        green = "#98c379",
                        cyan = "#56b6c2",
                        blue = "#61afef",
                        purple = "#c678dd",
                        white = "#abb2bf",
                        black = "#282c34",
                    },
                },
                lightbulb = {
                    enable = true,
                    enable_in_insert = true,
                    sign = true,
                    sign_priority = 40,
                    virtual_text = true,
                },
                symbol_in_winbar = {
                    enable = true,
                    separator = " > ",
                    hide_keyword = true,
                    show_file = true,
                    folder_level = 2,
                    respect_root = false,
                    color_mode = true,
                },
                outline = {
                    win_position = "right",
                    win_with = "",
                    win_width = 30,
                    show_detail = true,
                    auto_preview = true,
                    auto_refresh = true,
                    auto_close = true,
                    custom_sort = nil,
                    keys = {
                        jump = "o",
                        expand_collapse = "u",
                        quit = "q",
                    },
                },
                callhierarchy = {
                    show_detail = false,
                    keys = {
                        edit = "e",
                        vsplit = "s",
                        split = "i",
                        tabe = "t",
                        jump = "o",
                        quit = "q",
                        expand_collapse = "u",
                    },
                },
                beacon = {
                    enable = true,
                    frequency = 7,
                },
                rename = {
                    in_select = false,
                    auto_save = false,
                    project_max_files = 5000,
                    confirm = "<CR>",
                    quit = "<C-c>",
                    exec_timeout = 500,
                    in_insert = false,
                },
                diagnostic = {
                    on_insert = false,
                    on_insert_follow = false,
                    insert_winblend = 0,
                    show_code_action = true,
                    show_source = true,
                    jump_num_shortcut = true,
                    max_width = 0.7,
                    max_height = 0.6,
                    max_show_width = 0.9,
                    max_show_height = 0.6,
                    text_hl_follow = true,
                    border_follow = true,
                    keys = {
                        exec_action = "o",
                        quit = "q",
                        go_action = "g",
                    },
                },
                code_action = {
                    num_shortcut = true,
                    show_server_name = false,
                    extend_gitsigns = true,
                    keys = {
                        quit = "q",
                        exec = "<CR>",
                    },
                },
                inlay_hint = {
                    enable = true,
                    show_parameter_hints = true,
                    parameter_hints_prefix = "<- ",
                    other_hints_prefix = "=> ",
                    max_len_align = false,
                    max_len_align_padding = 1,
                    right_align = false,
                    right_align_padding = 7,
                    highlight = "Comment",
                    priority = 500,
                },
            })
        end,
    },
} 
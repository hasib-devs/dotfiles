-- =============================================================================
-- Symbol Navigation Improvements Plugins
-- =============================================================================

return {
    -- LSP Saga for enhanced LSP UI
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons",
        },
        config = function()
            require("lspsaga").setup({
                ui = {
                    border = "rounded",
                    winblend = 0,
                    expand = "▶",
                    collapse = "▼",
                    preview = "╭─",
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
                    enable = false,
                    enable_in_insert = false,
                    sign = false,
                    sign_priority = 40,
                    virtual_text = false,
                },
                code_action = {
                    num_shortcut = true,
                    show_server_name = false,
                    extend_gitsigns = false,
                    keys = {
                        quit = "q",
                        exec = "<CR>",
                    },
                },
                finder = {
                    max_height = 0.5,
                    min_width = 30,
                    force_max_height = false,
                    keys = {
                        jump_to = "p",
                        edit_or_open = "<CR>",
                        vsplit = "<C-v>",
                        split = "<C-s>",
                        tabe = "<C-t>",
                        tabnew = "<C-n>",
                        quit = "q",
                        close_in_preview = "<ESC>",
                    },
                },
                definition = {
                    edit = "<C-c>o",
                    vsplit = "<C-v>",
                    split = "<C-s>",
                    tabe = "<C-t>",
                    quit = "q",
                    close = "<C-c>k",
                },
                rename = {
                    quit = "<C-c>",
                    exec = "<CR>",
                    mark = "x",
                    confirm = "<CR>",
                    in_select = true,
                },
                diagnostic = {
                    show_code_action = true,
                    show_source = true,
                    jump_num_shortcut = true,
                    max_width = 0.7,
                    custom_fix = nil,
                    custom_msg = nil,
                    text_hl_follow = false,
                    border_follow = true,
                    keys = {
                        exec_action = "r",
                        quit = "q",
                        go_action = "g",
                    },
                },
                outline = {
                    win_position = "right",
                    win_with = "",
                    win_width = 30,
                    show_detail = true,
                    auto_preview = true,
                    auto_refresh = true,
                    auto_close = true,
                    auto_jump = false,
                    custom_cmd = nil,
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
                        vsplit = "v",
                        split = "s",
                        tabe = "t",
                        jump = "o",
                        quit = "q",
                        expand_collapse = "u",
                    },
                },
                implement = {
                    enable = true,
                    sign = true,
                    lang = {},
                    virtual_text = true,
                    priority = 40,
                },
                scroll_preview = {
                    scroll_down = "<C-f>",
                    scroll_up = "<C-b>",
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
                beacon = {
                    enable = true,
                    frequency = 7,
                },
            })

            -- Keymaps for LSP Saga
            vim.keymap.set("n", "gh", "<cmd>Lspsaga lsp_finder<CR>", { desc = "LSP Finder" })
            vim.keymap.set("n", "gD", "<cmd>Lspsaga peek_definition<CR>", { desc = "Peek Definition" })
            vim.keymap.set("n", "gd", "<cmd>Lspsaga goto_definition<CR>", { desc = "Go to Definition" })
            vim.keymap.set("n", "gt", "<cmd>Lspsaga peek_type_definition<CR>", { desc = "Peek Type Definition" })
            vim.keymap.set("n", "gT", "<cmd>Lspsaga goto_type_definition<CR>", { desc = "Go to Type Definition" })
            vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", { desc = "Code Action" })
            vim.keymap.set("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", { desc = "Range Code Action" })
            vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", { desc = "Rename" })
            vim.keymap.set("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", { desc = "Line Diagnostics" })
            vim.keymap.set("n", "[d", "<cmd>Lspsaga diagnostic_jump_prev<CR>", { desc = "Previous Diagnostic" })
            vim.keymap.set("n", "]d", "<cmd>Lspsaga diagnostic_jump_next<CR>", { desc = "Next Diagnostic" })
            vim.keymap.set("n", "<leader>o", "<cmd>Lspsaga outline<CR>", { desc = "Outline" })
            vim.keymap.set("n", "K", "<cmd>Lspsaga hover_doc<CR>", { desc = "Hover Documentation" })
        end,
    },

    -- Treesitter for better syntax highlighting and navigation
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua",
                    "vim",
                    "vimdoc",
                    "javascript",
                    "typescript",
                    "tsx",
                    "json",
                    "yaml",
                    "html",
                    "css",
                    "scss",
                    "python",
                    "go",
                    "rust",
                    "c",
                    "cpp",
                    "java",
                    "php",
                    "ruby",
                    "bash",
                    "markdown",
                    "dockerfile",
                    "sql",
                    "gitignore",
                    "comment",
                    "regex",
                },
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false,
                },
                indent = {
                    enable = true,
                },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "<CR>",
                        node_incremental = "<CR>",
                        node_decremental = "<BS>",
                        scope_incremental = "<TAB>",
                    },
                },
                textobjects = {
                    select = {
                        enable = true,
                        lookahead = true,
                        keymaps = {
                            ["af"] = "@function.outer",
                            ["if"] = "@function.inner",
                            ["ac"] = "@class.outer",
                            ["ic"] = "@class.inner",
                            ["aa"] = "@parameter.outer",
                            ["ia"] = "@parameter.inner",
                            ["al"] = "@loop.outer",
                            ["il"] = "@loop.inner",
                            ["ai"] = "@conditional.outer",
                            ["ii"] = "@conditional.inner",
                            ["ab"] = "@block.outer",
                            ["ib"] = "@block.inner",
                            ["as"] = "@statement.outer",
                            ["is"] = "@statement.inner",
                        },
                    },
                    move = {
                        enable = true,
                        set_jumps = true,
                        goto_next_start = {
                            ["]m"] = "@function.outer",
                            ["]c"] = "@class.outer",
                            ["]a"] = "@parameter.outer",
                            ["]l"] = "@loop.outer",
                            ["]i"] = "@conditional.outer",
                            ["]b"] = "@block.outer",
                            ["]s"] = "@statement.outer",
                        },
                        goto_next_end = {
                            ["]M"] = "@function.outer",
                            ["]C"] = "@class.outer",
                            ["]A"] = "@parameter.outer",
                            ["]L"] = "@loop.outer",
                            ["]I"] = "@conditional.outer",
                            ["]B"] = "@block.outer",
                            ["]S"] = "@statement.outer",
                        },
                        goto_previous_start = {
                            ["[m"] = "@function.outer",
                            ["[c"] = "@class.outer",
                            ["[a"] = "@parameter.outer",
                            ["[l"] = "@loop.outer",
                            ["[i"] = "@conditional.outer",
                            ["[b"] = "@block.outer",
                            ["[s"] = "@statement.outer",
                        },
                        goto_previous_end = {
                            ["[M"] = "@function.outer",
                            ["[C"] = "@class.outer",
                            ["[A"] = "@parameter.outer",
                            ["[L"] = "@loop.outer",
                            ["[I"] = "@conditional.outer",
                            ["[B"] = "@block.outer",
                            ["[S"] = "@statement.outer",
                        },
                    },
                    swap = {
                        enable = true,
                        swap_next = {
                            ["<leader>a"] = "@parameter.inner",
                        },
                        swap_previous = {
                            ["<leader>A"] = "@parameter.inner",
                        },
                    },
                },
            })
        end,
    },
} 
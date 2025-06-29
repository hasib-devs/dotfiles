-- =============================================================================
-- Editing Enhancement Plugins
-- =============================================================================

return {
    -- Enhanced search
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({
                calm_down = true,
                nearest_only = true,
                nearest_float_when = "always",
                virtual_rename = {
                    enable = true,
                    hl_group = "Substitute",
                },
            })

            -- Enhanced search keymaps
            vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<cr>", { desc = "Clear search highlighting", silent = true })
            vim.keymap.set("n", "n", "nzzzv", { desc = "Go to next search result (centered)" })
            vim.keymap.set("n", "N", "Nzzzv", { desc = "Go to previous search result (centered)" })
            vim.keymap.set("n", "*", "*zzzv", { desc = "Search for word under cursor (centered)" })
            vim.keymap.set("n", "#", "#zzzv", { desc = "Search for word under cursor backwards (centered)" })
            
            -- Visual search
            vim.keymap.set("v", "*", "y/\\V<C-r>=escape(@\",'\\/.*$^~[]')<cr><cr>", { desc = "Search for selected text" })
            vim.keymap.set("v", "#", "y?\\V<C-r>=escape(@\",'\\/.*$^~[]')<cr><cr>", { desc = "Search for selected text backwards" })
        end,
    },

    -- Enhanced navigation
    {
        "ggandor/leap.nvim",
        config = function()
            require("leap").add_default_mappings()
            
            -- Enhanced navigation
            vim.keymap.set("n", "j", "gj", { desc = "Move down (display line)" })
            vim.keymap.set("n", "k", "gk", { desc = "Move up (display line)" })
            vim.keymap.set("v", "j", "gj", { desc = "Move down (display line)" })
            vim.keymap.set("v", "k", "gk", { desc = "Move up (display line)" })
            
            -- Jump to last change
            vim.keymap.set("n", "g;", "g;zz", { desc = "Jump to last change (centered)" })
            vim.keymap.set("n", "g,", "g,zz", { desc = "Jump to next change (centered)" })
        end,
    },

    -- Enhanced editing
    {
        "echasnovski/mini.move",
        version = "*",
        config = function()
            require("mini.move").setup()
            
            -- Move lines up and down
            vim.keymap.set("n", "<A-j>", "<cmd>lua require('mini.move').move_line('down')<cr>", { desc = "Move line down" })
            vim.keymap.set("n", "<A-k>", "<cmd>lua require('mini.move').move_line('up')<cr>", { desc = "Move line up" })
            vim.keymap.set("v", "<A-j>", "<cmd>lua require('mini.move').move_selection('down')<cr>", { desc = "Move selection down" })
            vim.keymap.set("v", "<A-k>", "<cmd>lua require('mini.move').move_selection('up')<cr>", { desc = "Move selection up" })
        end,
    },

    -- Duplicate lines
    {
        "machakann/vim-sandwich",
        config = function()
            vim.keymap.set("n", "<leader>dl", "yyp", { desc = "Duplicate current line" })
            vim.keymap.set("v", "<leader>dl", "y`>p", { desc = "Duplicate selected lines" })
        end,
    },

    -- Case conversion
    {
        "johmsalas/text-case.nvim",
        config = function()
            require("textcase").setup({})
            
            -- Case conversion keymaps
            vim.keymap.set("n", "<leader>~", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Toggle case of character under cursor" })
            vim.keymap.set("v", "<leader>~", "<cmd>TextCaseOpenTelescope<CR>", { desc = "Toggle case of selected text" })
        end,
    },

    -- Sort lines
    {
        "sQVe/sort.nvim",
        config = function()
            vim.keymap.set("v", "<leader>s", "<cmd>Sort<cr>", { desc = "Sort selected lines" })
            vim.keymap.set("v", "<leader>S", "<cmd>Sort!<cr>", { desc = "Sort selected lines (reverse)" })
        end,
    },

    -- Enhanced clipboard
    {
        "gbprod/yanky.nvim",
        config = function()
            require("yanky").setup({
                ring = {
                    history_length = 100,
                    storage = "shada",
                    sync_with_numbered_registers = true,
                    cancel_event = "update",
                },
                picker = {
                    select = {
                        action = nil,
                        telescope = require("telescope.themes").get_dropdown({}),
                    },
                    telescope = {
                        mappings = {
                            default = require("yanky.telescope.mapping").set_default_mapping,
                            i = {
                                ["<c-p>"] = require("telescope.actions").cycle_history_prev,
                                ["<c-n>"] = require("telescope.actions").cycle_history_next,
                            },
                        },
                    },
                },
                system_clipboard = {
                    sync_with_ring = true,
                },
                highlight = {
                    on_put = true,
                    on_yank = true,
                    timer = 500,
                },
                preserve_cursor_position = {
                    enabled = true,
                },
            })

            vim.keymap.set("n", "<leader>y", '"+y', { desc = "Yank current line to system clipboard" })
            vim.keymap.set("v", "<leader>y", '"+y', { desc = "Yank selected text to system clipboard" })
            vim.keymap.set("n", "<leader>Y", 'gg"+yG', { desc = "Yank entire file content to system clipboard" })
            vim.keymap.set("n", "<leader>p", "<cmd>YankyRingHistory<cr>", { desc = "Show yank history" })
        end,
    },

    -- Smart buffer switching
    {
        "ghillb/cybu.nvim",
        config = function()
            require("cybu").setup({
                position = {
                    relative_to = "editor",
                    row = "center",
                    col = "center",
                },
                display_time = 1750,
                style = {
                    path = "relative",
                    border = "rounded",
                    separator = " ",
                    prefix = "",
                    padding = 1,
                    hide_buffer_id = true,
                    devicons = {
                        enabled = true,
                        colored = true,
                    },
                },
                behavior = {
                    mode = {
                        default = {
                            switch = "immediate",
                            view = "paging",
                        },
                        last_used = {
                            switch = "immediate",
                            view = "paging",
                        },
                        cwd = {
                            switch = "immediate",
                            view = "paging",
                        },
                    },
                    filter = {
                        exclude = { "notify", "qf", "noice", "lazy" },
                    },
                },
            })

            vim.keymap.set("n", "<leader><leader>", "<cmd>CybuLastused<cr>", { desc = "Switch to last buffer" })
        end,
    },

    -- Quickfix enhancements
    {
        "kevinhwang91/nvim-bqf",
        ft = "qf",
        config = function()
            require("bqf").setup({
                auto_enable = true,
                preview = {
                    win_height = 12,
                    win_vheight = 12,
                    delay_syntax = 80,
                    border_chars = { "┃", "┃", "━", "━", "┏", "┓", "┗", "┛", "█" },
                },
                func_map = {
                    vsplit = "",
                    ptogglemode = "z,",
                    stoggleup = "",
                },
                filter = {
                    fzf = {
                        action_for = { ["ctrl-s"] = "split" },
                        extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
                    },
                },
            })

            vim.keymap.set("n", "<leader>xo", "<cmd>copen<cr>", { desc = "Open quickfix list", silent = true })
            vim.keymap.set("n", "<leader>xc", "<cmd>cclose<cr>", { desc = "Close quickfix list", silent = true })
            vim.keymap.set("n", "<leader>xn", "<cmd>cnext<cr>", { desc = "Go to next quickfix item", silent = true })
            vim.keymap.set("n", "<leader>xp", "<cmd>cprev<cr>", { desc = "Go to previous quickfix item", silent = true })
        end,
    },

    -- Replace with register
    {
        "vim-scripts/ReplaceWithRegister",
        config = function()
            vim.keymap.set("n", "gr", "<Plug>ReplaceWithRegisterOperator", { desc = "Replace with register" })
            vim.keymap.set("n", "grr", "<Plug>ReplaceWithRegisterLine", { desc = "Replace line with register" })
            vim.keymap.set("x", "gr", "<Plug>ReplaceWithRegisterVisual", { desc = "Replace selection with register" })
        end,
    },

    -- Enhanced search and replace
    {
        "nvim-pack/nvim-spectre",
        config = function()
            require("spectre").setup({
                color_devicons = true,
                open_cmd = "vnew",
                live_update = false,
                line_sep_start = "┌──────────────────────────────────────────────────────────────────────────────┐",
                result_padding = "│  ",
                line_sep = "├──────────────────────────────────────────────────────────────────────────────┤",
                highlight = {
                    ui = "String",
                    search = "DiffChange",
                    replace = "DiffDelete",
                },
                mapping = {
                    ["toggle_line"] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "toggle current item",
                    },
                    ["enter_file"] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "goto current file",
                    },
                    ["send_to_qf"] = {
                        map = "<leader>q",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "send all item to quickfix",
                    },
                    ["replace_cmd"] = {
                        map = "<leader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "input replace vim command",
                    },
                    ["show_option_menu"] = {
                        map = "<leader>o",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "show option",
                    },
                    ["run_replace"] = {
                        map = "<leader>R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "replace all",
                    },
                    ["change_view_mode"] = {
                        map = "<leader>v",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "change result view mode",
                    },
                    ["toggle_ignore_case"] = {
                        map = "ti",
                        cmd = "<cmd>lua require('spectre').change_options('ignore_case')<CR>",
                        desc = "toggle ignore case",
                    },
                    ["toggle_ignore_hidden"] = {
                        map = "th",
                        cmd = "<cmd>lua require('spectre').change_options('hidden')<CR>",
                        desc = "toggle ignore hidden",
                    },
                },
                find_engine = {
                    ["rg"] = {
                        cmd = "rg",
                        args = {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                        },
                        options = {
                            ["ignore-case"] = {
                                value = "--ignore-case",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                            ["hidden"] = {
                                value = "--hidden",
                                desc = "hidden file",
                                icon = "[H]",
                            },
                        },
                    },
                    ["ag"] = {
                        cmd = "ag",
                        args = {
                            "--vimgrep",
                            "-s",
                        },
                        options = {
                            ["ignore-case"] = {
                                value = "-i",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                            ["hidden"] = {
                                value = "--hidden",
                                desc = "hidden file",
                                icon = "[H]",
                            },
                        },
                    },
                },
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                        args = nil,
                        options = {
                            ["ignore-case"] = {
                                value = "--ignore-case",
                                icon = "[I]",
                                desc = "ignore case",
                            },
                        },
                    },
                    options = {
                        ["ignore-case"] = {
                            value = "--ignore-case",
                            icon = "[I]",
                            desc = "ignore case",
                        },
                    },
                },
                default = {
                    find = {
                        cmd = "rg",
                        options = { "ignore-case" },
                    },
                    replace = {
                        cmd = "sed",
                    },
                },
                replace_vim_cmd = "cdo",
                is_open_target_win = true,
                is_insert_mode = false,
            })

            vim.keymap.set("n", "<leader>rw", "<cmd>lua require('spectre').open_visual({select_word=true})<CR>", { desc = "Replace word under cursor" })
            vim.keymap.set("n", "<leader>rW", "<cmd>lua require('spectre').open_file_search({select_word=true})<CR>", { desc = "Replace word under cursor globally" })
        end,
    },
} 
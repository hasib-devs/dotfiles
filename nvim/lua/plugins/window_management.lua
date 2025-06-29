-- =============================================================================
-- Window Management Plugins
-- =============================================================================

return {
    -- Better window navigation
    {
        "christoomey/vim-tmux-navigator",
        config = function()
            vim.keymap.set("n", "<C-h>", "<cmd>TmuxNavigateLeft<cr>", { desc = "Navigate to left window" })
            vim.keymap.set("n", "<C-l>", "<cmd>TmuxNavigateRight<cr>", { desc = "Navigate to right window" })
            vim.keymap.set("n", "<C-j>", "<cmd>TmuxNavigateDown<cr>", { desc = "Navigate to window below" })
            vim.keymap.set("n", "<C-k>", "<cmd>TmuxNavigateUp<cr>", { desc = "Navigate to window above" })
        end,
    },

    -- Window resizing
    {
        "mrjones2014/smart-splits.nvim",
        config = function()
            require("smart-splits").setup({
                ignored_filetypes = { "nofile", "quickfix", "prompt" },
                ignored_buftypes = { "nofile" },
                resize_mode = {
                    quit_key = "<ESC>",
                    resize_keys = { "h", "j", "k", "l" },
                    silent = false,
                    hooks = {
                        on_enter = function()
                            vim.notify("Entering resize mode", vim.log.levels.INFO)
                        end,
                        on_leave = function()
                            vim.notify("Exiting resize mode", vim.log.levels.INFO)
                        end,
                    },
                },
                ignored_events = {
                    "BufReadPre",
                    "BufNewFile",
                },
                default_amount = 3,
                at_edge = "stop",
                cursor_follows_swapped_bufs = false,
                resize_callback = nil,
                persist_ratio = false,
                ignore_unsaved_buffers = true,
                handle_unsaved_buffers = "ask",
                tmux_integration = false,
            })
            
            -- Resize windows
            vim.keymap.set("n", "<C-Up>", "<cmd>lua require('smart-splits').resize_up()<cr>", { desc = "Increase window height" })
            vim.keymap.set("n", "<C-Down>", "<cmd>lua require('smart-splits').resize_down()<cr>", { desc = "Decrease window height" })
            vim.keymap.set("n", "<C-Left>", "<cmd>lua require('smart-splits').resize_left()<cr>", { desc = "Decrease window width" })
            vim.keymap.set("n", "<C-Right>", "<cmd>lua require('smart-splits').resize_right()<cr>", { desc = "Increase window width" })
            
            -- Window management
            vim.keymap.set("n", "<leader>wv", "<cmd>vsplit<cr>", { desc = "Split window vertically" })
            vim.keymap.set("n", "<leader>ws", "<cmd>split<cr>", { desc = "Split window horizontally" })
            vim.keymap.set("n", "<leader>wc", "<cmd>close<cr>", { desc = "Close current window" })
            vim.keymap.set("n", "<leader>wo", "<cmd>only<cr>", { desc = "Close all other windows" })
            vim.keymap.set("n", "<leader>=", "<cmd>wincmd =<cr>", { desc = "Equalize window sizes" })
            vim.keymap.set("n", "<leader>m", "<cmd>lua require('smart-splits').maximize_window()<cr>", { desc = "Maximize current window" })
            vim.keymap.set("n", "<leader>wr", "<cmd>wincmd r<cr>", { desc = "Rotate windows" })
            vim.keymap.set("n", "<leader>wR", "<cmd>wincmd R<cr>", { desc = "Rotate windows backwards" })
        end,
    },

    -- Tab management
    {
        "romgrk/barbar.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            local map = vim.keymap.set
            
            -- Tab management
            map("n", "<leader>tn", "<cmd>BufferNew<cr>", { desc = "Create new tab" })
            map("n", "<leader>tc", "<cmd>BufferClose<cr>", { desc = "Close current tab" })
            map("n", "<leader>tl", "<cmd>BufferNext<cr>", { desc = "Go to next tab" })
            map("n", "<leader>th", "<cmd>BufferPrevious<cr>", { desc = "Go to previous tab" })
            map("n", "<leader>t1", "<cmd>BufferGoto 1<cr>", { desc = "Go to tab 1" })
            map("n", "<leader>t2", "<cmd>BufferGoto 2<cr>", { desc = "Go to tab 2" })
            map("n", "<leader>t3", "<cmd>BufferGoto 3<cr>", { desc = "Go to tab 3" })
            map("n", "<leader>t4", "<cmd>BufferGoto 4<cr>", { desc = "Go to tab 4" })
            map("n", "<leader>t5", "<cmd>BufferGoto 5<cr>", { desc = "Go to tab 5" })
            
            -- Buffer management
            map("n", "<S-l>", "<cmd>BufferNext<cr>", { desc = "Switch to next buffer" })
            map("n", "<S-h>", "<cmd>BufferPrevious<cr>", { desc = "Switch to previous buffer" })
            map("n", "<leader>bl", "<cmd>BufferPick<cr>", { desc = "Pick buffer" })
            map("n", "<leader>c", "<cmd>BufferClose<cr>", { desc = "Close current buffer" })
        end,
    },

    -- Terminal management
    {
        "akinsho/toggleterm.nvim",
        version = "*",
        config = function()
            require("toggleterm").setup({
                size = 20,
                open_mapping = [[<c-\>]],
                hide_numbers = true,
                shade_filetypes = {},
                shade_terminals = true,
                shading_factor = 2,
                start_in_insert = true,
                insert_mappings = true,
                persist_size = true,
                direction = "float",
                close_on_exit = true,
                shell = vim.o.shell,
                float_opts = {
                    border = "curved",
                    winblend = 0,
                    highlights = {
                        border = "Normal",
                        background = "Normal",
                    },
                },
            })

            vim.keymap.set("n", "<leader>tt", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
            vim.keymap.set("n", "<leader>tj", "<cmd>ToggleTerm direction=horizontal size=20<cr>", { desc = "Horizontal terminal" })
            vim.keymap.set("n", "<leader>tl", "<cmd>ToggleTerm direction=vertical size=60<cr>", { desc = "Vertical terminal" })
            vim.keymap.set("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
        end,
    },
} 
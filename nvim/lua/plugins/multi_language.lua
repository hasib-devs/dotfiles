-- =============================================================================
-- Multi-Language Project Support Plugins
-- =============================================================================

return {
    -- Mason for LSP, DAP, and linter management
    {
        "williamboman/mason.nvim",
        config = function()
            require("mason").setup({
                max_concurrent_installers = 4,
            })
        end,
    },

    -- LSP Config for Neovim
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "hrsh7th/cmp-nvim-lsp",
        },
        config = function()
            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Global LSP settings
            local on_attach = function(client, bufnr)
                local bufopts = { noremap = true, silent = true, buffer = bufnr }

                -- LSP keymaps
                vim.keymap.set("n", "gD", vim.lsp.buf.declaration, bufopts)
                vim.keymap.set("n", "gd", vim.lsp.buf.definition, bufopts)
                vim.keymap.set("n", "K", vim.lsp.buf.hover, bufopts)
                vim.keymap.set("n", "gi", vim.lsp.buf.implementation, bufopts)
                vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, bufopts)
                vim.keymap.set("n", "<leader>D", vim.lsp.buf.type_definition, bufopts)
                vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, bufopts)
                vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, bufopts)
                vim.keymap.set("n", "gr", vim.lsp.buf.references, bufopts)
                vim.keymap.set("n", "<leader>f", function()
                    vim.lsp.buf.format({ async = true })
                end, bufopts)

                -- Diagnostic keymaps
                vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, bufopts)
                vim.keymap.set("n", "]d", vim.diagnostic.goto_next, bufopts)
                vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, bufopts)

                -- Format on save for supported file types
                if client.supports_method("textDocument/formatting") then
                    vim.api.nvim_create_autocmd("BufWritePre", {
                        buffer = bufnr,
                        callback = function()
                            vim.lsp.buf.format({ async = false })
                        end,
                    })
                end
            end

            -- Language-specific LSP configurations
            local servers = {
                lua_ls = {
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" },
                            },
                            workspace = {
                                library = vim.api.nvim_get_runtime_file("", true),
                            },
                            telemetry = { enable = false },
                        },
                    },
                },
                ts_ls = {
                    settings = {
                        typescript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                        javascript = {
                            inlayHints = {
                                includeInlayParameterNameHints = "all",
                                includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                                includeInlayFunctionParameterTypeHints = true,
                                includeInlayVariableTypeHints = true,
                                includeInlayPropertyDeclarationTypeHints = true,
                                includeInlayFunctionLikeReturnTypeHints = true,
                                includeInlayEnumMemberValueHints = true,
                            },
                        },
                    },
                },
                pyright = {
                    settings = {
                        python = {
                            analysis = {
                                typeCheckingMode = "basic",
                                autoSearchPaths = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "workspace",
                            },
                        },
                    },
                },
                gopls = {
                    settings = {
                        gopls = {
                            analyses = {
                                unusedparams = true,
                            },
                            staticcheck = true,
                            gofumpt = true,
                        },
                    },
                },
                rust_analyzer = {
                    settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                            },
                            checkOnSave = {
                                command = "clippy",
                            },
                        },
                    },
                },
                html = {},
                cssls = {},
                jsonls = {},
                yamlls = {},
                bashls = {},
                dockerls = {},
            }

            -- Setup all LSP servers
            for server, config in pairs(servers) do
                lspconfig[server].setup({
                    on_attach = on_attach,
                    capabilities = capabilities,
                    settings = config.settings,
                })
            end
        end,
    },

    -- Conform.nvim for formatting
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        keys = {
            {
                "<leader>f",
                function()
                    require("conform").format({ async = true, lsp_fallback = true })
                end,
                mode = "",
                desc = "Format buffer",
            },
        },
        opts = function()
            local formatters_by_ft = {}
            
            -- Helper function to add formatters only if they're available
            local function add_formatter_if_available(filetype, formatters)
                local available_formatters = {}
                for _, formatter in ipairs(formatters) do
                    if type(formatter) == "string" then
                        if vim.fn.executable(formatter) == 1 then
                            table.insert(available_formatters, formatter)
                        end
                    elseif type(formatter) == "table" then
                        -- Handle fallback formatters (e.g., ["prettierd", "prettier"])
                        for _, fallback_formatter in ipairs(formatter) do
                            if vim.fn.executable(fallback_formatter) == 1 then
                                table.insert(available_formatters, fallback_formatter)
                                break
                            end
                        end
                    end
                end
                if #available_formatters > 0 then
                    formatters_by_ft[filetype] = available_formatters
                end
            end
            
            -- Add formatters for different file types
            add_formatter_if_available("lua", {"stylua"})
            add_formatter_if_available("python", {"isort", "black"})
            add_formatter_if_available("javascript", {{"prettierd", "prettier"}})
            add_formatter_if_available("typescript", {{"prettierd", "prettier"}})
            add_formatter_if_available("typescriptreact", {{"prettierd", "prettier"}})
            add_formatter_if_available("javascriptreact", {{"prettierd", "prettier"}})
            add_formatter_if_available("json", {{"prettierd", "prettier"}})
            add_formatter_if_available("yaml", {{"prettierd", "prettier"}})
            add_formatter_if_available("markdown", {{"prettierd", "prettier"}})
            add_formatter_if_available("go", {"goimports", "gofumpt"})
            add_formatter_if_available("rust", {"rustfmt"})
            add_formatter_if_available("php", {"php_cs_fixer"})
            add_formatter_if_available("ruby", {"rubocop"})
            add_formatter_if_available("sh", {"shfmt"})
            add_formatter_if_available("css", {{"prettierd", "prettier"}})
            add_formatter_if_available("scss", {{"prettierd", "prettier"}})
            add_formatter_if_available("html", {{"prettierd", "prettier"}})
            
            return {
                notify_on_error = false,
                format_on_save = function(bufnr)
                    local disable_filetypes = { c = true, cpp = true }
                    return {
                        timeout_ms = 500,
                        lsp_fallback = true,
                    }
                end,
                formatters_by_ft = formatters_by_ft,
            }
        end,
    },

    -- None-ls for linting
    {
        "nvimtools/none-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "nvim-lua/plenary.nvim" },
        opts = function()
            local nls = require("null-ls")
            local sources = {
                nls.builtins.code_actions.gitsigns,
                nls.builtins.code_actions.refactoring,
            }
            
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = sources,
            }
        end,
    },
} 
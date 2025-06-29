-- =============================================================================
-- LSP Configuration
-- =============================================================================

local map = vim.keymap.set

-- LSP settings
vim.opt.updatetime = 300 -- Faster completion
vim.opt.signcolumn = "yes" -- Always show sign column

-- LSP setup function
local function setup()
    -- Enhanced LSP capabilities
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    capabilities.textDocument.completion.completionItem.resolveSupport = {
        properties = {
            'documentation',
            'detail',
            'additionalTextEdits',
        }
    }
    capabilities.textDocument.completion.completionItem.tagSupport = { valueSet = { 1 } }
    capabilities.textDocument.completion.completionItem.preselectSupport = true
    capabilities.textDocument.completion.completionItem.insertReplaceSupport = true
    capabilities.textDocument.completion.completionItem.labelDetailsSupport = true
    capabilities.textDocument.completion.completionItem.deprecatedSupport = true
    capabilities.textDocument.completion.completionItem.commitCharactersSupport = true
    capabilities.textDocument.completion.contextSupport = true

    -- Enhanced LSP handlers with better UI
    local handlers = {
        ["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, { 
            border = "rounded",
            max_width = 80,
            max_height = 20,
        }),
        ["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, { 
            border = "rounded",
            max_width = 80,
        }),
        ["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = {
                spacing = 4,
                prefix = "●",
                source = "if_many",
            },
            signs = true,
            update_in_insert = false,
        }),
    }

    -- Enhanced LSP on_attach function
    local function on_attach(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Buffer local mappings
        local bufopts = { noremap = true, silent = true, buffer = bufnr }
        
        -- Enhanced LSP keymaps for this buffer
        map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition", buffer = bufnr })
        map('n', 'gr', vim.lsp.buf.references, { desc = "Show references", buffer = bufnr })
        map('n', 'K', vim.lsp.buf.hover, { desc = "Show hover", buffer = bufnr })
        map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename symbol", buffer = bufnr })
        map('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action", buffer = bufnr })
        map('n', '<leader>cf', vim.lsp.buf.format, { desc = "Format buffer", buffer = bufnr })
        map('n', '<leader>cd', vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = bufnr })
        map('n', '<leader>ci', vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = bufnr })
        map('n', '<leader>ct', vim.lsp.buf.type_definition, { desc = "Go to type definition", buffer = bufnr })
        map('n', '<leader>cs', vim.lsp.buf.signature_help, { desc = "Signature help", buffer = bufnr })

        -- Enhanced diagnostics
        map('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic", buffer = bufnr })
        map('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic", buffer = bufnr })
        map('n', '<leader>xd', vim.diagnostic.setloclist, { desc = "Open diagnostics", buffer = bufnr })
        map('n', '<leader>xe', vim.diagnostic.open_float, { desc = "Show diagnostic", buffer = bufnr })

        -- Enhanced LSP UI and workspace management
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder", buffer = bufnr })
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder", buffer = bufnr })
        map('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, { desc = "List workspace folders", buffer = bufnr })

        -- Set some keybinds conditional on server capabilities
        if client.server_capabilities.documentFormattingProvider then
            map('n', '<leader>cf', vim.lsp.buf.format, { desc = "Format buffer", buffer = bufnr })
        end

        if client.server_capabilities.documentRangeFormattingProvider then
            map('v', '<leader>cf', vim.lsp.buf.range_formatting, { desc = "Format selection", buffer = bufnr })
        end

        -- Enhanced document highlighting
        if client.server_capabilities.documentHighlightProvider then
            vim.api.nvim_create_augroup("lsp_document_highlight", { clear = true })
            vim.api.nvim_create_autocmd("CursorHold", {
                callback = vim.lsp.buf.document_highlight,
                buffer = bufnr,
                group = "lsp_document_highlight",
            })
            vim.api.nvim_create_autocmd("CursorMoved", {
                callback = vim.lsp.buf.clear_references,
                buffer = bufnr,
                group = "lsp_document_highlight",
            })
        end

        -- Enhanced diagnostic display
        vim.api.nvim_create_autocmd("CursorHold", {
            buffer = bufnr,
            callback = function()
                local opts = {
                    focusable = false,
                    close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
                    border = 'rounded',
                    source = 'always',
                    prefix = ' ',
                    scope = 'cursor',
                    max_width = 80,
                    max_height = 20,
                }
                vim.diagnostic.open_float(nil, opts)
            end
        })

        -- Auto-format on save (optional - can be disabled)
        if client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd("BufWritePre", {
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format({ async = false })
                end,
            })
        end

        -- Show LSP status in statusline
        vim.api.nvim_create_autocmd("User", {
            pattern = "LspProgressUpdate",
            callback = function()
                vim.cmd("redrawstatus")
            end,
        })
    end

    -- Lua LSP setup
    local lua_ls_available, lua_ls = pcall(require, "lua_ls")
    if lua_ls_available then
        require("lua_ls").setup({
            on_attach = on_attach,
            capabilities = capabilities,
            handlers = handlers,
            settings = {
                Lua = {
                    runtime = {
                        version = 'LuaJIT',
                        path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        globals = { 'vim' },
                    },
                    workspace = {
                        library = {
                            [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                            [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                        },
                    },
                    telemetry = {
                        enable = false,
                    },
                },
            },
        })
    end

    -- TypeScript/JavaScript LSP setup
    local tsserver_available = pcall(vim.lsp.start_client, {
        name = 'typescript-language-server',
        cmd = { 'typescript-language-server', '--stdio' },
        filetypes = { 'typescript', 'typescriptreact', 'javascript', 'javascriptreact' },
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        settings = {
            typescript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                },
                format = {
                    indentSize = 2,
                    tabSize = 2,
                    convertTabsToSpaces = true,
                },
            },
            javascript = {
                inlayHints = {
                    includeInlayParameterNameHints = 'all',
                    includeInlayParameterNameHintsWhenArgumentMatchesName = false,
                    includeInlayFunctionParameterTypeHints = true,
                    includeInlayVariableTypeHints = true,
                    includeInlayPropertyDeclarationTypeHints = true,
                    includeInlayFunctionLikeReturnTypeHints = true,
                    includeInlayEnumMemberValueHints = true,
                },
                suggest = {
                    completeFunctionCalls = true,
                },
                format = {
                    indentSize = 2,
                    tabSize = 2,
                    convertTabsToSpaces = true,
                },
            },
        },
    })

    -- Go LSP setup (gopls)
    local gopls_available = pcall(vim.lsp.start_client, {
        name = 'gopls',
        cmd = { 'gopls' },
        filetypes = { 'go', 'gomod', 'gosum', 'gotmpl', 'gohtmltmpl', 'gotexttmpl' },
        on_attach = on_attach,
        capabilities = capabilities,
        handlers = handlers,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                    shadow = true,
                    nilness = true,
                    unusedwrite = true,
                    useany = true,
                },
                staticcheck = true,
                gofumpt = true,
                usePlaceholders = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    compositeLiteralTypes = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
                codelenses = {
                    gc_details = false,
                    regenerate_cgo = true,
                    run_govulncheck = true,
                    test = true,
                    tidy = true,
                    upgrade_dependency = true,
                    vendor = true,
                },
                semanticTokens = true,
                matcher = 'fuzzy',
                symbolMatcher = 'fuzzy',
                symbolStyle = 'full',
                completeUnimported = true,
                deepCompletion = true,
                experimentalPostfixCompletions = true,
                directoryFilters = { '-**/node_modules', '-**/vendor' },
                buildFlags = { '-tags=all' },
            },
        },
    })

    -- Fallback for when LSP servers are not available
    if not lua_ls_available and not tsserver_available and not gopls_available then
        vim.schedule(function()
            print("LSP servers not found. Install them for better development experience:")
            print("- Lua: install lua-language-server")
            print("- TypeScript: install typescript-language-server")
            print("- Go: install gopls")
        end)
    end
end

-- Auto-start LSP when entering supported file types
vim.api.nvim_create_autocmd("FileType", {
    pattern = { "lua", "typescript", "typescriptreact", "javascript", "javascriptreact", "go", "gomod", "gosum", "gotmpl", "gohtmltmpl", "gotexttmpl" },
    callback = function()
        vim.schedule(setup)
    end,
})

-- Export setup function for lazy loading
return {
    setup = setup
} 
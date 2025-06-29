-- =============================================================================
-- Core Keymaps
-- =============================================================================

-- NOTE: Only core/editor keymaps should be defined here.
--       Plugin-specific keymaps should be placed in the relevant plugin config file under nvim/lua/plugins/.

local map = vim.keymap.set

-- =============================================================================
-- BASIC KEYMAPS
-- =============================================================================

-- Better window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Navigate to left window" })
map("n", "<C-l>", "<C-w>l", { desc = "Navigate to right window" })
map("n", "<C-j>", "<C-w>j", { desc = "Navigate to window below" })
map("n", "<C-k>", "<C-w>k", { desc = "Navigate to window above" })

-- Resize windows
map("n", "<C-Up>", "<C-w>+", { desc = "Increase window height" })
map("n", "<C-Down>", "<C-w>-", { desc = "Decrease window height" })
map("n", "<C-Left>", "<C-w><", { desc = "Decrease window width" })
map("n", "<C-Right>", "<C-w>>", { desc = "Increase window width" })

-- File operations
map("n", "<leader>w", ":w<CR>", { desc = "Save current file" })
map("n", "<leader>W", ":wa<CR>", { desc = "Save all open files" })
map("n", "<leader>q", ":q<CR>", { desc = "Close current window" })
map("n", "<leader>Q", ":qa<CR>", { desc = "Close all windows and quit" })
map("n", "<leader>wq", ":wq<CR>", { desc = "Save current file and close window" })

-- Insert mode shortcuts
map("i", "jk", "<ESC>", { desc = "Exit insert mode quickly" })
map("i", "jj", "<ESC>", { desc = "Exit insert mode quickly" })

-- Better search
map("n", "<Esc>", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })
map("n", "n", "nzzzv", { desc = "Go to next search result (centered)" })
map("n", "N", "Nzzzv", { desc = "Go to previous search result (centered)" })
map("n", "*", "*zzzv", { desc = "Search for word under cursor (centered)" })
map("n", "#", "#zzzv", { desc = "Search for word under cursor backwards (centered)" })

-- Buffer management
map("n", "<S-l>", ":bn<CR>", { desc = "Switch to next buffer", silent = true })
map("n", "<S-h>", ":bp<CR>", { desc = "Switch to previous buffer", silent = true })
map("n", "<leader>bl", ":ls<CR>", { desc = "List all buffers", silent = true })
map("n", "<leader>c", function()
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local current_buf = vim.api.nvim_get_current_buf()

    if #buffers <= 1 then
        vim.cmd(":Ex") -- Open explorer if last buffer
    else
        vim.cmd("bdelete " .. current_buf)
    end
end, { desc = "Close current buffer (or open explorer if last)", silent = true })

-- File explorer
map("n", "<leader>e", ":Ex<CR>", { desc = "Open file explorer in current window", silent = true })
map("n", "<leader>v", ":Vex<CR>", { desc = "Open file explorer in vertical split", silent = true })
map("n", "<leader>s", ":Sex<CR>", { desc = "Open file explorer in horizontal split", silent = true })

-- Quickfix and location list
map("n", "<leader>xo", ":copen<CR>", { desc = "Open quickfix list", silent = true })
map("n", "<leader>xc", ":cclose<CR>", { desc = "Close quickfix list", silent = true })
map("n", "<leader>xn", ":cnext<CR>", { desc = "Go to next quickfix item", silent = true })
map("n", "<leader>xp", ":cprev<CR>", { desc = "Go to previous quickfix item", silent = true })

-- Text manipulation
map("n", "<leader>ao", "o<ESC>k", { desc = "Add empty line below current line", silent = true })
map("n", "<leader>aO", "O<ESC>j", { desc = "Add empty line above current line", silent = true })
map("n", "J", "mzJ`z", { desc = "Join current line with next line (preserve cursor)" })
map("n", "<leader>y", '"+y', { desc = "Yank current line to system clipboard" })
map("v", "<leader>y", '"+y', { desc = "Yank selected text to system clipboard" })
map("n", "<leader>Y", 'gg"+yG', { desc = "Yank entire file content to system clipboard" })

-- Terminal
map("n", "<leader>tt", ":term<CR>i", { desc = "Open terminal in current window" })
map("n", "<leader>tj", ":20split | term<CR>i", { desc = "Open terminal in horizontal split (20% height)" })
map("n", "<leader>tl", ":60vsplit | term<CR>i", { desc = "Open terminal in vertical split (60% width)" })
map("n", "<C-/>", ":60vsplit | term<CR>i", { desc = "Open terminal in vertical split (60% width)" })
map("t", "<ESC>", "<C-\\><C-n>", { desc = "Exit terminal mode and return to normal mode" })

-- File finding
map("n", "<leader>ff", ":e ", { desc = "Open file by name (prompt for filename)" })
map("n", "<leader>fb", ":b ", { desc = "Switch to buffer by name (prompt for buffer)" })
map("n", "<leader>fg", ":vimgrep ", { desc = "Search for text pattern in files (prompt for pattern)" })

-- Utility
map("n", "<leader>so", ":source ~/.config/nvim/init.lua<CR>", { desc = "Reload Neovim configuration" })
map("n", "<leader>sv", ":source $MYVIMRC<CR>", { desc = "Reload vimrc file" })

-- Additional popular framework conventions
map("n", "<leader>h", ":nohlsearch<CR>", { desc = "Clear search highlighting", silent = true })
map("n", "<leader>u", ":undo<CR>", { desc = "Undo last change" })
map("n", "<leader>r", ":redo<CR>", { desc = "Redo last undone change" })
map("n", "<leader>z", "u", { desc = "Undo last change" })
map("n", "<leader>Z", "<C-r>", { desc = "Redo last undone change" })

-- Window management (popular framework conventions)
map("n", "<leader>wv", ":vsplit<CR>", { desc = "Split window vertically" })
map("n", "<leader>ws", ":split<CR>", { desc = "Split window horizontally" })
map("n", "<leader>wc", ":close<CR>", { desc = "Close current window" })
map("n", "<leader>wo", ":only<CR>", { desc = "Close all other windows" })

-- Tab management (popular framework conventions)
map("n", "<leader>tn", ":tabnew<CR>", { desc = "Create new tab" })
map("n", "<leader>tc", ":tabclose<CR>", { desc = "Close current tab" })
map("n", "<leader>tl", ":tabnext<CR>", { desc = "Go to next tab" })
map("n", "<leader>th", ":tabprev<CR>", { desc = "Go to previous tab" })
map("n", "<leader>t1", "1gt", { desc = "Go to tab 1" })
map("n", "<leader>t2", "2gt", { desc = "Go to tab 2" })
map("n", "<leader>t3", "3gt", { desc = "Go to tab 3" })
map("n", "<leader>t4", "4gt", { desc = "Go to tab 4" })
map("n", "<leader>t5", "5gt", { desc = "Go to tab 5" })

-- =============================================================================
-- ENHANCED KEYMAPS
-- =============================================================================

-- Enhanced search and replace
local function setup_enhanced_search()
    -- Visual search (search for selected text)
    map("v", "*", "y/\\V<C-r>=escape(@\",'\\/.*$^~[]')<CR><CR>", { desc = "Search for selected text" })
    map("v", "#", "y?\\V<C-r>=escape(@\",'\\/.*$^~[]')<CR><CR>", { desc = "Search for selected text backwards" })
    
    -- Replace word under cursor
    map("n", "<leader>rw", ":%s/\\<<C-r><C-w>\\>/", { desc = "Replace word under cursor" })
    map("n", "<leader>rW", ":%s/\\<<C-r><C-w>\\>/<C-r><C-w>/g", { desc = "Replace word under cursor globally" })
end

-- Enhanced window management
local function setup_enhanced_windows()
    -- Equalize window sizes
    map("n", "<leader>=", "<C-w>=", { desc = "Equalize window sizes" })
    
    -- Maximize current window
    map("n", "<leader>m", "<C-w>_<C-w>|", { desc = "Maximize current window" })
    
    -- Rotate windows
    map("n", "<leader>wr", "<C-w>r", { desc = "Rotate windows" })
    map("n", "<leader>wR", "<C-w>R", { desc = "Rotate windows backwards" })
end

-- Enhanced navigation
local function setup_enhanced_navigation()
    -- Move by display lines (respecting line wrapping)
    map("n", "j", "gj", { desc = "Move down (display line)" })
    map("n", "k", "gk", { desc = "Move up (display line)" })
    map("v", "j", "gj", { desc = "Move down (display line)" })
    map("v", "k", "gk", { desc = "Move up (display line)" })
    
    -- Center screen on search results
    map("n", "n", "nzz", { desc = "Next search result (centered)" })
    map("n", "N", "Nzz", { desc = "Previous search result (centered)" })
    
    -- Jump to last change
    map("n", "g;", "g;zz", { desc = "Jump to last change (centered)" })
    map("n", "g,", "g,zz", { desc = "Jump to next change (centered)" })
end

-- Enhanced editing
local function setup_enhanced_editing()
    -- Move lines up and down
    map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
    map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
    map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
    map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

    -- Duplicate lines
    map("n", "<leader>dl", "yyp", { desc = "Duplicate current line" })
    map("v", "<leader>dl", "y`>p", { desc = "Duplicate selected lines" })
    
    -- Toggle case
    map("n", "<leader>~", "~", { desc = "Toggle case of character under cursor" })
    map("v", "<leader>~", "~", { desc = "Toggle case of selected text" })
    
    -- Sort lines
    map("v", "<leader>s", ":sort<CR>", { desc = "Sort selected lines" })
    map("v", "<leader>S", ":sort!<CR>", { desc = "Sort selected lines (reverse)" })
end

-- Smart buffer switching
local function setup_buffer_switching()
    -- Remember last buffer for better switching
    local last_buffer = nil
    
    vim.api.nvim_create_autocmd("BufLeave", {
        pattern = "*",
        callback = function()
            last_buffer = vim.api.nvim_get_current_buf()
        end,
    })
    
    -- Add keymap to switch to last buffer
    map("n", "<leader><leader>", function()
        if last_buffer and vim.api.nvim_buf_is_valid(last_buffer) then
            vim.api.nvim_set_current_buf(last_buffer)
        end
    end, { desc = "Switch to last buffer" })
end

-- Initialize enhanced features
vim.schedule(function()
    setup_enhanced_search()
    setup_enhanced_windows()
    setup_enhanced_navigation()
    setup_enhanced_editing()
    setup_buffer_switching()
end) 
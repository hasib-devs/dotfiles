-- =============================================================================
-- Advanced Text Manipulation Feature
-- =============================================================================

local map = vim.keymap.set
local api = vim.api
local fn = vim.fn

-- =============================================================================
-- MULTIPLE CURSORS
-- =============================================================================

-- Store multiple cursor positions
local cursors = {}

-- Add cursor at current position
local function add_cursor()
    local pos = api.nvim_win_get_cursor(0)
    table.insert(cursors, pos)
    vim.notify("Cursor " .. #cursors .. " added at line " .. pos[1], vim.log.levels.INFO)
end

-- Remove last cursor
local function remove_cursor()
    if #cursors > 0 then
        table.remove(cursors)
        vim.notify("Cursor " .. (#cursors + 1) .. " removed", vim.log.levels.INFO)
    end
end

-- Clear all cursors
local function clear_cursors()
    cursors = {}
    vim.notify("All cursors cleared", vim.log.levels.INFO)
end

-- Jump to next cursor
local function next_cursor()
    if #cursors == 0 then
        vim.notify("No cursors set", vim.log.levels.WARN)
        return
    end
    
    local current_pos = api.nvim_win_get_cursor(0)
    local next_cursor_index = 1
    
    -- Find next cursor
    for i, cursor in ipairs(cursors) do
        if cursor[1] > current_pos[1] or (cursor[1] == current_pos[1] and cursor[2] > current_pos[2]) then
            next_cursor_index = i
            break
        end
    end
    
    api.nvim_win_set_cursor(0, cursors[next_cursor_index])
end

-- Jump to previous cursor
local function prev_cursor()
    if #cursors == 0 then
        vim.notify("No cursors set", vim.log.levels.WARN)
        return
    end
    
    local current_pos = api.nvim_win_get_cursor(0)
    local prev_cursor_index = #cursors
    
    -- Find previous cursor
    for i = #cursors, 1, -1 do
        local cursor = cursors[i]
        if cursor[1] < current_pos[1] or (cursor[1] == current_pos[1] and cursor[2] < current_pos[2]) then
            prev_cursor_index = i
            break
        end
    end
    
    api.nvim_win_set_cursor(0, cursors[prev_cursor_index])
end

-- =============================================================================
-- ENHANCED TEXT OBJECTS
-- =============================================================================

-- Select function/block
local function select_function()
    local start_pos = api.nvim_win_get_cursor(0)
    
    -- Try to find function boundaries
    local function_patterns = {
        "function%s+%w+%s*%(",
        "def%s+%w+%s*%(",
        "func%s+%w+%s*%(",
        "const%s+%w+%s*=",
        "let%s+%w+%s*=",
        "var%s+%w+%s*="
    }
    
    local found = false
    for _, pattern in ipairs(function_patterns) do
        local line = api.nvim_get_current_line()
        if line:match(pattern) then
            found = true
            break
        end
    end
    
    if found then
        -- Select from current line to matching end
        vim.cmd("normal! V")
        vim.cmd("normal! %")
    else
        vim.notify("No function found at cursor", vim.log.levels.WARN)
    end
end

-- Select parameter list
local function select_parameters()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    
    -- Find opening parenthesis
    local open_paren = line:find("%(", col)
    if not open_paren then
        vim.notify("No parameter list found", vim.log.levels.WARN)
        return
    end
    
    -- Find closing parenthesis
    local close_paren = line:find("%)", open_paren)
    if not close_paren then
        vim.notify("No closing parenthesis found", vim.log.levels.WARN)
        return
    end
    
    -- Select the parameter list
    api.nvim_win_set_cursor(0, {api.nvim_win_get_cursor(0)[1], open_paren})
    vim.cmd("normal! v")
    api.nvim_win_set_cursor(0, {api.nvim_win_get_cursor(0)[1], close_paren})
end

-- Select string content
local function select_string()
    local line = api.nvim_get_current_line()
    local col = api.nvim_win_get_cursor(0)[2]
    
    -- Find string delimiters
    local string_patterns = {
        {['"'] = '"'},
        {["'"] = "'"},
        {["`"] = "`"}
    }
    
    for _, pattern in pairs(string_patterns) do
        for open_char, close_char in pairs(pattern) do
            local open_pos = line:find(open_char, col)
            if open_pos then
                local close_pos = line:find(close_char, open_pos + 1)
                if close_pos then
                    api.nvim_win_set_cursor(0, {api.nvim_win_get_cursor(0)[1], open_pos})
                    vim.cmd("normal! v")
                    api.nvim_win_set_cursor(0, {api.nvim_win_get_cursor(0)[1], close_pos})
                    return
                end
            end
        end
    end
    
    vim.notify("No string found at cursor", vim.log.levels.WARN)
end

-- =============================================================================
-- MACRO MANAGEMENT
-- =============================================================================

-- Store macros
local macros = {}

-- Record macro to register
local function record_macro()
    local register = vim.fn.input("Record macro to register: ")
    if register == "" then
        register = "q"
    end
    
    vim.cmd("normal! q" .. register)
    vim.notify("Recording macro to register '" .. register .. "'", vim.log.levels.INFO)
end

-- Play macro from register
local function play_macro()
    local register = vim.fn.input("Play macro from register: ")
    if register == "" then
        register = "q"
    end
    
    vim.cmd("normal! @" .. register)
    vim.notify("Played macro from register '" .. register .. "'", vim.log.levels.INFO)
end

-- Save macro to named slot
local function save_macro()
    local name = vim.fn.input("Macro name: ")
    if name == "" then
        vim.notify("Macro name required", vim.log.levels.WARN)
        return
    end
    
    local register = vim.fn.input("Register to save: ")
    if register == "" then
        register = "q"
    end
    
    macros[name] = register
    vim.notify("Macro '" .. name .. "' saved from register '" .. register .. "'", vim.log.levels.INFO)
end

-- Play saved macro
local function play_saved_macro()
    local name = vim.fn.input("Macro name: ")
    if name == "" then
        vim.notify("Macro name required", vim.log.levels.WARN)
        return
    end
    
    if macros[name] then
        vim.cmd("normal! @" .. macros[name])
        vim.notify("Played saved macro '" .. name .. "'", vim.log.levels.INFO)
    else
        vim.notify("Macro '" .. name .. "' not found", vim.log.levels.WARN)
    end
end

-- List saved macros
local function list_macros()
    if next(macros) == nil then
        vim.notify("No saved macros", vim.log.levels.INFO)
        return
    end
    
    local macro_list = {}
    for name, register in pairs(macros) do
        table.insert(macro_list, {
            filename = "macro://" .. name,
            text = name .. " -> register '" .. register .. "'",
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(macro_list)
    vim.cmd("copen")
end

-- =============================================================================
-- CODE FOLDING
-- =============================================================================

-- Toggle fold at current line
local function toggle_fold()
    vim.cmd("normal! za")
end

-- Open all folds
local function open_all_folds()
    vim.cmd("normal! zR")
end

-- Close all folds
local function close_all_folds()
    vim.cmd("normal! zM")
end

-- Open fold at current line
local function open_fold()
    vim.cmd("normal! zo")
end

-- Close fold at current line
local function close_fold()
    vim.cmd("normal! zc")
end

-- Fold by syntax
local function fold_by_syntax()
    vim.cmd("set foldmethod=syntax")
    vim.cmd("normal! zM")
    vim.notify("Folded by syntax", vim.log.levels.INFO)
end

-- Fold by indent
local function fold_by_indent()
    vim.cmd("set foldmethod=indent")
    vim.cmd("normal! zM")
    vim.notify("Folded by indent", vim.log.levels.INFO)
end

-- =============================================================================
-- TEXT TRANSFORMATIONS
-- =============================================================================

-- Toggle case of word under cursor
local function toggle_case()
    vim.cmd("normal! ~")
end

-- Convert to uppercase
local function to_uppercase()
    vim.cmd("normal! gU")
end

-- Convert to lowercase
local function to_lowercase()
    vim.cmd("normal! gu")
end

-- Capitalize first letter
local function capitalize()
    vim.cmd("normal! gUl")
end

-- Convert to title case
local function to_title_case()
    vim.cmd("normal! gUl")
    vim.cmd("normal! guw")
end

-- Reverse characters
local function reverse_chars()
    vim.cmd("normal! g?")
end

-- Sort lines
local function sort_lines()
    vim.cmd("sort")
end

-- Sort lines reverse
local function sort_lines_reverse()
    vim.cmd("sort!")
end

-- Remove duplicate lines
local function remove_duplicates()
    vim.cmd("sort u")
end

-- =============================================================================
-- COMMENT MANAGEMENT
-- =============================================================================

-- Toggle comment for current line
local function toggle_comment()
    local filetype = vim.bo.filetype
    local comment_chars = {
        lua = "--",
        python = "#",
        javascript = "//",
        typescript = "//",
        go = "//",
        rust = "//",
        c = "//",
        cpp = "//",
        java = "//",
        php = "//",
        html = "<!--",
        css = "/*",
        scss = "/*",
        sql = "--",
        sh = "#",
        vim = "\"",
        yaml = "#",
        json = "//",
        markdown = "<!--"
    }
    
    local comment_char = comment_chars[filetype] or "//"
    local line = api.nvim_get_current_line()
    
    if line:match("^%s*" .. vim.fn.escape(comment_char, "%-")) then
        -- Uncomment
        vim.cmd("normal! ^")
        vim.cmd("normal! " .. #comment_char .. "x")
    else
        -- Comment
        vim.cmd("normal! ^")
        vim.cmd("normal! i" .. comment_char .. " ")
    end
end

-- Comment selected lines
local function comment_selection()
    local filetype = vim.bo.filetype
    local comment_chars = {
        lua = "--",
        python = "#",
        javascript = "//",
        typescript = "//",
        go = "//",
        rust = "//",
        c = "//",
        cpp = "//",
        java = "//",
        php = "//",
        html = "<!--",
        css = "/*",
        scss = "/*",
        sql = "--",
        sh = "#",
        vim = "\"",
        yaml = "#",
        json = "//",
        markdown = "<!--"
    }
    
    local comment_char = comment_chars[filetype] or "//"
    vim.cmd("normal! :'<,'>s/^/" .. vim.fn.escape(comment_char, "%-") .. " /")
end

-- Uncomment selected lines
local function uncomment_selection()
    local filetype = vim.bo.filetype
    local comment_chars = {
        lua = "--",
        python = "#",
        javascript = "//",
        typescript = "//",
        go = "//",
        rust = "//",
        c = "//",
        cpp = "//",
        java = "//",
        php = "//",
        html = "<!--",
        css = "/*",
        scss = "/*",
        sql = "--",
        sh = "#",
        vim = "\"",
        yaml = "#",
        json = "//",
        markdown = "<!--"
    }
    
    local comment_char = comment_chars[filetype] or "//"
    vim.cmd("normal! :'<,'>s/^%s*" .. vim.fn.escape(comment_char, "%-") .. "%s*//")
end

-- =============================================================================
-- ENHANCED EDITING
-- =============================================================================

-- Duplicate current line
local function duplicate_line()
    vim.cmd("normal! yyp")
end

-- Duplicate selected lines
local function duplicate_selection()
    vim.cmd("normal! y`>p")
end

-- Move line up
local function move_line_up()
    vim.cmd("normal! :m .-2<CR>")
end

-- Move line down
local function move_line_down()
    vim.cmd("normal! :m .+1<CR>")
end

-- Move selection up
local function move_selection_up()
    vim.cmd("normal! :'<,'>m '<-2<CR>gv")
end

-- Move selection down
local function move_selection_down()
    vim.cmd("normal! :'<,'>m '>+1<CR>gv")
end

-- Join lines
local function join_lines()
    vim.cmd("normal! J")
end

-- Split line at cursor
local function split_line()
    vim.cmd("normal! i<CR><ESC>")
end

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local function setup_keymaps()
    -- Multiple cursors
    map("n", "<leader>ma", add_cursor, { desc = "Add cursor" })
    map("n", "<leader>mr", remove_cursor, { desc = "Remove cursor" })
    map("n", "<leader>mc", clear_cursors, { desc = "Clear cursors" })
    map("n", "<leader>mn", next_cursor, { desc = "Next cursor" })
    map("n", "<leader>mp", prev_cursor, { desc = "Previous cursor" })
    
    -- Enhanced text objects
    map("n", "<leader>tf", select_function, { desc = "Select function" })
    map("n", "<leader>tp", select_parameters, { desc = "Select parameters" })
    map("n", "<leader>ts", select_string, { desc = "Select string" })
    
    -- Macro management
    map("n", "<leader>mr", record_macro, { desc = "Record macro" })
    map("n", "<leader>mp", play_macro, { desc = "Play macro" })
    map("n", "<leader>ms", save_macro, { desc = "Save macro" })
    map("n", "<leader>mP", play_saved_macro, { desc = "Play saved macro" })
    map("n", "<leader>ml", list_macros, { desc = "List macros" })
    
    -- Code folding
    map("n", "<leader>ft", toggle_fold, { desc = "Toggle fold" })
    map("n", "<leader>fo", open_all_folds, { desc = "Open all folds" })
    map("n", "<leader>fc", close_all_folds, { desc = "Close all folds" })
    map("n", "<leader>fO", open_fold, { desc = "Open fold" })
    map("n", "<leader>fC", close_fold, { desc = "Close fold" })
    map("n", "<leader>fs", fold_by_syntax, { desc = "Fold by syntax" })
    map("n", "<leader>fi", fold_by_indent, { desc = "Fold by indent" })
    
    -- Text transformations
    map("n", "<leader>tt", toggle_case, { desc = "Toggle case" })
    map("n", "<leader>tu", to_uppercase, { desc = "To uppercase" })
    map("n", "<leader>tl", to_lowercase, { desc = "To lowercase" })
    map("n", "<leader>tc", capitalize, { desc = "Capitalize" })
    map("n", "<leader>tT", to_title_case, { desc = "To title case" })
    map("n", "<leader>tr", reverse_chars, { desc = "Reverse characters" })
    map("n", "<leader>ts", sort_lines, { desc = "Sort lines" })
    map("n", "<leader>tS", sort_lines_reverse, { desc = "Sort lines reverse" })
    map("n", "<leader>td", remove_duplicates, { desc = "Remove duplicates" })
    
    -- Comment management
    map("n", "<leader>cc", toggle_comment, { desc = "Toggle comment" })
    map("v", "<leader>cc", comment_selection, { desc = "Comment selection" })
    map("v", "<leader>cu", uncomment_selection, { desc = "Uncomment selection" })
    
    -- Enhanced editing
    map("n", "<leader>dl", duplicate_line, { desc = "Duplicate line" })
    map("v", "<leader>dl", duplicate_selection, { desc = "Duplicate selection" })
    map("n", "<leader>mu", move_line_up, { desc = "Move line up" })
    map("n", "<leader>md", move_line_down, { desc = "Move line down" })
    map("v", "<leader>mu", move_selection_up, { desc = "Move selection up" })
    map("v", "<leader>md", move_selection_down, { desc = "Move selection down" })
    map("n", "<leader>jj", join_lines, { desc = "Join lines" })
    map("n", "<leader>ss", split_line, { desc = "Split line" })
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

local function setup()
    setup_keymaps()
    
    vim.schedule(function()
        print("✏️ Advanced Text Manipulation loaded!")
        print("🎯 Use <leader>ma for multiple cursors")
        print("📝 Use <leader>cc for comment toggle")
        print("🔄 Use <leader>mr for macro recording")
        print("📁 Use <leader>ft for code folding")
        print("🔄 Use <leader>tt for text transformations")
    end)
end

return { setup = setup } 
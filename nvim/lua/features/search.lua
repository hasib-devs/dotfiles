-- =============================================================================
-- Advanced Search & Navigation Feature
-- =============================================================================

local map = vim.keymap.set
local api = vim.api
local fn = vim.fn

-- =============================================================================
-- FUZZY FILE FINDER
-- =============================================================================

local function fuzzy_find_files()
    local pattern = vim.fn.input("Find files (pattern): ")
    if pattern == "" then return end
    
    local cwd = vim.fn.getcwd()
    local cmd = string.format("find %s -type f -name '*%s*' -not -path '*/node_modules/*' -not -path '*/\\.git/*' | head -50", cwd, pattern)
    local result = vim.fn.system(cmd)
    
    if result == "" then
        vim.notify("No files found", vim.log.levels.INFO)
        return
    end
    
    local files = {}
    for file in result:gmatch("[^\r\n]+") do
        table.insert(files, {
            filename = file,
            text = vim.fn.fnamemodify(file, ":t"),
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(files)
    vim.cmd("copen")
end

-- =============================================================================
-- PROJECT-WIDE SEARCH
-- =============================================================================

local function project_search()
    local pattern = vim.fn.input("Search pattern: ")
    if pattern == "" then return end
    
    local cwd = vim.fn.getcwd()
    vim.cmd("vimgrep /" .. pattern .. "/j " .. cwd .. "/**/*")
    vim.cmd("copen")
end

-- =============================================================================
-- RECENT FILES
-- =============================================================================

vim.g.recent_files = vim.g.recent_files or {}

local function add_to_recent_files()
    local current_file = vim.fn.expand("%:p")
    if current_file == "" or current_file == "[No Name]" then return end
    
    for i, file in ipairs(vim.g.recent_files) do
        if file == current_file then
            table.remove(vim.g.recent_files, i)
            break
        end
    end
    
    table.insert(vim.g.recent_files, 1, current_file)
    if #vim.g.recent_files > 50 then
        table.remove(vim.g.recent_files)
    end
end

local function show_recent_files()
    if #vim.g.recent_files == 0 then
        vim.notify("No recent files", vim.log.levels.INFO)
        return
    end
    
    local files = {}
    for i, file in ipairs(vim.g.recent_files) do
        if vim.fn.filereadable(file) == 1 then
            table.insert(files, {
                filename = file,
                text = string.format("%d: %s", i, vim.fn.fnamemodify(file, ":t")),
                lnum = 1, col = 1
            })
        end
    end
    
    if #files == 0 then
        vim.notify("No recent files found", vim.log.levels.INFO)
        return
    end
    
    vim.fn.setqflist(files)
    vim.cmd("copen")
end

-- =============================================================================
-- BUFFER PICKER
-- =============================================================================

local function show_buffer_picker()
    local buffers = vim.fn.getbufinfo({ buflisted = 1 })
    local files = {}
    
    for _, buf in ipairs(buffers) do
        local name = buf.name ~= "" and buf.name or "[No Name]"
        local modified = buf.changed == 1 and " ●" or ""
        table.insert(files, {
            filename = name,
            text = vim.fn.fnamemodify(name, ":t") .. modified,
            lnum = 1, col = 1, bufnr = buf.bufnr
        })
    end
    
    vim.fn.setqflist(files)
    vim.cmd("copen")
end

-- =============================================================================
-- LINE JUMPING
-- =============================================================================

local function jump_to_line()
    local line = vim.fn.input("Jump to line: ")
    if line == "" then return end
    
    local line_num = tonumber(line)
    if line_num and line_num > 0 then
        vim.cmd("normal! " .. line_num .. "Gzz")
    end
end

-- =============================================================================
-- BOOKMARKS
-- =============================================================================

vim.g.bookmarks = vim.g.bookmarks or {}

local function add_bookmark()
    local current_file = vim.fn.expand("%:p")
    local current_line = vim.fn.line(".")
    local name = vim.fn.input("Bookmark name: ")
    
    if name == "" then
        name = vim.fn.fnamemodify(current_file, ":t") .. ":" .. current_line
    end
    
    vim.g.bookmarks[name] = {
        file = current_file,
        line = current_line,
        text = vim.fn.getline(current_line)
    }
    
    vim.notify("Bookmark added: " .. name, vim.log.levels.INFO)
end

local function show_bookmarks()
    if next(vim.g.bookmarks) == nil then
        vim.notify("No bookmarks", vim.log.levels.INFO)
        return
    end
    
    local files = {}
    for name, bookmark in pairs(vim.g.bookmarks) do
        if vim.fn.filereadable(bookmark.file) == 1 then
            table.insert(files, {
                filename = bookmark.file,
                text = name .. ": " .. bookmark.text,
                lnum = bookmark.line, col = 1
            })
        end
    end
    
    vim.fn.setqflist(files)
    vim.cmd("copen")
end

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local function setup_keymaps()
    map("n", "<leader>ff", fuzzy_find_files, { desc = "Fuzzy find files" })
    map("n", "<leader>fs", project_search, { desc = "Project-wide search" })
    map("n", "<leader>fr", show_recent_files, { desc = "Show recent files" })
    map("n", "<leader>fb", show_buffer_picker, { desc = "Buffer picker" })
    map("n", "<leader>fl", jump_to_line, { desc = "Jump to line" })
    map("n", "<leader>fm", add_bookmark, { desc = "Add bookmark" })
    map("n", "<leader>fM", show_bookmarks, { desc = "Show bookmarks" })
end

-- =============================================================================
-- AUTOCMDS
-- =============================================================================

local function setup_autocmds()
    api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = add_to_recent_files,
    })
    
    api.nvim_create_autocmd("BufNewFile", {
        pattern = "*",
        callback = add_to_recent_files,
    })
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

local function setup()
    setup_keymaps()
    setup_autocmds()
    
    vim.schedule(function()
        print("🔍 Advanced Search & Navigation loaded!")
        print("📁 Use <leader>ff for fuzzy file finding")
        print("🔎 Use <leader>fs for project-wide search")
        print("📋 Use <leader>fr for recent files")
        print("📖 Use <leader>fb for buffer picker")
    end)
end

return { setup = setup } 
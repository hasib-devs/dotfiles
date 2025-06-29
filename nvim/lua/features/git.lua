-- =============================================================================
-- Git Integration Feature
-- =============================================================================

local map = vim.keymap.set
local api = vim.api
local fn = vim.fn

-- =============================================================================
-- UTILITY FUNCTIONS
-- =============================================================================

-- Check if current directory is a git repository
local function is_git_repo()
    return vim.fn.system("git rev-parse --git-dir 2>/dev/null") ~= ""
end

-- Get git root directory
local function get_git_root()
    local result = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
    return vim.fn.trim(result)
end

-- Execute git command and return result
local function git_command(cmd)
    if not is_git_repo() then
        vim.notify("Not a git repository", vim.log.levels.WARN)
        return nil
    end
    
    local result = vim.fn.system("git " .. cmd .. " 2>&1")
    return vim.fn.trim(result)
end

-- =============================================================================
-- GIT BLAME
-- =============================================================================

-- Show git blame for current line
local function git_blame()
    if not is_git_repo() then return end
    
    local current_file = vim.fn.expand("%:p")
    local current_line = vim.fn.line(".")
    local git_root = get_git_root()
    local relative_file = vim.fn.fnamemodify(current_file, ":.")
    
    local cmd = string.format("blame -L %d,%d --porcelain %s", current_line, current_line, relative_file)
    local result = git_command(cmd)
    
    if result and result ~= "" then
        -- Parse blame output
        local lines = {}
        for line in result:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        if #lines > 0 then
            local blame_info = lines[1]
            local hash = blame_info:match("^([%w]+)")
            local author = ""
            local date = ""
            
            for _, line in ipairs(lines) do
                if line:match("^author ") then
                    author = line:sub(8)
                elseif line:match("^author%-time ") then
                    local timestamp = tonumber(line:sub(13))
                    if timestamp then
                        date = os.date("%Y-%m-%d %H:%M", timestamp)
                    end
                end
            end
            
            local message = git_command("log -1 --format=%s " .. hash)
            local display_text = string.format("Commit: %s | Author: %s | Date: %s | %s", 
                hash:sub(1, 8), author, date, message or "")
            
            vim.notify(display_text, vim.log.levels.INFO, {
                title = "Git Blame",
                timeout = 5000
            })
        end
    end
end

-- Show git blame in a floating window
local function git_blame_float()
    if not is_git_repo() then return end
    
    local current_file = vim.fn.expand("%:p")
    local current_line = vim.fn.line(".")
    local relative_file = vim.fn.fnamemodify(current_file, ":.")
    
    local cmd = string.format("blame -L %d,%d --porcelain %s", current_line, current_line, relative_file)
    local result = git_command(cmd)
    
    if result and result ~= "" then
        local lines = {}
        for line in result:gmatch("[^\r\n]+") do
            table.insert(lines, line)
        end
        
        if #lines > 0 then
            local blame_info = lines[1]
            local hash = blame_info:match("^([%w]+)")
            local author = ""
            local date = ""
            
            for _, line in ipairs(lines) do
                if line:match("^author ") then
                    author = line:sub(8)
                elseif line:match("^author%-time ") then
                    local timestamp = tonumber(line:sub(13))
                    if timestamp then
                        date = os.date("%Y-%m-%d %H:%M", timestamp)
                    end
                end
            end
            
            local message = git_command("log -1 --format=%s " .. hash)
            local content = {
                "Git Blame Information",
                "====================",
                "Commit: " .. hash:sub(1, 8),
                "Author: " .. author,
                "Date: " .. date,
                "Message: " .. (message or "No message"),
                "",
                "Press q to close"
            }
            
            -- Create floating window
            local width = 60
            local height = #content
            local row = math.floor((vim.o.lines - height) / 2)
            local col = math.floor((vim.o.columns - width) / 2)
            
            local buf = api.nvim_create_buf(false, true)
            local win = api.nvim_open_win(buf, true, {
                relative = "editor",
                width = width,
                height = height,
                row = row,
                col = col,
                style = "minimal",
                border = "rounded"
            })
            
            api.nvim_buf_set_lines(buf, 0, -1, false, content)
            api.nvim_buf_set_option(buf, "modifiable", false)
            api.nvim_buf_set_option(buf, "filetype", "gitblame")
            
            -- Add keymap to close window
            api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
            api.nvim_buf_set_keymap(buf, "n", "<ESC>", "<cmd>close<CR>", { noremap = true, silent = true })
        end
    end
end

-- =============================================================================
-- GIT STATUS
-- =============================================================================

-- Show git status
local function git_status()
    if not is_git_repo() then return end
    
    local result = git_command("status --porcelain")
    if not result or result == "" then
        vim.notify("Working directory clean", vim.log.levels.INFO)
        return
    end
    
    local files = {}
    for line in result:gmatch("[^\r\n]+") do
        local status = line:sub(1, 2)
        local file = line:sub(4)
        local status_text = ""
        
        if status:match("M") then status_text = "Modified"
        elseif status:match("A") then status_text = "Added"
        elseif status:match("D") then status_text = "Deleted"
        elseif status:match("R") then status_text = "Renamed"
        elseif status:match("C") then status_text = "Copied"
        elseif status:match("U") then status_text = "Unmerged"
        elseif status:match("%?") then status_text = "Untracked"
        end
        
        table.insert(files, {
            filename = file,
            text = status_text .. ": " .. vim.fn.fnamemodify(file, ":t"),
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(files)
    vim.cmd("copen")
end

-- Show git log
local function git_log()
    if not is_git_repo() then return end
    
    local result = git_command("log --oneline -20")
    if not result or result == "" then
        vim.notify("No commits found", vim.log.levels.INFO)
        return
    end
    
    local commits = {}
    for line in result:gmatch("[^\r\n]+") do
        local hash, message = line:match("^([%w]+)%s+(.+)")
        if hash and message then
            table.insert(commits, {
                filename = "git://" .. hash,
                text = hash .. ": " .. message,
                lnum = 1, col = 1
            })
        end
    end
    
    vim.fn.setqflist(commits)
    vim.cmd("copen")
end

-- =============================================================================
-- GIT DIFF
-- =============================================================================

-- Show diff for current file
local function git_diff()
    if not is_git_repo() then return end
    
    local current_file = vim.fn.expand("%:p")
    local relative_file = vim.fn.fnamemodify(current_file, ":.")
    
    local result = git_command("diff " .. relative_file)
    if not result or result == "" then
        vim.notify("No changes in " .. vim.fn.fnamemodify(current_file, ":t"), vim.log.levels.INFO)
        return
    end
    
    -- Create a new buffer with diff content
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded"
    })
    
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_option(buf, "filetype", "diff")
    api.nvim_buf_set_name(buf, "git-diff://" .. relative_file)
    
    -- Add keymap to close window
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, "n", "<ESC>", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Show diff for all files
local function git_diff_all()
    if not is_git_repo() then return end
    
    local result = git_command("diff")
    if not result or result == "" then
        vim.notify("No changes in working directory", vim.log.levels.INFO)
        return
    end
    
    -- Create a new buffer with diff content
    local buf = api.nvim_create_buf(false, true)
    local win = api.nvim_open_win(buf, true, {
        relative = "editor",
        width = math.floor(vim.o.columns * 0.8),
        height = math.floor(vim.o.lines * 0.8),
        row = math.floor(vim.o.lines * 0.1),
        col = math.floor(vim.o.columns * 0.1),
        style = "minimal",
        border = "rounded"
    })
    
    local lines = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(lines, line)
    end
    
    api.nvim_buf_set_lines(buf, 0, -1, false, lines)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_option(buf, "filetype", "diff")
    api.nvim_buf_set_name(buf, "git-diff://all")
    
    -- Add keymap to close window
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
    api.nvim_buf_set_keymap(buf, "n", "<ESC>", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- =============================================================================
-- GIT OPERATIONS
-- =============================================================================

-- Add current file to staging
local function git_add()
    if not is_git_repo() then return end
    
    local current_file = vim.fn.expand("%:p")
    local relative_file = vim.fn.fnamemodify(current_file, ":.")
    
    local result = git_command("add " .. relative_file)
    if result == "" then
        vim.notify("Added " .. vim.fn.fnamemodify(current_file, ":t") .. " to staging", vim.log.levels.INFO)
    else
        vim.notify("Error adding file: " .. result, vim.log.levels.ERROR)
    end
end

-- Add all files to staging
local function git_add_all()
    if not is_git_repo() then return end
    
    local result = git_command("add .")
    if result == "" then
        vim.notify("Added all files to staging", vim.log.levels.INFO)
    else
        vim.notify("Error adding files: " .. result, vim.log.levels.ERROR)
    end
end

-- Commit staged changes
local function git_commit()
    if not is_git_repo() then return end
    
    local message = vim.fn.input("Commit message: ")
    if message == "" then
        vim.notify("Commit cancelled", vim.log.levels.INFO)
        return
    end
    
    local result = git_command("commit -m '" .. message .. "'")
    if result and result:match("^%[") then
        vim.notify("Commit successful", vim.log.levels.INFO)
    else
        vim.notify("Commit failed: " .. (result or "Unknown error"), vim.log.levels.ERROR)
    end
end

-- Push to remote
local function git_push()
    if not is_git_repo() then return end
    
    local result = git_command("push")
    if result == "" then
        vim.notify("Push successful", vim.log.levels.INFO)
    else
        vim.notify("Push failed: " .. result, vim.log.levels.ERROR)
    end
end

-- Pull from remote
local function git_pull()
    if not is_git_repo() then return end
    
    local result = git_command("pull")
    if result and result:match("^Already up to date") then
        vim.notify("Already up to date", vim.log.levels.INFO)
    elseif result then
        vim.notify("Pull successful: " .. result, vim.log.levels.INFO)
    else
        vim.notify("Pull failed", vim.log.levels.ERROR)
    end
end

-- =============================================================================
-- BRANCH MANAGEMENT
-- =============================================================================

-- Show current branch
local function git_branch()
    if not is_git_repo() then return end
    
    local result = git_command("branch --show-current")
    if result and result ~= "" then
        vim.notify("Current branch: " .. result, vim.log.levels.INFO)
    else
        vim.notify("Not on any branch", vim.log.levels.WARN)
    end
end

-- List all branches
local function git_branches()
    if not is_git_repo() then return end
    
    local result = git_command("branch -a")
    if not result or result == "" then
        vim.notify("No branches found", vim.log.levels.INFO)
        return
    end
    
    local branches = {}
    for line in result:gmatch("[^\r\n]+") do
        local branch = vim.fn.trim(line:sub(3)) -- Remove "* " or "  "
        local is_current = line:match("^%*")
        local display_text = (is_current and "● " or "  ") .. branch
        table.insert(branches, {
            filename = "git://branch/" .. branch,
            text = display_text,
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(branches)
    vim.cmd("copen")
end

-- Create and checkout new branch
local function git_checkout_new()
    if not is_git_repo() then return end
    
    local branch_name = vim.fn.input("New branch name: ")
    if branch_name == "" then
        vim.notify("Branch creation cancelled", vim.log.levels.INFO)
        return
    end
    
    local result = git_command("checkout -b " .. branch_name)
    if result and result:match("^Switched to a new branch") then
        vim.notify("Created and switched to branch: " .. branch_name, vim.log.levels.INFO)
    else
        vim.notify("Branch creation failed: " .. (result or "Unknown error"), vim.log.levels.ERROR)
    end
end

-- Checkout existing branch
local function git_checkout()
    if not is_git_repo() then return end
    
    local branch_name = vim.fn.input("Branch name: ")
    if branch_name == "" then
        vim.notify("Checkout cancelled", vim.log.levels.INFO)
        return
    end
    
    local result = git_command("checkout " .. branch_name)
    if result and result:match("^Switched to branch") then
        vim.notify("Switched to branch: " .. branch_name, vim.log.levels.INFO)
    else
        vim.notify("Checkout failed: " .. (result or "Unknown error"), vim.log.levels.ERROR)
    end
end

-- =============================================================================
-- STASH OPERATIONS
-- =============================================================================

-- Stash current changes
local function git_stash()
    if not is_git_repo() then return end
    
    local message = vim.fn.input("Stash message (optional): ")
    local cmd = "stash"
    if message ~= "" then
        cmd = cmd .. " push -m '" .. message .. "'"
    end
    
    local result = git_command(cmd)
    if result and result:match("^Saved working directory") then
        vim.notify("Changes stashed", vim.log.levels.INFO)
    else
        vim.notify("Stash failed: " .. (result or "Unknown error"), vim.log.levels.ERROR)
    end
end

-- List stashes
local function git_stash_list()
    if not is_git_repo() then return end
    
    local result = git_command("stash list")
    if not result or result == "" then
        vim.notify("No stashes found", vim.log.levels.INFO)
        return
    end
    
    local stashes = {}
    for line in result:gmatch("[^\r\n]+") do
        table.insert(stashes, {
            filename = "git://stash/" .. line,
            text = line,
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(stashes)
    vim.cmd("copen")
end

-- Pop latest stash
local function git_stash_pop()
    if not is_git_repo() then return end
    
    local result = git_command("stash pop")
    if result and result:match("^Dropped refs/stash") then
        vim.notify("Stash applied and dropped", vim.log.levels.INFO)
    else
        vim.notify("Stash pop failed: " .. (result or "Unknown error"), vim.log.levels.ERROR)
    end
end

-- =============================================================================
-- KEYMAPS
-- =============================================================================

local function setup_keymaps()
    -- Git blame
    map("n", "<leader>gb", git_blame, { desc = "Git blame current line" })
    map("n", "<leader>gB", git_blame_float, { desc = "Git blame in float window" })
    
    -- Git status and log
    map("n", "<leader>gs", git_status, { desc = "Git status" })
    map("n", "<leader>gl", git_log, { desc = "Git log" })
    
    -- Git diff
    map("n", "<leader>gd", git_diff, { desc = "Git diff current file" })
    map("n", "<leader>gD", git_diff_all, { desc = "Git diff all files" })
    
    -- Git operations
    map("n", "<leader>ga", git_add, { desc = "Git add current file" })
    map("n", "<leader>gA", git_add_all, { desc = "Git add all files" })
    map("n", "<leader>gc", git_commit, { desc = "Git commit" })
    map("n", "<leader>gp", git_push, { desc = "Git push" })
    map("n", "<leader>gP", git_pull, { desc = "Git pull" })
    
    -- Branch management
    map("n", "<leader>gb", git_branch, { desc = "Show current branch" })
    map("n", "<leader>gB", git_branches, { desc = "List all branches" })
    map("n", "<leader>gn", git_checkout_new, { desc = "Create and checkout new branch" })
    map("n", "<leader>go", git_checkout, { desc = "Checkout branch" })
    
    -- Stash operations
    map("n", "<leader>gt", git_stash, { desc = "Git stash" })
    map("n", "<leader>gT", git_stash_list, { desc = "Git stash list" })
    map("n", "<leader>gS", git_stash_pop, { desc = "Git stash pop" })
end

-- =============================================================================
-- SETUP FUNCTION
-- =============================================================================

local function setup()
    setup_keymaps()
    
    vim.schedule(function()
        print("🔧 Git Integration loaded!")
        print("📝 Use <leader>gb for git blame")
        print("📊 Use <leader>gs for git status")
        print("🔍 Use <leader>gd for git diff")
        print("💾 Use <leader>gc for git commit")
        print("🚀 Use <leader>gp for git push")
    end)
end

return { setup = setup } 
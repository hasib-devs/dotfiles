-- Project Management Feature
local map = vim.keymap.set
local api = vim.api

-- Project types detection
local project_types = {
    nodejs = { patterns = {"package.json", "node_modules/"}, name = "Node.js" },
    python = { patterns = {"requirements.txt", "pyproject.toml"}, name = "Python" },
    go = { patterns = {"go.mod", "go.sum"}, name = "Go" },
    rust = { patterns = {"Cargo.toml", "Cargo.lock"}, name = "Rust" },
    docker = { patterns = {"Dockerfile", "docker-compose.yml"}, name = "Docker" },
    terraform = { patterns = {"*.tf", ".terraform/"}, name = "Terraform" }
}

-- Detect project type
local function detect_project_type()
    local cwd = vim.fn.getcwd()
    for project_type, config in pairs(project_types) do
        for _, pattern in ipairs(config.patterns) do
            if #vim.fn.globpath(cwd, pattern, false, true) > 0 then
                return { type = project_type, name = config.name }
            end
        end
    end
    return nil
end

-- Get project info
local function get_project_info()
    local cwd = vim.fn.getcwd()
    local detected = detect_project_type()
    local git_root = vim.fn.system("git rev-parse --show-toplevel 2>/dev/null")
    
    return {
        name = vim.fn.fnamemodify(cwd, ":t"),
        path = cwd,
        type = detected,
        git_root = git_root ~= "" and vim.fn.trim(git_root) or nil
    }
end

-- Project settings
local project_settings = {
    nodejs = { tabstop = 2, shiftwidth = 2, expandtab = true },
    python = { tabstop = 4, shiftwidth = 4, expandtab = true },
    go = { tabstop = 4, shiftwidth = 4, expandtab = false },
    rust = { tabstop = 4, shiftwidth = 4, expandtab = true }
}

-- Apply project settings
local function apply_project_settings()
    local project_info = get_project_info()
    if project_info.type and project_settings[project_info.type.type] then
        local settings = project_settings[project_info.type.type]
        vim.bo.tabstop = settings.tabstop
        vim.bo.shiftwidth = settings.shiftwidth
        vim.bo.expandtab = settings.expandtab
        vim.notify("Applied " .. project_info.type.name .. " settings", vim.log.levels.INFO)
    end
end

-- Build commands
local build_commands = {
    nodejs = { install = "npm install", build = "npm run build", test = "npm test", dev = "npm run dev" },
    python = { install = "pip install -r requirements.txt", test = "python -m pytest", dev = "python app.py" },
    go = { install = "go mod download", build = "go build", test = "go test ./..." },
    rust = { install = "cargo build", test = "cargo test", run = "cargo run" }
}

-- Execute build command
local function execute_build_command(command_type)
    local project_info = get_project_info()
    if project_info.type and build_commands[project_info.type.type] then
        local commands = build_commands[project_info.type.type]
        local command = commands[command_type]
        if command then
            vim.cmd("term " .. command)
            vim.notify("Executing: " .. command, vim.log.levels.INFO)
        end
    end
end

-- Workspace management
local workspaces = {}

local function add_workspace()
    local project_info = get_project_info()
    workspaces[project_info.path] = {
        name = project_info.name,
        type = project_info.type,
        added = os.date("%Y-%m-%d %H:%M:%S")
    }
    vim.notify("Added workspace: " .. project_info.name, vim.log.levels.INFO)
end

local function list_workspaces()
    if next(workspaces) == nil then
        vim.notify("No workspaces saved", vim.log.levels.INFO)
        return
    end
    
    local workspace_list = {}
    for path, info in pairs(workspaces) do
        table.insert(workspace_list, {
            filename = path,
            text = info.name .. " (" .. (info.type and info.type.name or "Unknown") .. ") - " .. info.added,
            lnum = 1, col = 1
        })
    end
    
    vim.fn.setqflist(workspace_list)
    vim.cmd("copen")
end

-- Show project info
local function show_project_info()
    local project_info = get_project_info()
    local info_text = {
        "Project Information",
        "==================",
        "Name: " .. project_info.name,
        "Path: " .. project_info.path,
        "Type: " .. (project_info.type and project_info.type.name or "Unknown"),
        "Git Root: " .. (project_info.git_root or "Not a git repository")
    }
    
    local width = 60
    local height = #info_text
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, info_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Setup keymaps
local function setup_keymaps()
    map("n", "<leader>pi", show_project_info, { desc = "Show project info" })
    map("n", "<leader>ps", apply_project_settings, { desc = "Apply project settings" })
    map("n", "<leader>wa", add_workspace, { desc = "Add workspace" })
    map("n", "<leader>wl", list_workspaces, { desc = "List workspaces" })
    map("n", "<leader>bi", function() execute_build_command("install") end, { desc = "Install dependencies" })
    map("n", "<leader>bb", function() execute_build_command("build") end, { desc = "Build project" })
    map("n", "<leader>bt", function() execute_build_command("test") end, { desc = "Test project" })
    map("n", "<leader>bd", function() execute_build_command("dev") end, { desc = "Start dev server" })
end

-- Setup function
local function setup()
    setup_keymaps()
    
    -- Auto-detect project settings
    api.nvim_create_autocmd("BufEnter", {
        pattern = "*",
        callback = function()
            local project_info = get_project_info()
            if project_info.type then
                apply_project_settings()
            end
        end,
    })
    
    vim.schedule(function()
        print("📁 Project Management loaded!")
        print("ℹ️ Use <leader>pi for project info")
        print("🔧 Use <leader>ps for project settings")
        print("📦 Use <leader>bi for install dependencies")
        print("🏗️ Use <leader>bb for build project")
    end)
end

return { setup = setup } 
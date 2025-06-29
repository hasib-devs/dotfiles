-- =============================================================================
-- Testing Integration Feature
-- =============================================================================

local map = vim.keymap.set
local api = vim.api

-- Test runners and their commands
local test_runners = {
    nodejs = {
        jest = {
            test = "npm test",
            test_file = "npm test --",
            test_line = "npm test -- --testNamePattern=",
            coverage = "npm test -- --coverage",
            watch = "npm test -- --watch"
        },
        mocha = {
            test = "npm test",
            test_file = "npx mocha",
            test_line = "npx mocha --grep=",
            coverage = "npx nyc mocha",
            watch = "npx mocha --watch"
        }
    },
    python = {
        pytest = {
            test = "python -m pytest",
            test_file = "python -m pytest",
            test_line = "python -m pytest -k",
            coverage = "python -m pytest --cov",
            watch = "python -m pytest --watch"
        },
        unittest = {
            test = "python -m unittest discover",
            test_file = "python -m unittest",
            test_line = "python -m unittest -k",
            coverage = "coverage run -m unittest discover && coverage report"
        }
    },
    go = {
        go_test = {
            test = "go test ./...",
            test_file = "go test",
            test_line = "go test -run",
            coverage = "go test -cover ./...",
            watch = "go test -watch ./..."
        }
    },
    rust = {
        cargo_test = {
            test = "cargo test",
            test_file = "cargo test",
            test_line = "cargo test",
            coverage = "cargo test --no-run && grcov . -s . --binary-path ./target/debug/ -t html --branch --ignore-not-existing -o ./coverage/",
            watch = "cargo watch -x test"
        }
    }
}

-- Test results storage
local test_results = {
    last_run = nil,
    coverage = nil,
    failures = {},
    output = ""
}

-- Get project type and test runner
local function get_test_runner()
    local cwd = vim.fn.getcwd()
    
    -- Check for Node.js projects
    if vim.fn.filereadable(cwd .. "/package.json") == 1 then
        local package_json = vim.fn.readfile(cwd .. "/package.json")
        for _, line in ipairs(package_json) do
            if line:match('"jest"') then
                return "nodejs", "jest"
            elseif line:match('"mocha"') then
                return "nodejs", "mocha"
            end
        end
        return "nodejs", "jest" -- Default for Node.js
    end
    
    -- Check for Python projects
    if vim.fn.filereadable(cwd .. "/requirements.txt") == 1 or 
       vim.fn.filereadable(cwd .. "/pyproject.toml") == 1 then
        return "python", "pytest"
    end
    
    -- Check for Go projects
    if vim.fn.filereadable(cwd .. "/go.mod") == 1 then
        return "go", "go_test"
    end
    
    -- Check for Rust projects
    if vim.fn.filereadable(cwd .. "/Cargo.toml") == 1 then
        return "rust", "cargo_test"
    end
    
    return nil, nil
end

-- Execute test command
local function execute_test_command(command_type, args)
    local project_type, runner = get_test_runner()
    
    if not project_type or not runner then
        vim.notify("No test runner detected for this project", vim.log.levels.WARN)
        return
    end
    
    local runners = test_runners[project_type]
    if not runners or not runners[runner] then
        vim.notify("Test runner not supported: " .. runner, vim.log.levels.WARN)
        return
    end
    
    local commands = runners[runner]
    local command = commands[command_type]
    
    if not command then
        vim.notify("Command type not supported: " .. command_type, vim.log.levels.WARN)
        return
    end
    
    -- Add arguments if provided
    if args then
        command = command .. " " .. args
    end
    
    -- Execute in terminal
    vim.cmd("term " .. command)
    vim.notify("Running: " .. command, vim.log.levels.INFO)
    
    -- Store test info
    test_results.last_run = {
        command = command,
        timestamp = os.date("%Y-%m-%d %H:%M:%S"),
        type = command_type
    }
end

-- Run all tests
local function run_all_tests()
    execute_test_command("test")
end

-- Run tests for current file
local function run_file_tests()
    local current_file = vim.fn.expand("%:p")
    local project_type, runner = get_test_runner()
    
    if project_type == "nodejs" then
        execute_test_command("test_file", current_file)
    elseif project_type == "python" then
        execute_test_command("test_file", current_file)
    elseif project_type == "go" then
        execute_test_command("test_file", current_file)
    elseif project_type == "rust" then
        execute_test_command("test_file", current_file)
    end
end

-- Run test at current line
local function run_line_test()
    local current_line = api.nvim_win_get_cursor(0)[1]
    local current_file = vim.fn.expand("%:p")
    local project_type, runner = get_test_runner()
    
    -- Get function name at current line (basic implementation)
    local line_content = api.nvim_buf_get_lines(0, current_line - 1, current_line, false)[1]
    local test_name = line_content:match("test%s*%([^)]*%)%s*{") or 
                     line_content:match("def%s+test_([%w_]+)") or
                     line_content:match("func%s+Test([%w_]+)") or
                     line_content:match("#[test]%s*fn%s+([%w_]+)")
    
    if test_name then
        execute_test_command("test_line", test_name)
    else
        vim.notify("No test function found at current line", vim.log.levels.WARN)
    end
end

-- Run tests with coverage
local function run_coverage_tests()
    execute_test_command("coverage")
end

-- Run tests in watch mode
local function run_watch_tests()
    execute_test_command("watch")
end

-- Show test results
local function show_test_results()
    if not test_results.last_run then
        vim.notify("No test results available", vim.log.levels.INFO)
        return
    end
    
    local info_text = {
        "Test Results",
        "============",
        "Last Run: " .. test_results.last_run.timestamp,
        "Command: " .. test_results.last_run.command,
        "Type: " .. test_results.last_run.type,
        "",
        "Output:",
        test_results.output ~= "" and test_results.output or "No output captured"
    }
    
    local width = 80
    local height = math.min(#info_text, 20)
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

-- Show test coverage
local function show_test_coverage()
    if not test_results.coverage then
        vim.notify("No coverage data available", vim.log.levels.INFO)
        return
    end
    
    local coverage_text = {
        "Test Coverage",
        "=============",
        test_results.coverage
    }
    
    local width = 80
    local height = math.min(#coverage_text, 20)
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, coverage_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Debug test at current line
local function debug_test()
    local project_type, runner = get_test_runner()
    
    if project_type == "nodejs" then
        local current_file = vim.fn.expand("%:p")
        vim.cmd("term node --inspect-brk " .. current_file)
        vim.notify("Debugger started for Node.js test", vim.log.levels.INFO)
    elseif project_type == "python" then
        local current_file = vim.fn.expand("%:p")
        vim.cmd("term python -m pdb " .. current_file)
        vim.notify("Debugger started for Python test", vim.log.levels.INFO)
    elseif project_type == "go" then
        local current_file = vim.fn.expand("%:p")
        vim.cmd("term dlv test " .. current_file)
        vim.notify("Debugger started for Go test", vim.log.levels.INFO)
    elseif project_type == "rust" then
        vim.cmd("term cargo test -- --nocapture")
        vim.notify("Debugger started for Rust test", vim.log.levels.INFO)
    else
        vim.notify("Debugging not supported for this project type", vim.log.levels.WARN)
    end
end

-- Show test runner info
local function show_test_info()
    local project_type, runner = get_test_runner()
    
    if not project_type or not runner then
        vim.notify("No test runner detected", vim.log.levels.WARN)
        return
    end
    
    local info_text = {
        "Test Runner Information",
        "======================",
        "Project Type: " .. project_type,
        "Test Runner: " .. runner,
        "",
        "Available Commands:",
        "- <leader>tt: Run all tests",
        "- <leader>tf: Run tests for current file",
        "- <leader>tl: Run test at current line",
        "- <leader>tc: Run tests with coverage",
        "- <leader>tw: Run tests in watch mode",
        "- <leader>tr: Show test results",
        "- <leader>td: Debug test"
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
    map("n", "<leader>tt", run_all_tests, { desc = "Run all tests" })
    map("n", "<leader>tf", run_file_tests, { desc = "Run tests for current file" })
    map("n", "<leader>tl", run_line_test, { desc = "Run test at current line" })
    map("n", "<leader>tc", run_coverage_tests, { desc = "Run tests with coverage" })
    map("n", "<leader>tw", run_watch_tests, { desc = "Run tests in watch mode" })
    map("n", "<leader>tr", show_test_results, { desc = "Show test results" })
    map("n", "<leader>td", debug_test, { desc = "Debug test" })
    map("n", "<leader>ti", show_test_info, { desc = "Show test info" })
end

-- Setup function
local function setup()
    setup_keymaps()
    
    -- Auto-detect test files and apply syntax highlighting
    api.nvim_create_autocmd("BufRead", {
        pattern = {"*test*.js", "*test*.ts", "*test*.py", "*_test.go", "*test*.rs"},
        callback = function()
            vim.bo.filetype = vim.bo.filetype
            vim.notify("Test file detected: " .. vim.fn.expand("%:t"), vim.log.levels.INFO)
        end,
    })
    
    vim.schedule(function()
        print("🧪 Testing Integration loaded!")
        print("🏃 Use <leader>tt for run all tests")
        print("📁 Use <leader>tf for run file tests")
        print("📍 Use <leader>tl for run line test")
        print("📊 Use <leader>tc for coverage tests")
        print("👀 Use <leader>tw for watch mode")
        print("🐛 Use <leader>td for debug test")
    end)
end

return { setup = setup } 
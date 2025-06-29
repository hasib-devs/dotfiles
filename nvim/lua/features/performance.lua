-- =============================================================================
-- Performance Optimization Feature
-- =============================================================================

local map = vim.keymap.set
local api = vim.api

-- Performance metrics storage
local performance_metrics = {
    startup_time = 0,
    memory_usage = {},
    resource_usage = {},
    slow_functions = {},
    optimization_suggestions = {}
}

-- Startup time tracking
local startup_start = vim.fn.reltime()

-- Get memory usage
local function get_memory_usage()
    local memory_info = vim.loop.get_memory_info()
    return {
        total = memory_info.total,
        used = memory_info.used,
        available = memory_info.available,
        percentage = (memory_info.used / memory_info.total) * 100
    }
end

-- Get resource usage
local function get_resource_usage()
    local cpu_info = vim.loop.get_cpu_info()
    local uptime = vim.loop.uptime()
    
    return {
        cpu_count = #cpu_info,
        uptime = uptime,
        load_average = vim.loop.loadavg()
    }
end

-- Measure function execution time
local function measure_function_time(func_name, func)
    local start_time = vim.fn.reltime()
    local result = func()
    local end_time = vim.fn.reltime(start_time)
    local execution_time = vim.fn.reltimefloat(end_time)
    
    -- Store slow functions (>100ms)
    if execution_time > 0.1 then
        table.insert(performance_metrics.slow_functions, {
            name = func_name,
            time = execution_time,
            timestamp = os.date("%Y-%m-%d %H:%M:%S")
        })
    end
    
    return result, execution_time
end

-- Show performance metrics
local function show_performance_metrics()
    local memory = get_memory_usage()
    local resources = get_resource_usage()
    local startup_time = vim.fn.reltimefloat(vim.fn.reltime(startup_start))
    
    local metrics_text = {
        "Performance Metrics",
        "==================",
        "Startup Time: " .. string.format("%.3f", startup_time) .. "s",
        "",
        "Memory Usage:",
        "  Total: " .. string.format("%.1f", memory.total / 1024 / 1024) .. " MB",
        "  Used: " .. string.format("%.1f", memory.used / 1024 / 1024) .. " MB",
        "  Available: " .. string.format("%.1f", memory.available / 1024 / 1024) .. " MB",
        "  Usage: " .. string.format("%.1f", memory.percentage) .. "%",
        "",
        "System Resources:",
        "  CPU Cores: " .. resources.cpu_count,
        "  Uptime: " .. string.format("%.1f", resources.uptime / 3600) .. " hours",
        "  Load Average: " .. string.format("%.2f", resources.load_average[1]),
        "",
        "Slow Functions (" .. #performance_metrics.slow_functions .. "):"
    }
    
    -- Add slow functions
    for i, func in ipairs(performance_metrics.slow_functions) do
        if i <= 5 then -- Show top 5
            table.insert(metrics_text, "  " .. func.name .. ": " .. string.format("%.3f", func.time) .. "s")
        end
    end
    
    if #performance_metrics.slow_functions > 5 then
        table.insert(metrics_text, "  ... and " .. (#performance_metrics.slow_functions - 5) .. " more")
    end
    
    local width = 70
    local height = math.min(#metrics_text, 25)
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, metrics_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Performance profiling
local function start_profiling()
    vim.cmd("profile start profile.log")
    vim.cmd("profile func *")
    vim.cmd("profile file *")
    vim.notify("Performance profiling started. Use <leader>ps to stop.", vim.log.levels.INFO)
end

local function stop_profiling()
    vim.cmd("profile pause")
    vim.notify("Performance profiling stopped. Check profile.log for results.", vim.log.levels.INFO)
end

-- Optimize Neovim settings
local function optimize_settings()
    local optimizations = {
        -- Reduce redraw frequency
        lazyredraw = true,
        -- Disable syntax highlighting for large files
        synmaxcol = 200,
        -- Reduce update time
        updatetime = 100,
        -- Disable swap files for temporary files
        swapfile = false,
        -- Reduce backup options
        backup = false,
        writebackup = false,
        -- Optimize search
        ignorecase = true,
        smartcase = true,
        -- Reduce completion menu
        pumheight = 10,
        -- Optimize terminal
        scrolloff = 5,
        sidescrolloff = 5
    }
    
    local applied = 0
    for option, value in pairs(optimizations) do
        vim.opt[option] = value
        applied = applied + 1
    end
    
    vim.notify("Applied " .. applied .. " performance optimizations", vim.log.levels.INFO)
end

-- Reset to default settings
local function reset_settings()
    local defaults = {
        lazyredraw = false,
        synmaxcol = 3000,
        updatetime = 4000,
        swapfile = true,
        backup = true,
        writebackup = true,
        ignorecase = false,
        smartcase = false,
        pumheight = 0,
        scrolloff = 0,
        sidescrolloff = 0
    }
    
    local applied = 0
    for option, value in pairs(defaults) do
        vim.opt[option] = value
        applied = applied + 1
    end
    
    vim.notify("Reset " .. applied .. " settings to defaults", vim.log.levels.INFO)
end

-- Analyze startup time
local function analyze_startup()
    local startup_time = vim.fn.reltimefloat(vim.fn.reltime(startup_start))
    
    local analysis_text = {
        "Startup Analysis",
        "================",
        "Total Time: " .. string.format("%.3f", startup_time) .. "s",
        "",
        "Performance Rating:"
    }
    
    if startup_time < 0.1 then
        table.insert(analysis_text, "  🚀 Excellent (< 100ms)")
    elseif startup_time < 0.5 then
        table.insert(analysis_text, "  ⚡ Good (< 500ms)")
    elseif startup_time < 1.0 then
        table.insert(analysis_text, "  📊 Acceptable (< 1s)")
    else
        table.insert(analysis_text, "  🐌 Slow (> 1s)")
    end
    
    table.insert(analysis_text, "")
    table.insert(analysis_text, "Optimization Suggestions:")
    
    if startup_time > 0.5 then
        table.insert(analysis_text, "  • Disable unused plugins")
        table.insert(analysis_text, "  • Use lazy loading")
        table.insert(analysis_text, "  • Optimize autocmds")
        table.insert(analysis_text, "  • Reduce file type detection")
    end
    
    if startup_time > 1.0 then
        table.insert(analysis_text, "  • Check for heavy plugins")
        table.insert(analysis_text, "  • Profile startup with --startuptime")
        table.insert(analysis_text, "  • Consider minimal config")
    end
    
    local width = 60
    local height = #analysis_text
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, analysis_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Monitor resource usage
local function start_monitoring()
    if performance_metrics.monitoring_active then
        vim.notify("Monitoring already active", vim.log.levels.WARN)
        return
    end
    
    performance_metrics.monitoring_active = true
    
    -- Create monitoring timer
    local timer = vim.loop.new_timer()
    timer:start(5000, 5000, vim.schedule_wrap(function()
        if not performance_metrics.monitoring_active then
            timer:stop()
            return
        end
        
        local memory = get_memory_usage()
        local resources = get_resource_usage()
        
        -- Store metrics
        table.insert(performance_metrics.memory_usage, {
            timestamp = os.date("%H:%M:%S"),
            usage = memory.percentage
        })
        
        table.insert(performance_metrics.resource_usage, {
            timestamp = os.date("%H:%M:%S"),
            load = resources.load_average[1]
        })
        
        -- Keep only last 20 entries
        if #performance_metrics.memory_usage > 20 then
            table.remove(performance_metrics.memory_usage, 1)
        end
        if #performance_metrics.resource_usage > 20 then
            table.remove(performance_metrics.resource_usage, 1)
        end
        
        -- Alert if usage is high
        if memory.percentage > 80 then
            vim.notify("High memory usage: " .. string.format("%.1f", memory.percentage) .. "%", vim.log.levels.WARN)
        end
        
        if resources.load_average[1] > 2.0 then
            vim.notify("High system load: " .. string.format("%.2f", resources.load_average[1]), vim.log.levels.WARN)
        end
    end))
    
    vim.notify("Resource monitoring started (5s intervals)", vim.log.levels.INFO)
end

local function stop_monitoring()
    performance_metrics.monitoring_active = false
    vim.notify("Resource monitoring stopped", vim.log.levels.INFO)
end

-- Show monitoring data
local function show_monitoring_data()
    if #performance_metrics.memory_usage == 0 then
        vim.notify("No monitoring data available. Start monitoring first.", vim.log.levels.INFO)
        return
    end
    
    local data_text = {
        "Resource Monitoring Data",
        "=======================",
        "Memory Usage History:",
    }
    
    for i, entry in ipairs(performance_metrics.memory_usage) do
        table.insert(data_text, "  " .. entry.timestamp .. ": " .. string.format("%.1f", entry.usage) .. "%")
    end
    
    table.insert(data_text, "")
    table.insert(data_text, "System Load History:")
    
    for i, entry in ipairs(performance_metrics.resource_usage) do
        table.insert(data_text, "  " .. entry.timestamp .. ": " .. string.format("%.2f", entry.load))
    end
    
    local width = 60
    local height = math.min(#data_text, 25)
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, data_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Generate optimization report
local function generate_optimization_report()
    local memory = get_memory_usage()
    local resources = get_resource_usage()
    local startup_time = vim.fn.reltimefloat(vim.fn.reltime(startup_start))
    
    local report_text = {
        "Optimization Report",
        "==================",
        "Generated: " .. os.date("%Y-%m-%d %H:%M:%S"),
        "",
        "Current Status:",
        "  Startup Time: " .. string.format("%.3f", startup_time) .. "s",
        "  Memory Usage: " .. string.format("%.1f", memory.percentage) .. "%",
        "  System Load: " .. string.format("%.2f", resources.load_average[1]),
        "",
        "Recommendations:"
    }
    
    -- Memory recommendations
    if memory.percentage > 70 then
        table.insert(report_text, "  🧠 High memory usage detected:")
        table.insert(report_text, "    • Close unused buffers")
        table.insert(report_text, "    • Restart Neovim if needed")
        table.insert(report_text, "    • Check for memory leaks")
    end
    
    -- Startup time recommendations
    if startup_time > 0.5 then
        table.insert(report_text, "  ⏱️ Slow startup detected:")
        table.insert(report_text, "    • Use --startuptime to profile")
        table.insert(report_text, "    • Disable unused features")
        table.insert(report_text, "    • Consider lazy loading")
    end
    
    -- System load recommendations
    if resources.load_average[1] > 1.5 then
        table.insert(report_text, "  💻 High system load detected:")
        table.insert(report_text, "    • Close other applications")
        table.insert(report_text, "    • Reduce background processes")
        table.insert(report_text, "    • Check system resources")
    end
    
    -- General recommendations
    table.insert(report_text, "  🔧 General optimizations:")
    table.insert(report_text, "    • Use <leader>po to optimize settings")
    table.insert(report_text, "    • Monitor with <leader>pm")
    table.insert(report_text, "    • Profile with <leader>pp")
    
    local width = 70
    local height = math.min(#report_text, 30)
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
    
    api.nvim_buf_set_lines(buf, 0, -1, false, report_text)
    api.nvim_buf_set_option(buf, "modifiable", false)
    api.nvim_buf_set_keymap(buf, "n", "q", "<cmd>close<CR>", { noremap = true, silent = true })
end

-- Setup keymaps
local function setup_keymaps()
    map("n", "<leader>pm", show_performance_metrics, { desc = "Show performance metrics" })
    map("n", "<leader>pp", start_profiling, { desc = "Start performance profiling" })
    map("n", "<leader>ps", stop_profiling, { desc = "Stop performance profiling" })
    map("n", "<leader>po", optimize_settings, { desc = "Optimize settings" })
    map("n", "<leader>pr", reset_settings, { desc = "Reset settings" })
    map("n", "<leader>pa", analyze_startup, { desc = "Analyze startup time" })
    map("n", "<leader>mm", start_monitoring, { desc = "Start resource monitoring" })
    map("n", "<leader>ms", stop_monitoring, { desc = "Stop resource monitoring" })
    map("n", "<leader>md", show_monitoring_data, { desc = "Show monitoring data" })
    map("n", "<leader>or", generate_optimization_report, { desc = "Generate optimization report" })
end

-- Setup function
local function setup()
    setup_keymaps()
    
    -- Record startup time when setup completes
    vim.schedule(function()
        performance_metrics.startup_time = vim.fn.reltimefloat(vim.fn.reltime(startup_start))
        
        print("⚡ Performance Optimization loaded!")
        print("📊 Use <leader>pm for performance metrics")
        print("🔧 Use <leader>po to optimize settings")
        print("📈 Use <leader>mm to start monitoring")
        print("📋 Use <leader>or for optimization report")
    end)
end

return { setup = setup } 
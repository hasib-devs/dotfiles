-- =============================================================================
-- Statusline Feature
-- =============================================================================

local opt = vim.opt

local function get_mode()
    local mode = vim.fn.mode()
    local mode_map = {
        n = "NORMAL",
        i = "INSERT", 
        v = "VISUAL",
        V = "V-LINE",
        ["\022"] = "V-BLOCK",
        R = "REPLACE",
        c = "COMMAND",
        t = "TERMINAL"
    }
    return mode_map[mode] or mode:upper()
end

local function get_filename()
    local filename = vim.fn.fnamemodify(vim.fn.expand("%"), ":t")
    if filename == "" then
        return "[No Name]"
    end
    return filename
end

local function get_filepath()
    local filepath = vim.fn.fnamemodify(vim.fn.expand("%"), ":p:h")
    if filepath == "." then
        return ""
    end
    return filepath
end

local function get_filetype()
    local ft = vim.bo.filetype
    if ft == "" then
        return "no ft"
    end
    return ft:upper()
end

local function get_encoding()
    local encoding = vim.bo.fileencoding
    if encoding == "" then
        encoding = vim.o.encoding
    end
    return encoding:upper()
end

local function get_position()
    local line = vim.fn.line(".")
    local total_lines = vim.fn.line("$")
    local col = vim.fn.col(".")
    local percent = math.floor((line / total_lines) * 100)
    return string.format("%d:%d/%d (%d%%)", line, col, total_lines, percent)
end

local function get_git_info()
    local git_branch = ""
    local git_status = ""
    local branch_result = vim.fn.system("git branch --show-current 2>/dev/null")
    if branch_result and branch_result ~= "" then
        git_branch = vim.fn.trim(branch_result)
    end
    if git_branch ~= "" then
        local file = vim.fn.expand("%")
        if file ~= "" then
            local status_result = vim.fn.system(string.format("git status --porcelain %s 2>/dev/null", vim.fn.shellescape(file)))
            if status_result and status_result ~= "" then
                local status_char = string.sub(status_result, 1, 1)
                if status_char == "M" then
                    git_status = " ●"
                elseif status_char == "A" then
                    git_status = " ✚"
                elseif status_char == "D" then
                    git_status = " ✖"
                elseif status_char == "R" then
                    git_status = " ➜"
                elseif status_char == "C" then
                    git_status = " ✗"
                elseif status_char == "U" then
                    git_status = " ⚡"
                elseif status_char == "?" then
                    git_status = " ✭"
                end
            end
        end
    end
    if git_branch ~= "" then
        return string.format("  󰘬 %s%s", git_branch, git_status)
    end
    return ""
end

local function get_lsp_status()
    local clients = vim.lsp.get_active_clients({ bufnr = 0 })
    if #clients > 0 then
        local client_names = {}
        for _, client in ipairs(clients) do
            table.insert(client_names, client.name)
        end
        return string.format("  󰒋 %s", table.concat(client_names, ","))
    end
    return ""
end

local function get_modified_status()
    if vim.bo.modified then
        return " ●"
    end
    return ""
end

local function get_readonly_status()
    if vim.bo.readonly then
        return " 󰀾"
    end
    return ""
end

local function statusline()
    local mode = get_mode()
    local filename = get_filename()
    local filepath = get_filepath()
    local filetype = get_filetype()
    local encoding = get_encoding()
    local position = get_position()
    local git_info = get_git_info()
    local lsp_status = get_lsp_status()
    local modified = get_modified_status()
    local readonly = get_readonly_status()
    local left = string.format(" %s  %s%s%s", mode, filename, modified, readonly)
    local center = filepath ~= "" and string.format("  %s", filepath) or ""
    local right = string.format("  %s  %s  %s%s%s", filetype, encoding, position, git_info, lsp_status)
    local total_width = vim.fn.winwidth(0)
    local left_width = vim.fn.strdisplaywidth(left)
    local center_width = vim.fn.strdisplaywidth(center)
    local right_width = vim.fn.strdisplaywidth(right)
    local padding = total_width - left_width - center_width - right_width
    if padding > 0 then
        center = center .. string.rep(" ", padding)
    end
    return left .. center .. right
end

local function setup()
    opt.statusline = "%!v:lua.statusline()"
    _G.statusline = statusline
    vim.api.nvim_create_autocmd({ "BufEnter", "BufLeave", "BufWritePost", "FileChangedShellPost" }, {
        pattern = "*",
        callback = function()
            vim.cmd("redrawstatus")
        end,
    })
    vim.api.nvim_create_autocmd("ColorScheme", {
        pattern = "*",
        callback = function()
            vim.api.nvim_set_hl(0, "StatusLine", { fg = "#ffffff", bg = "#000000" })
            vim.api.nvim_set_hl(0, "StatusLineNC", { fg = "#888888", bg = "#000000" })
        end,
    })
end

return { setup = setup } 
local code = require("vscode")

local map = function(mode, lhs, rhs)
	vim.keymap.set(mode, lhs, rhs, { expr = true }) -- expr is required
end

local function toggle_sidebar()
	code.call("workbench.action.toggleSidebarVisibility")
end

local function refactor()
	code.with_insert(function()
		code.action("editor.action.refactor")
	end)
end

local function raname_symbol()
	code.with_insert(function()
		code.action("editor.action.rename")
	end)
end

local function tab_prev()
	code.call("workbench.action.previousEditorInGroup")
end

local function tab_next()
	code.call("workbench.action.nextEditorInGroup")
end

map({ "n" }, "<leader>e", toggle_sidebar)
map({ "n", "x" }, "<leader>r", refactor)
map({ "n", "x" }, "<leader>rn", raname_symbol)
map({ "n" }, "L", tab_next)
map({ "n" }, "H", tab_prev)

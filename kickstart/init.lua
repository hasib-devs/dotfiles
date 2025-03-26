vim.g.mapleader = " "
vim.g.maplocalleader = " "

local map = vim.keymap.set
-- Add semicolon to end of the line
map({ "n", "v" }, "<leader>a;", "A;<Esc>", { desc = "Add semicolon to the end" })
-- Add comma to end of the line
map({ "n", "v" }, "<leader>a,", "A,<Esc>", { desc = "Add comma to the end" })
-- Save
map({ "n", "v" }, "<leader>w", "<cmd> w <cr>", { desc = "Save" })
map({ "n", "v" }, "<leader>W", "<cmd> wa <cr>", { desc = "Save All" })

if vim.g.vscode then
	require("config.vscode")
else
	require("config.options")
	require("config.keymaps")
	require("config.lazy")
end

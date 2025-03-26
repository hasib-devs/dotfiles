local o = vim.opt
local map = vim.keymap.set

-- Save
map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr><ESC>", { desc = "Save" })
map({ "i" }, "jk", "<Esc><cmd> w <cr>", { desc = "Save" })

-- Quit
map("n", "<leader>Q", "<cmd>qa<cr>", { desc = "Quit vim" })

-- Delete current buffer
map("n", "<leader>x", function()
	local buffers = vim.fn.getbufinfo({ buflisted = 1 })
	local current_buf = vim.api.nvim_get_current_buf()

	if #buffers <= 1 then
	-- vim.cmd("Alpha") -- Open dashboard
	else
		vim.cmd("bdelete " .. current_buf)
	end
end, { desc = "Delete buffer" })

-- Exit insert mode
map("i", "jj", "<ESC>", { desc = "Exit Insert Mode" })

-- Tmux Navigation
map("n", "<C-h>", ":TmuxNavigateLeft<CR>", { desc = "Navigate Left" })
map("n", "<C-j>", ":TmuxNavigateDown<CR>", { desc = "Navigate Down" })
map("n", "<C-k>", ":TmuxNavigateUp<CR>", { desc = "Navigate Up" })
map("n", "<C-l>", ":TmuxNavigateRight<CR>", { desc = "Navigate Right" })

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
-- map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Hide search highlight" })

-- Diagnostic keymaps
map("n", "<leader>qd", vim.diagnostic.setloclist, { desc = "Open diagnostic list" })
map("n", "<leader>qo", "<cmd>copen<CR>", { desc = "Open quickfix list" })
map("n", "<leader>qc", "<cmd>cclose<CR>", { desc = "Close quickfix list" })

-- Buffer
map("n", "<Tab>", ":BufferLineCycleNext<CR>", { desc = "Next Buffer" })
map("n", "<S-Tab>", ":BufferLineCyclePrev<CR>", { desc = "Prev Buffer" })
map("n", "<leader>p", ":BufferLinePick<CR>", { desc = "Pick Buffer" })
map("n", "<leader>bo", ":BufferLineCloseOthers<CR>", { desc = "Close Others Buffer" })
map("n", "<leader>br", ":BufferLineCloseRight<CR>", { desc = "Close Right Buffer" })
map("n", "<leader>bl", ":BufferLineCloseLeft<CR>", { desc = "Close Left Buffer" })

-- Add an empty line
map("n", "<leader>ao", "o<Esc>k", { desc = "Add empty line below" })
map("n", "<leader>aO", "O<Esc>j", { desc = "Add empty line above" })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Sync clipboard between OS and Neovim.
vim.schedule(function()
	o.clipboard = "unnamedplus"
end)

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		vim.opt.formatoptions:remove({ "o", "r" }) -- Stop continuing comments on new lines
	end,
})

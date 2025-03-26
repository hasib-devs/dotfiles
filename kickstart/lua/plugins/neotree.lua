return {
	"nvim-neo-tree/neo-tree.nvim",
	version = "*",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-tree/nvim-web-devicons", -- not strictly required, but recommended
		"MunifTanjim/nui.nvim",
	},
	cmd = "Neotree",
	keys = {
		{ "<leader>e", ":Neotree reveal<CR>", desc = "NeoTree reveal", silent = true },
	},
	opts = {
		close_if_last_window = true,
		event_handlers = {
			{
				event = "file_opened",
				handler = function()
					-- Automatically close Neo-Tree when a file is opened
					require("neo-tree.command").execute({ action = "close" })
				end,
			},
		},
		enable_git_status = true,
		filesystem = {
			window = {
				mappings = {
					["<leader>e"] = "close_window",
					["l"] = "open",
					["h"] = "close_node",
				},
			},
		},
	},
}

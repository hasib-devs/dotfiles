return { -- Fuzzy Finder (files, lsp, etc)
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ -- If encountering errors, see telescope-fzf-native README for installation instructions
			"nvim-telescope/telescope-fzf-native.nvim",

			-- `build` is used to run some command when the plugin is installed/updated.
			-- This is only run then, not every time Neovim starts up.
			build = "make",

			-- `cond` is a condition used to determine whether this plugin should be
			-- installed and loaded.
			cond = function()
				return vim.fn.executable("make") == 1
			end,
		},
		{ "nvim-telescope/telescope-ui-select.nvim" },

		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		local actions = require("telescope.actions")
		local map = vim.keymap.set

		require("telescope").setup({
			defaults = {
				-- preview = {
				-- 	filesize_limit = 1, -- MB
				-- },
				preview = false,
				mappings = {
					i = { ["<c-enter>"] = "to_fuzzy_refine" },
				},
				layout_strategy = "center",
				sorting_strategy = "ascending", -- Ensures the prompt is on top
			},
			pickers = {
				-- find_files = {
				-- 	previewer = false, -- Disable preview for find_files
				-- },
				buffers = {
					mappings = {
						i = {
							["<c-d>"] = actions.delete_buffer + actions.move_to_top,
						},
					},
				},
			},
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		map("n", "<leader>ff", builtin.find_files, { desc = "Find Files" })
		map("n", "<C-p>", builtin.find_files, { desc = "Find Files" })

		map("n", "<leader><leader>", builtin.buffers, { desc = "Find Buffers" })
		map("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })

		map("n", "<leader>fw", builtin.grep_string, { desc = "Find Current Word" })
		map("n", "<leader>fg", builtin.live_grep, { desc = "Find By Grep" })
		map("n", "<leader>fd", builtin.diagnostics, { desc = "Find Diagnostics" })
		map("n", "<leader>fr", builtin.resume, { desc = "Find Resume" })
		map("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
		map("n", "<leader>fh", builtin.help_tags, { desc = "Find Help" })
		map("n", "<leader>ft", builtin.builtin, { desc = "Find Builtin Telescope" })
		map("n", "<leader>fo", builtin.oldfiles, { desc = 'Find Old Files ("." for repeat)' })

		map("n", "<leader>fs", ":Autosession search<cr>", { desc = "Search Session" })

		-- Slightly advanced example of overriding default behavior and theme
		map("n", "<leader>/", function()
			-- You can pass additional configuration to Telescope to change the theme, layout, etc.
			builtin.current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
				winblend = 10,
				previewer = false,
			}))
		end, { desc = "Fuzzily search text in current buffer" })

		-- It's also possible to pass additional configuration options.
		--  See `:help telescope.builtin.live_grep()` for information about particular keys
		map("n", "<leader>f/", function()
			builtin.live_grep({
				grep_open_files = true,
				prompt_title = "Live Grep in Open Files",
			})
		end, { desc = "Search text in Open Files" })

		-- Shortcut for searching your Neovim configuration files
		map("n", "<leader>fn", function()
			builtin.find_files({ cwd = vim.fn.stdpath("config") })
		end, { desc = "Find Neovim files" })
	end,
}

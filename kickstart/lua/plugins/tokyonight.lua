-- the colorscheme should be available when starting Neovim
return {
	"folke/tokyonight.nvim",
	lazy = false,
	priority = 1000,
	opts = {
		transparent = true,
		styles = {
			sidebars = "transparent", -- Transparent for sidebars
			floats = "transparent", -- Transparent for floating windows
		},
	},
}

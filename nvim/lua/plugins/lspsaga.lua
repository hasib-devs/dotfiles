-- LSP Saga for enhanced LSP UI

return
{
  "nvimdev/lspsaga.nvim",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    require("lspsaga").setup({
      --
    })
  end,
}

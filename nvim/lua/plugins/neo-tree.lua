return {
  'nvim-neo-tree/neo-tree.nvim',
  branch = 'v3.x',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons',
    'MunifTanjim/nui.nvim',
  },
  config = function()
    require('neo-tree').setup({
      window = {
        mappings = {
          -- ['l'] = 'focus_preview',
        }
      },
      filesystem = {
        filtered_items = {
          visible = false,
          hide_dotfiles = true,
          hide_gitignored = true,
          hide_hidden = true,
          hide_by_name = {
            'node_modules',
          },
          always_show = {
            '.gitignored',
          },
          never_show = {
            '.DS_Store',
            'thumbs.db',
          },
          follow_current_file = {
            enabled = false,
            leave_dirs_open = false,
          },
        }
      }
    })
  end,
}

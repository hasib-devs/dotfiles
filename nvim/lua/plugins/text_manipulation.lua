return {
  -- Comment.nvim - Smart commenting
  {
    'numToStr/Comment.nvim',
    config = function()
      require('Comment').setup({
        toggler = {
          line = '<leader>cc',
          block = '<leader>cb',
        },
        opleader = {
          line = '<leader>c',
          block = '<leader>b',
        },
        extra = {
          above = '<leader>cO',
          below = '<leader>co',
          eol = '<leader>cA',
        },
        mappings = {
          basic = true,
          extra = true,
        },
      })
    end,
  },

  -- Surround - Surround text with brackets, quotes, etc.
  {
    'kylechui/nvim-surround',
    version = '*',
    config = function()
      require('nvim-surround').setup({
        keymaps = {
          insert = '<C-g>s',
          insert_line = '<C-g>S',
          normal = 'ys',
          normal_cur = 'yss',
          normal_line = 'yS',
          normal_cur_line = 'ySS',
          visual = 'S',
          visual_line = 'gS',
          delete = 'ds',
          change = 'cs',
        },
      })
    end,
  },

  -- Auto pairs - Auto close brackets, quotes, etc.
  {
    'windwp/nvim-autopairs',
    config = function()
      require('nvim-autopairs').setup({
        check_ts = true,
        ts_config = {
          lua = { 'string' },
          javascript = { 'template_string' },
          java = false,
        },
        disable_filetype = { 'TelescopePrompt', 'spectre_panel' },
        fast_wrap = {
          map = '<M-e>',
          chars = { '{', '[', '(', '"', "'" },
          pattern = string.gsub([[ [%'%"%)%>%]%)%}%,] ]], '%s+', ''),
          offset = 0,
          end_key = '$',
          keys = 'qwertyuiopzxcvbnmasdfghjkl',
          check_comma = true,
          highlight = 'PmenuSel',
          highlight_grey = 'LineNr',
        },
      })

      local cmp_autopairs = require('nvim-autopairs.completion.cmp')
      local cmp = require('cmp')
      cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
    end,
  },

  -- Indent blankline - Show indent guides
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function()
      require('ibl').setup({
        indent = {
          char = '│',
          tab_char = '│',
        },
        scope = {
          enabled = true,
          show_start = true,
          show_end = true,
          injected_languages = true,
          highlight = 'Function',
          priority = 500,
        },
        exclude = {
          filetypes = {
            'help',
            'alpha',
            'dashboard',
            'neo-tree',
            'Trouble',
            'lazy',
            'mason',
            'notify',
            'toggleterm',
            'lazyterm',
          },
        },
      })
    end,
  },

  -- Rainbow parentheses
  {
    'HiPhish/rainbow-delimiters.nvim',
    config = function()
      local rainbow_delimiters = require('rainbow-delimiters')

      vim.g.rainbow_delimiters = {
        strategy = {
          [''] = rainbow_delimiters.strategy['global'],
          vim = rainbow_delimiters.strategy['local'],
        },
        query = {
          [''] = 'rainbow-delimiters',
          lua = 'rainbow-blocks',
        },
        highlight = {
          'RainbowDelimiterRed',
          'RainbowDelimiterYellow',
          'RainbowDelimiterBlue',
          'RainbowDelimiterOrange',
          'RainbowDelimiterGreen',
          'RainbowDelimiterViolet',
          'RainbowDelimiterCyan',
        },
      }
    end,
  },

  -- Splitjoin - Split and join lines
  {
    'AndrewRadev/splitjoin.vim',
    config = function()
      vim.g.splitjoin_split_mapping = ''
      vim.g.splitjoin_join_mapping = ''
      vim.keymap.set('n', 'gJ', '<cmd>SplitjoinJoin<cr>', { desc = 'Join lines' })
      vim.keymap.set('n', 'gS', '<cmd>SplitjoinSplit<cr>', { desc = 'Split lines' })
    end,
  },

  -- Exchange - Exchange two regions
  {
    'tommcdo/vim-exchange',
    config = function()
      vim.keymap.set('n', 'cx', '<Plug>(Exchange)', { desc = 'Exchange' })
      vim.keymap.set('n', 'cxx', '<Plug>(ExchangeLine)', { desc = 'Exchange line' })
      vim.keymap.set('x', 'X', '<Plug>(Exchange)', { desc = 'Exchange selection' })
    end,
  },

  -- Replace with register
  {
    'vim-scripts/ReplaceWithRegister',
    config = function()
      vim.keymap.set('n', 'gr', '<Plug>ReplaceWithRegisterOperator', { desc = 'Replace with register' })
      vim.keymap.set('n', 'grr', '<Plug>ReplaceWithRegisterLine', { desc = 'Replace line with register' })
      vim.keymap.set('x', 'gr', '<Plug>ReplaceWithRegisterVisual', { desc = 'Replace selection with register' })
    end,
  },

  -- Multiple cursors
  {
    'mg979/vim-visual-multi',
    config = function()
      vim.g.VM_theme = 'iceblue'
      vim.g.VM_maps = {
        ['Find Under'] = '<C-d>',
        ['Find Subword Under'] = '<C-d>',
        ['Select All'] = '<C-n>',
        ['Start Regex Search'] = '/',
        ['Find Next'] = 'n',
        ['Find Prev'] = 'N',
        ['Remove Region'] = 'q',
        ['Skip Region'] = 'Q',
        ['Undo'] = 'u',
        ['Redo'] = '<C-r>',
      }
    end,
  },

  -- Align - Align text
  {
    'echasnovski/mini.align',
    version = '*',
    config = function()
      require('mini.align').setup()
      vim.keymap.set('n', 'ga', function()
        local obj = vim.fn.input('Align by: ')
        if obj ~= '' then
          require('mini.align').align('visual', obj)
        end
      end, { desc = 'Align by pattern' })
    end,
  },

  -- Easy align
  {
    'junegunn/vim-easy-align',
    config = function()
      vim.keymap.set('n', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy align' })
      vim.keymap.set('x', 'ga', '<Plug>(EasyAlign)', { desc = 'Easy align' })
    end,
  },
} 
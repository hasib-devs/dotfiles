return {
  -- Startup time profiler
  {
    'dstein64/vim-startuptime',
    cmd = 'StartupTime',
    config = function()
      vim.keymap.set('n', '<leader>ps', '<cmd>StartupTime<cr>', { desc = 'Show startup time' })
    end,
  },

  -- Performance profiler
  {
    'nvim-lua/plenary.nvim',
    config = function()
      vim.keymap.set('n', '<leader>pp', function()
        require('plenary.profile').start('profile.log')
      end, { desc = 'Start profiling' })

      vim.keymap.set('n', '<leader>ps', function()
        require('plenary.profile').stop()
      end, { desc = 'Stop profiling' })
    end,
  },

  -- Lazy profiling
  {
    'folke/lazy.nvim',
    config = function()
      vim.keymap.set('n', '<leader>pl', '<cmd>Lazy profile<cr>', { desc = 'Lazy profile' })
    end,
  },

  -- Memory usage
  {
    'tweekmonster/helpful.vim',
    config = function()
      vim.keymap.set('n', '<leader>pm', '<cmd>HelpfulMemory<cr>', { desc = 'Show memory usage' })
    end,
  },
} 
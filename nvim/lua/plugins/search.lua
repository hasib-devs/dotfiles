return {
  -- Telescope - Fuzzy finder
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
      'nvim-telescope/telescope-file-browser.nvim',
      'nvim-telescope/telescope-github.nvim',
      'nvim-telescope/telescope-project.nvim',
      'nvim-telescope/telescope-live-grep-args.nvim',
    },
    config = function()
      local telescope = require('telescope')
      local actions = require('telescope.actions')
      local builtin = require('telescope.builtin')

      telescope.setup({
        defaults = {
          mappings = {
            i = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.send_selected_to_qflist,
              ['<C-u>'] = actions.preview_scrolling_up,
              ['<C-d>'] = actions.preview_scrolling_down,
            },
            n = {
              ['<C-j>'] = actions.move_selection_next,
              ['<C-k>'] = actions.move_selection_previous,
              ['<C-q>'] = actions.send_selected_to_qflist,
            },
          },
          file_ignore_patterns = {
            'node_modules',
            '.git',
            'dist',
            'build',
            '*.pyc',
            '__pycache__',
          },
        },
        pickers = {
          find_files = {
            hidden = true,
            find_command = { 'rg', '--files', '--hidden', '--glob', '!**/.git/*' },
          },
          live_grep = {
            additional_args = function()
              return { '--hidden' }
            end,
          },
        },
        extensions = {
          file_browser = {
            theme = 'dropdown',
            hijack_netrw = true,
            mappings = {
              ['i'] = {
                ['<C-w>'] = function()
                  vim.cmd('normal vbd')
                end,
              },
              ['n'] = {
                ['N'] = require('telescope').extensions.file_browser.actions.create,
                ['h'] = require('telescope').extensions.file_browser.actions.goto_parent_dir,
                ['/'] = function()
                  vim.cmd('startinsert')
                end,
              },
            },
          },
          project = {
            base_dirs = {
              -- { path = '~/projects', max_depth = 4 },
              -- { path = '~/work', max_depth = 4 },
            },
            hidden_files = true,
          },
        },
      })

      telescope.load_extension('fzf')
      telescope.load_extension('ui-select')
      telescope.load_extension('file_browser')
      telescope.load_extension('project')
      telescope.load_extension('live_grep_args')

      -- Keymaps
      vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Find files' })
      vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Live grep' })
      vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Find buffers' })
      vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Help tags' })
      vim.keymap.set('n', '<leader>fo', builtin.oldfiles, { desc = 'Old files' })
      vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = 'Commands' })
      vim.keymap.set('n', '<leader>fm', builtin.marks, { desc = 'Marks' })
      vim.keymap.set('n', '<leader>fr', builtin.registers, { desc = 'Registers' })
      vim.keymap.set('n', '<leader>fs', builtin.spell_suggest, { desc = 'Spell suggest' })
      vim.keymap.set('n', '<leader>ft', builtin.treesitter, { desc = 'Treesitter symbols' })
      vim.keymap.set('n', '<leader>fp', telescope.extensions.project.project, { desc = 'Projects' })
      vim.keymap.set('n', '<leader>fe', telescope.extensions.file_browser.file_browser, { desc = 'File browser' })
    end,
  },

  -- FZF native sorter for telescope
  {
    'nvim-telescope/telescope-fzf-native.nvim',
    build = 'make',
    cond = vim.fn.executable('make') == 1,
  },

  -- Harpoon - Quick file navigation
  {
    'ThePrimeagen/harpoon',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      local mark = require('harpoon.mark')
      local ui = require('harpoon.ui')

      vim.keymap.set('n', '<leader>a', mark.add_file, { desc = 'Add file to harpoon' })
      vim.keymap.set('n', '<leader>h', ui.toggle_quick_menu, { desc = 'Toggle harpoon menu' })
      vim.keymap.set('n', '<leader>1', function() ui.nav_file(1) end, { desc = 'Harpoon file 1' })
      vim.keymap.set('n', '<leader>2', function() ui.nav_file(2) end, { desc = 'Harpoon file 2' })
      vim.keymap.set('n', '<leader>3', function() ui.nav_file(3) end, { desc = 'Harpoon file 3' })
      vim.keymap.set('n', '<leader>4', function() ui.nav_file(4) end, { desc = 'Harpoon file 4' })
    end,
  },
} 
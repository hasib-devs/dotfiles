return {
  -- Git signs
  {
    'lewis6991/gitsigns.nvim',
    config = function()
      require('gitsigns').setup({
        signs = {
          add = { text = '+' },
          change = { text = '~' },
          delete = { text = '_' },
          topdelete = { text = '‾' },
          changedelete = { text = '~' },
          untracked = { text = '┆' },
        },
        signcolumn = true,
        numhl = false,
        linehl = false,
        word_diff = false,
        watch_gitdir = {
          interval = 1000,
          follow_files = true,
        },
        attach_to_untracked = true,
        current_line_blame = false,
        current_line_blame_opts = {
          virt_text = true,
          virt_text_pos = 'eol',
          delay = 1000,
          ignore_whitespace = false,
        },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil,
        max_file_length = 40000,
        preview_config = {
          border = 'single',
          style = 'minimal',
          relative = 'cursor',
          row = 0,
          col = 1,
        },
      })

      vim.keymap.set('n', '<leader>gb', require('gitsigns').toggle_current_line_blame, { desc = 'Toggle git blame' })
      vim.keymap.set('n', '<leader>gd', require('gitsigns').diffthis, { desc = 'Git diff' })
      vim.keymap.set('n', '<leader>gp', require('gitsigns').preview_hunk, { desc = 'Preview hunk' })
      vim.keymap.set('n', '<leader>gr', require('gitsigns').reset_hunk, { desc = 'Reset hunk' })
      vim.keymap.set('n', '<leader>gs', require('gitsigns').stage_hunk, { desc = 'Stage hunk' })
      vim.keymap.set('n', '<leader>gu', require('gitsigns').undo_stage_hunk, { desc = 'Undo stage hunk' })
    end,
  },

  -- Git blame
  {
    'f-person/git-blame.nvim',
    config = function()
      require('gitblame').setup({
        enabled = false,
        message_template = '<summary> • <date> • <author>',
        date_format = '%r',
        highlight_group = 'Comment',
        virt_text_pos = 'eol',
        delay = 1000,
        virtual_text_column = nil,
        ignored_filetypes = { 'NvimTree', 'TelescopePrompt', 'DiffviewFiles', 'DiffviewClose', 'DiffviewHunk', 'DiffviewAddFiles', 'DiffviewDeleteFiles', 'DiffviewToggleRefine', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewToggleIgnoreWhiteSpace', 'DiffviewToggleSigns', 'DiffviewLog', 'DiffviewClose', 'DiffviewHunk', 'DiffviewAddFiles', 'DiffviewDeleteFiles', 'DiffviewToggleRefine', 'DiffviewToggleFiles', 'DiffviewFocusFiles', 'DiffviewRefresh', 'DiffviewToggleIgnoreWhiteSpace', 'DiffviewToggleSigns', 'DiffviewLog' },
      })

      vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<cr>', { desc = 'Toggle git blame' })
    end,
  },

  -- Git diffview
  {
    'sindrets/diffview.nvim',
    dependencies = 'nvim-lua/plenary.nvim',
    config = function()
      require('diffview').setup({
        diff_binaries = false,
        enhanced_diff_hl = false,
        git_cmd = { 'git' },
        use_icons = true,
        icons = {
          folder_closed = '',
          folder_open = '',
        },
        signs = {
          fold_closed = '',
          fold_open = '',
        },
        file_panel = {
          listing_style = 'tree',
          tree_options = {
            flatten_dirs = true,
            folder_statuses = 'only_folded',
          },
        },
        file_history_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
        },
        commit_log_panel = {
          log_options = {
            git = {
              single_file = {
                diff_merges = 'combined',
              },
              multi_file = {
                diff_merges = 'first-parent',
              },
            },
          },
        },
        default_args = {
          DiffviewOpen = {},
          DiffviewClose = {},
          DiffviewToggleFiles = {},
          DiffviewFocusFiles = {},
          DiffviewRefresh = {},
          DiffviewHunk = {},
          DiffviewAddFiles = {},
          DiffviewDeleteFiles = {},
          DiffviewToggleRefine = {},
          DiffviewToggleIgnoreWhiteSpace = {},
          DiffviewToggleSigns = {},
          DiffviewLog = {},
        },
        hooks = {},
        keymaps = {
          disable_defaults = false,
          view = {
            ['<tab>'] = '<cmd>DiffviewToggleFiles<cr>',
            ['<s-tab>'] = '<cmd>DiffviewToggleFiles<cr>',
            ['gf'] = '<cmd>DiffviewToggleFiles<cr>',
            ['<C-w><C-f>'] = '<cmd>DiffviewToggleFiles<cr>',
            ['<C-w>gf'] = '<cmd>DiffviewToggleFiles<cr>',
            ['?'] = ':help diffview.txt<cr>',
            ['q'] = '<cmd>DiffviewClose<cr>',
          },
          file_panel = {
            ['j'] = '<cmd>lua require"diffview".action_next_entry()<cr>',
            ['<down>'] = '<cmd>lua require"diffview".action_next_entry()<cr>',
            ['k'] = '<cmd>lua require"diffview".action_prev_entry()<cr>',
            ['<up>'] = '<cmd>lua require"diffview".action_prev_entry()<cr>',
            ['<cr>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['o'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['R'] = '<cmd>lua require"diffview".action_refresh_entries()<cr>',
            ['<tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<s-tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['gf'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<C-w><C-f>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<C-w>gf'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['i'] = '<cmd>lua require"diffview".action_toggle_files()<cr>',
            ['?'] = ':help diffview.txt<cr>',
            ['q'] = '<cmd>lua require"diffview".action_close()<cr>',
          },
          file_history_panel = {
            ['g!'] = '<cmd>lua require"diffview".action_options()<cr>',
            ['<C-A-d>'] = '<cmd>lua require"diffview".action_view_options()<cr>',
            ['y'] = '<cmd>lua require"diffview".action_toggle_files()<cr>',
            ['<C-d>'] = '<cmd>lua require"diffview".action_view_options()<cr>',
            ['D'] = '<cmd>lua require"diffview".action_toggle_files()<cr>',
            ['?'] = ':help diffview.txt<cr>',
            ['q'] = '<cmd>lua require"diffview".action_close()<cr>',
          },
          option_panel = {
            ['<tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<s-tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<cr>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['i'] = '<cmd>lua require"diffview".action_toggle_files()<cr>',
            ['?'] = ':help diffview.txt<cr>',
            ['q'] = '<cmd>lua require"diffview".action_close()<cr>',
          },
          help_panel = {
            ['<tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<s-tab>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['<cr>'] = '<cmd>lua require"diffview".action_select_entry()<cr>',
            ['i'] = '<cmd>lua require"diffview".action_toggle_files()<cr>',
            ['?'] = ':help diffview.txt<cr>',
            ['q'] = '<cmd>lua require"diffview".action_close()<cr>',
          },
        },
      })

      vim.keymap.set('n', '<leader>gd', '<cmd>DiffviewOpen<cr>', { desc = 'Open diffview' })
      vim.keymap.set('n', '<leader>gh', '<cmd>DiffviewFileHistory<cr>', { desc = 'File history' })
      vim.keymap.set('n', '<leader>gc', '<cmd>DiffviewClose<cr>', { desc = 'Close diffview' })
    end,
  },

  -- Git conflict resolution
  {
    'akinsho/git-conflict.nvim',
    version = '*',
    config = function()
      require('git-conflict').setup({
        default_mappings = {
          ours = 'o',
          theirs = 't',
          none = '0',
          both = 'b',
          next = 'n',
          prev = 'p',
        },
        disable_diagnostics = false,
        highlights = {
          incoming = 'DiffText',
          current = 'DiffAdd',
        },
      })

      vim.keymap.set('n', '<leader>go', '<cmd>GitConflictChooseOurs<cr>', { desc = 'Choose ours' })
      vim.keymap.set('n', '<leader>gt', '<cmd>GitConflictChooseTheirs<cr>', { desc = 'Choose theirs' })
      vim.keymap.set('n', '<leader>gb', '<cmd>GitConflictChooseBoth<cr>', { desc = 'Choose both' })
      vim.keymap.set('n', '<leader>gn', '<cmd>GitConflictNextConflict<cr>', { desc = 'Next conflict' })
      vim.keymap.set('n', '<leader>gp', '<cmd>GitConflictPrevConflict<cr>', { desc = 'Prev conflict' })
    end,
  },
} 
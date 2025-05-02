-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {

  { -- virtual env selection
    'AckslD/swenv.nvim',
    config = function()
      require('swenv').setup {
        venvs_path = vim.fn.expand '~/.pyenv/versions',
        post_set_venv = function()
          vim.cmd 'LspRestart' -- optional: restart Pyright or any Python LSP
        end,
      }
    end,
  },
  { 'luk400/vim-jukit' },
  {
    'stevearc/overseer.nvim',
    config = function()
      local overseer = require 'overseer'
      overseer.setup {}

      -- Overseer key mappings (normal mode)
      local keymap = vim.keymap.set
      keymap('n', '<Leader>xt', '<CMD>OverseerToggle<CR>', { desc = 'Overseer: Toggle window' })
      keymap('n', '<Leader>xo', '<CMD>OverseerOpen<CR>', { desc = 'Overseer: Open window' })
      keymap('n', '<Leader>xc', '<CMD>OverseerClose<CR>', { desc = 'Overseer: Close window' })
      keymap('n', '<Leader>xr', '<CMD>OverseerRun<CR>', { desc = 'Overseer: Run task' })
      keymap('n', '<Leader>xb', '<CMD>OverseerBuild<CR>', { desc = 'Overseer: Task builder' })
      keymap('n', '<Leader>xx', '<CMD>OverseerRunCmd<CR>', { desc = 'Overseer: Run shell command' })
      keymap('n', '<Leader>xq', '<CMD>OverseerQuickAction<CR>', { desc = 'Overseer: Quick action' })
      keymap('n', '<Leader>xa', '<CMD>OverseerTaskAction<CR>', { desc = 'Overseer: Task action' })
      keymap('n', '<Leader>xs', '<CMD>OverseerSaveBundle<CR>', { desc = 'Overseer: Save bundle' })
      keymap('n', '<Leader>xl', '<CMD>OverseerLoadBundle<CR>', { desc = 'Overseer: Load bundle' })
      keymap('n', '<Leader>xd', '<CMD>OverseerDeleteBundle<CR>', { desc = 'Overseer: Delete bundle' })
      keymap('n', '<Leader>xi', '<CMD>OverseerInfo<CR>', { desc = 'Overseer: Info' })
      keymap('n', '<Leader>xC', '<CMD>OverseerClearCache<CR>', { desc = 'Overseer: Clear cache' })

      -- Custom command to restart last task
      vim.api.nvim_create_user_command('OverseerRestartLast', function()
        local tasks = overseer.list_tasks { recent_first = true }
        if vim.tbl_isempty(tasks) then
          vim.notify('No tasks found', vim.log.levels.WARN)
        else
          overseer.run_action(tasks[1], 'restart')
        end
      end, {})
      -- Custom template to run all shell scripts
      overseer.register_template {
        name = 'Shell scripts in current dir',
        generator = function(opts, cb)
          local scripts = vim.tbl_filter(function(filename)
            return filename:match '%.sh$'
          end, files.list_files(opts.dir))

          local ret = {}
          for _, filename in ipairs(scripts) do
            table.insert(ret, {
              name = filename,
              params = {
                args = { optional = true, type = 'list', delimiter = ' ' },
              },
              builder = function(params)
                return {
                  cmd = { files.join(opts.dir, filename) },
                  args = params.args,
                }
              end,
            })
          end
          cb(ret)
        end,
      }
    end,
    opts = {},
  },
  {
    'rmagatti/auto-session',
    lazy = false,
    keys = {
      -- Will use Telescope if installed or a vim.ui.select picker otherwise
      { '<leader>wr', '<cmd>SessionSearch<CR>', desc = 'Session search' },
      { '<leader>ws', '<cmd>SessionSave<CR>', desc = 'Save session' },
      { '<leader>wa', '<cmd>SessionToggleAutoSave<CR>', desc = 'Toggle autosave' },
    },

    ---enables autocomplete for opts
    ---@module "auto-session"
    ---@type AutoSession.Config
    opts = {
      -- ⚠️ This will only work if Telescope.nvim is installed
      -- The following are already the default values, no need to provide them if these are already the settings you want.
      session_lens = {
        -- If load_on_setup is false, make sure you use `:SessionSearch` to open the picker as it will initialize everything first
        load_on_setup = true,
        previewer = false,
        mappings = {
          -- Mode can be a string or a table, e.g. {"i", "n"} for both insert and normal mode
          delete_session = { 'i', '<C-D>' },
          alternate_session = { 'i', '<C-S>' },
          copy_session = { 'i', '<C-Y>' },
        },
        -- Can also set some Telescope picker options
        -- For all options, see: https://github.com/nvim-telescope/telescope.nvim/blob/master/doc/telescope.txt#L112
        theme_conf = {
          border = true,
          -- layout_config = {
          --   width = 0.8, -- Can set width and height as percent of window
          --   height = 0.5,
          -- },
        },
      },
    },
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    },
  },
}

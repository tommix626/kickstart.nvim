-- tinygit plugin
return {
  'chrisgrieser/nvim-tinygit',
  config = function()
    local tinygit = require 'tinygit'
    tinygit.smartCommit {
      pushIfClean = false,
      pullBeforePush = true,
    }

    vim.keymap.set('n', '<leader>ga', function()
      tinygit.interactiveStaging()
    end, { desc = 'git add' })

    vim.keymap.set('n', '<leader>gc', function()
      tinygit.smartCommit()
    end, { desc = 'git commit' })

    vim.keymap.set('n', '<leader>gp', function()
      tinygit.push()
    end, { desc = 'git push' })
  end,
}

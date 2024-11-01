return {
  'GustavEikaas/easy-dotnet.nvim',
  dependencies = { 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope.nvim' },
  config = function()
    local dotnet = require 'easy-dotnet'

    dotnet.setup {
      ---@type TestRunnerOptions
      test_runner = {
        ---@type "split"| "float" | "buff"
        viewmode = 'float',
        enable_buffer_test_execution = true,
        noBuild = true,
        noRestore = true,
        mappings = {
          run_test_from_buffer = { lhs = '<leader>r', desc = 'run test from buffer' },
          filter_failed_tests = { lhs = '<leader>fe', desc = 'filter failed tests' },
          debug_test = { lhs = '<leader>d', desc = 'debug test' },
          go_to_file = { lhs = 'g', desc = 'got to file' },
          run_all = { lhs = '<leader>R', desc = 'run all tests' },
          run = { lhs = '<leader>r', desc = 'run test' },
          peek_stacktrace = { lhs = '<leader>p', desc = 'peek stacktrace of failed test' },
          expand = { lhs = 'o', desc = 'expand' },
          expand_all = { lhs = 'E', desc = 'expand all' },
          collapse_all = { lhs = 'W', desc = 'collapse all' },
          close = { lhs = 'q', desc = 'close testrunner' },
          refresh_testrunner = { lhs = '<C-r>', desc = 'refresh testrunner' },
          debug_test_from_buffer = { lhs = '<leader>dtb', desc = 'debug tests from buffer' },
        },
        additional_args = {},
      },

      vim.api.nvim_create_user_command('Secrets', function()
        dotnet.secrets()
      end, {}),

      -- Example keybinding
      vim.keymap.set('n', '<C-t>', function()
        dotnet.test_solution()
      end),
    }
  end,
}

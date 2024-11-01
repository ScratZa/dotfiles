-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Primarily focused on configuring the debugger for Go, but can
-- be extended to other languages as well. That's why it's called
-- kickstart.nvim and not kitchen-sink.nvim ;)

return {
  -- NOTE: Yes, you can install new plugins here!
  'mfussenegger/nvim-dap',
  -- NOTE: And you can specify dependencies as well
  dependencies = {
    -- Creates a beautiful debugger UI
    'rcarriga/nvim-dap-ui',

    -- Required dependency for nvim-dap-ui
    'nvim-neotest/nvim-nio',

    -- Installs the debug adapters for you
    'williamboman/mason.nvim',
    'jay-babu/mason-nvim-dap.nvim',

    -- Add your own debuggers here
    'leoluz/nvim-dap-go',
  },
  keys = function(_, keys)
    local dap = require 'dap'

    local dapui = require 'dapui'
    return {
      { '<leader>d', '', desc = '+debug', mode = { 'n', 'v' } },
      -- HYDRA MODE
      -- NOTE: the delay is set to prevent the which-key hints to appear
      {
        '<leader>d<space>',
        function()
          require('which-key').show { delay = 1000000000, keys = '<leader>d', loop = true }
        end,
        desc = 'DAP Hydra Mode (which-key)',
      },
      {
        '<leader>dR',
        function()
          local dap = require 'dap'
          local extension = vim.fn.expand '%:e'
          dap.run(dap.configurations[extension][1])
        end,
        desc = 'Run default configuration',
      },
      {
        '<leader>dT',
        function()
          local dap = require 'dap'
          local extension = vim.fn.expand '%:e'
          dap.run(dap.configurations[extension][2])
        end,
        desc = 'Run default test configuration',
      },
      {
        '<leader>dB',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = 'Breakpoint Condition',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle Breakpoint',
      },
      {
        '<F10>',
        function()
          require('dap').continue()
        end,
        desc = 'Continue',
      },
      {
        '<leader>da',
        function()
          require('dap').continue { before = get_args }
        end,
        desc = 'Run with Args',
      },
      {
        '<leader>dC',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Run to Cursor',
      },
      {
        '<leader>dg',
        function()
          require('dap').goto_()
        end,
        desc = 'Go to Line (No Execute)',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = 'Step Into',
      },
      {
        '<F6>',
        function()
          require('dap').down()
        end,
        desc = 'Down',
      },
      {
        '<leader>dk',
        function()
          require('dap').up()
        end,
        desc = 'Up',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = 'Step Out',
      },
      {
        '<F5>',
        function()
          require('dap').step_over()
        end,
        desc = 'Step Over',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = 'Pause',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.toggle()
        end,
        desc = 'Toggle REPL',
      },
      {
        '<leader>ds',
        function()
          require('dap').session()
        end,
        desc = 'Session',
      },
      {
        '<leader>dt',
        function()
          require('dap').terminate()
        end,
        desc = 'Terminate',
      },
      {
        '<leader>dw',
        function()
          require('dap.ui.widgets').hover()
        end,
        desc = 'Widgets',
      },
      { '<F7>', dapui.toggle, desc = 'Debug: See last session result.' },
      unpack(keys),
    }
  end,
  config = function()
    local dap = require 'dap'
    local dapui = require 'dapui'

    require('mason-nvim-dap').setup {
      -- Makes a best effort to setup the various debuggers with
      -- reasonable debug configurations
      automatic_installation = true,

      -- You can provide additional configuration to the handlers,
      -- see mason-nvim-dap README for more information
      handlers = {},

      -- You'll need to check that you have the required things installed
      -- online, please don't ask me how to install them :)
      ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
        'delve',
      },
    }
    -- Dotnet Debug Setup
    if not dap.adapters['netcoredbg'] then
      require('dap').adapters['netcoredbg'] = {
        type = 'executable',
        command = vim.fn.exepath 'netcoredbg',
        args = { '--interpreter=vscode' },
        -- console = "internalConsole",
      }
    end
    local dotnet = require 'easy-dotnet'
    local debug_dll = nil
    local function ensure_dll()
      if debug_dll ~= nil then
        return debug_dll
      end
      local dll = dotnet.get_debug_dll()
      debug_dll = dll
      return dll
    end
    for _, lang in ipairs { 'cs', 'fsharp', 'vb' } do
      dap.configurations[lang] = {
        {
          log_level = 'DEBUG',
          type = 'netcoredbg',
          justMyCode = false,
          stopAtEntry = false,
          name = 'Default',
          request = 'launch',
          env = function()
            local dll = ensure_dll()
            local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
            return vars or nil
          end,
          program = function()
            require('overseer').enable_dap()
            local dll = ensure_dll()
            return dll.relative_dll_path
          end,
          cwd = function()
            local dll = ensure_dll()
            return dll.relative_project_path
          end,
          preLaunchTask = 'Build .NET App With Spinner',
        },
        {
          type = 'coreclr',
          name = 'launch - netcoredbg',
          request = 'launch',
          env = function()
            local dll = ensure_dll()
            local vars = dotnet.get_environment_variables(dll.project_name, dll.relative_project_path)
            return vars or nil
          end,
          program = function()
            local dll = ensure_dll()
            -- local co = coroutine.running()
            -- rebuild_project(co, dll.project_path)

            return dll.relative_dll_path
          end,
          cwd = function()
            local dll = ensure_dll()
            return dll.relative_project_path
          end,
        },
      }
      dap.listeners.before['event_terminated']['easy-dotnet'] = function()
        debug_dll = nil
      end
      dap.adapters.coreclr = {
        type = 'executable',
        command = 'netcoredbg',
        args = { '--interpreter=vscode' },
      }
    end

    -- Dap UI setup
    -- For more information, see |:help nvim-dap-ui|
    dapui.setup {
      -- Set icons to characters that are more likely to work in every terminal.
      --    Feel free to remove or use ones that you like more! :)
      --    Don't feel like these are good choices.
      icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
      controls = {
        icons = {
          pause = '⏸',
          play = '▶',
          step_into = '⏎',
          step_over = '⏭',
          step_out = '⏮',
          step_back = 'b',
          run_last = '▶▶',
          terminate = '⏹',
          disconnect = '⏏',
        },
      },
    }

    dap.listeners.after.event_initialized['dapui_config'] = dapui.open
    dap.listeners.before.event_terminated['dapui_config'] = dapui.close
    dap.listeners.before.event_exited['dapui_config'] = dapui.close

    -- Install golang specific config
    require('dap-go').setup {
      delve = {
        -- On Windows delve must be run attached or it crashes.
        -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
        detached = vim.fn.has 'win32' == 0,
      },
    }
  end,
}

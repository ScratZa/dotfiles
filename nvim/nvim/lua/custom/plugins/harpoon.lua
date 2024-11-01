return {
  'ThePrimeagen/harpoon',
  name = 'harpoon',
  branch = 'harpoon2',
  config = function()
    local harpoon = require 'harpoon'

    harpoon:setup()

    local conf = require('telescope.config').values
    local function toggle_telescope(harpoon_files)
      local file_paths = {}
      for _, item in ipairs(harpoon_files.items) do
        table.insert(file_paths, item.value)
      end

      require('telescope.pickers')
        .new({}, {
          prompt_title = 'Harpoon',
          finder = require('telescope.finders').new_table {
            results = file_paths,
          },
          previewer = conf.file_previewer {},
          sorter = conf.generic_sorter {},
        })
        :find()
    end
    vim.keymap.set('n', '<C-e>', function()
      harpoon.ui:toggle_quick_menu(harpoon:list())
    end, { desc = 'Open Quick Menu' })
    vim.keymap.set('n', '<leader>h', function()
      toggle_telescope(harpoon:list())
    end, { desc = 'Open harpoon window' })

    vim.keymap.set('n', '<leader>x', function()
      harpoon:list():add()
    end, { desc = 'Harpoon Mark' })
    vim.keymap.set('n', '<leader>X', function()
      harpoon:list():remove()
    end, { desc = 'Harpoon Unmark' })
    -- vim.keymap.set("n", "<leader><Space>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
    --     { desc = "Open harpoon window" })

    vim.keymap.set('n', '<leader>hf', function()
      harpoon:list():select(1)
    end)
    vim.keymap.set('n', '<leader>hs', function()
      harpoon:list():select(2)
    end)
    vim.keymap.set('n', '<leader>ht', function()
      harpoon:list():select(3)
    end)

    -- Toggle previous & next buffers stored within Harpoon list
    vim.keymap.set('n', '<leader>hn', function()
      harpoon:list():prev()
    end)
    vim.keymap.set('n', '<leader>hp', function()
      harpoon:list():next()
    end)
  end,
}

-- Status line
return {
  'nvim-lualine/lualine.nvim',
  lazy = false,
  dependencies = {
    'arkav/lualine-lsp-progress',
    'nvim-tree/nvim-web-devicons',
  },
  opts = {
    options = {
      section_separators = '',
      component_separators = '',
      globalstatus = true,
      theme = {
        normal = {
          a = 'StatusLine',
          b = 'StatusLine',
          c = 'StatusLine',
        },
      },
    },
    sections = {
      lualine_a = {
        'mode',
      },
      lualine_b = {
        'branch',
        function()
          local clients = vim.lsp.get_clients({ bufnr = 0 })
          local count = #clients
          if count == 0 then
            return '󰅭 0'
          end
          local names = {}
          for _, client in ipairs(clients) do
            table.insert(names, client.name)
          end
          return '󰅭 ' .. count .. ' (' .. table.concat(names, ', ') .. ')'
        end,
        { 'diagnostics', sources = { 'nvim_diagnostic' } },
      },
      lualine_c = {
        'filename'
      },
      lualine_x = {
        {
          require("lazy.status").updates,
          cond = require("lazy.status").has_updates,
          color = { fg = "#ff9e64" },
        },
      },
      lualine_y = {
        'filetype',
        'encoding',
      },
      lualine_z = {
        'searchcount',
        'selectioncount',
        'location',
      },
    },
  },
}

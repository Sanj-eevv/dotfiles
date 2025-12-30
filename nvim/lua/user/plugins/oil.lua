return {
  "stevearc/oil.nvim",
  -- opts = {
  --   build = {
  --     -- vim.keymap.set('n', '-', '<CMD>Oil<CR>', { desc = 'Open a parent directory' })
  --   }
  -- },
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local oil = require("oil")
    oil.setup({
      default_file_explorer = true,
      delete_to_trash = true,
      skip_confirm_for_simple_edits = true,
      view_options = {
        show_hidden = true,
        natural_order = true,
        is_always_hidden = function(name, _)
          return name == ".."
        end,
      },
      float = {
        padding = 2,
        max_width = 90,
        max_height = 0,
      },
      win_options = {
        wrap = true,
        winblend = 0,
      },
      keymaps = {
        ["<C-c>"] = false,
        ["-"] = false,
      },
    })
    vim.keymap.set("n", "-", function()
      local current_dir = oil.get_current_dir()
      local project_root = vim.fn.getcwd()
      if current_dir ~= project_root and current_dir ~= project_root .. "/" then
        oil.open();
      else
        print("Already at project root")
      end
    end, { desc = "Open parent directory" })
  end,
}

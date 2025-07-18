-- Code Formatter
return {
  'stevearc/conform.nvim',
  opts = {
    formatters_by_ft = {
      php = { "pint", lsp_format = "fallback" },
      javascript = { "eslint_d", stop_after_first = true },
      typescript = { "eslint_d", stop_after_first = true },
      typescriptreact = { "eslint_d", stop_after_first = true },
    },
    format_on_save = {
      timeout_ms = 1000,
      lsp_format = "fallback",
    },
    build = {
      vim.keymap.set('n', '<leader>cf', function()
        require('conform').format()
      end, { desc = "Format current file" })
    }
  }
}

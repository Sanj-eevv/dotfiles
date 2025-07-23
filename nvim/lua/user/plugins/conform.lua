-- Code Formatter
return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      '<leader>cf',
      function()
        require('conform').format({ async = true })
      end,
      mode = "",
      desc = "Format current file",
    },
  },
  opts = {
    formatters_by_ft = {
      php = { "pint", "php_cs_fixer", lsp_format = "fallback" },
      javascript = { "eslint_d", stop_after_first = true },
      typescript = { "eslint_d", stop_after_first = true },
      typescriptreact = { "eslint_d", stop_after_first = true },
    },
    formatters = {
      php_cs_fixer = {
        command = "./vendor/bin/php-cs-fixer",
        args = { "fix", "--quiet", "--using-cache=no", "$FILENAME" },
        stdin = false,
        cwd = function(self, ctx)
          local root = vim.fs.find({ "artisan", "package.json" }, { upward = true, path = ctx.filename })[1]
          if root then
            return vim.fs.dirname(root)
          end
          return vim.fn.getcwd()
        end,
        require_cwd = true
      },
    },
    format_on_save = {
      -- timeout_ms = 1000,
      lsp_format = "fallback",
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}

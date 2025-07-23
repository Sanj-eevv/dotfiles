-- Code Formatter
return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  keys = {
    {
      '<leader>cf',
      function()
        local conform = require('conform')
        vim.notify("🔄 Formatting buffer...", vim.log.levels.INFO, { title = "Conform" })
        conform.format({
          async = true,
        }, function(err)
          if err then
            vim.notify("❌ Format failed: " .. tostring(err), vim.log.levels.ERROR, { title = "Conform" })
          else
            vim.notify("✅ Buffer formatted successfully!", vim.log.levels.INFO, { title = "Conform" })
          end
        end)
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
      blade = { "blade_formatter" },
    },
    formatters = {
      blade_formatter = {
        meta = {
          url = "https://github.com/shufo/blade-formatter",
          description = "An opinionated blade template formatter for Laravel that respects readability.",
        },
        command = "blade-formatter",
        args = { "--stdin" },
        stdin = true,
        cwd = function(self, ctx)
          return require("conform.util").root_file({ "composer.json", "composer.lock" })(self, ctx)
        end
      },
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

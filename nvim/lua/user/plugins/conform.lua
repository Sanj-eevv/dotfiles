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
        conform.format({
          async = true,
        })
      end,
      mode = "",
      desc = "Format current file",
    },
  },
  opts = {
    formatters_by_ft = {
      php = { "pint", "php_cs_fixer", lsp_format = "fallback" },
      javascript = { "prettier", "eslint_d", stop_after_first = true },
      typescript = { "prettier", "eslint_d", stop_after_first = true },
      typescriptreact = { "prettier", "eslint_d", stop_after_first = true },
      javascriptreact = { "prettier", "eslint_d", stop_after_first = true },
      vue = { "prettier", "eslint_d", stop_after_first = true },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      blade = { "blade_formatter" },
    },
    formatters = {
      blade_formatter = {
        meta = {
          url = "https://github.com/shufo/blade-formatter",
          description = "An opinionated blade template formatter for Laravel that respects readability.",
        },
        command = "blade-formatter",
        args = {
          "--stdin",
          "--no-multiple-empty-lines",
          "--wrap-attributes-min-attrs=4",
          "--wrap-line-length=220",
          "--wrap-attributes=force-aligned"
        },
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
      prettier = {
        meta = {
          url = "https://prettier.io/",
          description = "An opinionated code formatter that supports many languages.",
        },
        command = "prettier",
        args = { "--stdin-filepath", "$FILENAME" },
        stdin = true,
        cwd = function(self, ctx)
          return require("conform.util").root_file({
            ".prettierrc",
            ".prettierrc.json",
            ".prettierrc.yml",
            ".prettierrc.yaml",
            ".prettierrc.json5",
            ".prettierrc.js",
            ".prettierrc.cjs",
            ".prettierrc.mjs",
            ".prettierrc.toml",
            "prettier.config.js",
            "prettier.config.cjs",
            "prettier.config.mjs",
            "package.json"
          })(self, ctx)
        end,
      },
      eslint_d = {
        meta = {
          url = "https://github.com/mantoni/eslint_d.js/",
          description = "Like ESLint, but faster.",
        },
        command = "eslint_d",
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
        cwd = function(self, ctx)
          return require("conform.util").root_file({
            ".eslintrc.js",
            ".eslintrc.cjs",
            ".eslintrc.yaml",
            ".eslintrc.yml",
            ".eslintrc.json",
            "eslint.config.js",
            "eslint.config.mjs",
            "eslint.config.cjs",
            "package.json"
          })(self, ctx)
        end,
      }
    },
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",
    },
  },
  config = function(_, opts)
    require("conform").setup(opts)
  end,
}

-- Language Server Protocol
return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'b0o/schemastore.nvim',
    'saghen/blink.cmp',
  },
  config = function()
    require('mason').setup({
      PATH = "prepend",
      ui = {
        height = 0.8,
      },
    })
    local capabilities = require('blink.cmp').get_lsp_capabilities()
    require('mason-lspconfig').setup({
      automatic_installation = false,
      ensure_installed = {
        'intelephense',
        'tailwindcss',
        'jsonls',
        'lua_ls',
        'ts_ls',
        'vue_ls',
      },
      handlers = {
        function(server_name)
          require('lspconfig')[server_name].setup({
            capabilities = capabilities,
          })
        end,
        ['ts_ls'] = function()
          require('lspconfig').ts_ls.setup({
            capabilities = capabilities })
        end,
        ['vue_ls'] = function()
          require('lspconfig').vue_ls.setup({
            capabilities = capabilities,
            filetypes = { 'vue' },
            on_init = function(client)
              client.server_capabilities.documentFormattingProvider = false
              client.server_capabilities.documentRangeFormattingProvider = false
              client.server_capabilities.semanticTokensProvider = nil
            end,
          })
        end,
        ['lua_ls'] = function()
          require('lspconfig').lua_ls.setup({
            capabilities = capabilities,
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                  globals = { 'vim' },
                },
                diagnostics = {
                  globals = { 'vim', 'require' },
                  disable = { 'missing-fields' },
                },
                workspace = {
                  checkThirdParty = false,
                  library = vim.api.nvim_get_runtime_file('', true),
                },
                telemetry = {
                  enable = false,
                },
              }
            }
          })
        end,
        ['intelephense'] = function()
          require('lspconfig').intelephense.setup({
            capabilities = capabilities,
          })
        end,

        ['tailwindcss'] = function()
          require('lspconfig').tailwindcss.setup({
            capabilities = capabilities,
            filetypes = { "css", "scss", "sass", "html", "javascript", "javascriptreact", "vue", "svelte" },
          })
        end,

        ['jsonls'] = function()
          require('lspconfig').jsonls.setup({
            capabilities = capabilities,
            settings = {
              json = {
                schemas = require('schemastore').json.schemas(),
                validate = { enable = true },
              },
            },
          })
        end,
      }
    })

    -- PHP
    vim.api.nvim_create_user_command('PhpIndex', function()
      vim.lsp.buf_request(0, 'workspace/executeCommand', {
        command = 'intelephense.index.workspace'
      })
    end, { desc = "Reindex Intelephense workspace" })

    -- Keymaps
    vim.keymap.set('n', '<Leader>d', '<cmd>lua vim.diagnostic.open_float()<CR>')
    vim.keymap.set('n', 'gd', ':Telescope lsp_definitions<CR>')
    vim.keymap.set('n', 'ga', '<cmd>lua vim.lsp.buf.code_action()<CR>')
    vim.keymap.set('n', 'gi', ':Telescope lsp_implementations<CR>')
    vim.keymap.set('n', 'gr', ':Telescope lsp_references<CR>')
    vim.keymap.set('n', '<Leader>lr', ':LspRestart<CR>', { silent = true })
    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>')
    vim.keymap.set('n', '<Leader>rn', '<cmd>lua vim.lsp.buf.rename()<CR>')

    -- Diagnostic configuration
    vim.diagnostic.config({
      virtual_text = true,
      signs = true,
      underline = true,
      update_in_insert = false,
      severity_sort = false,
      float = {
        source = true,
        border = 'rounded',
        header = '',
        prefix = '',
      }
    })
    -- Sign configuration
    vim.fn.sign_define('DiagnosticSignError', { text = '', texthl = 'DiagnosticSignError' })
    vim.fn.sign_define('DiagnosticSignWarn', { text = '', texthl = 'DiagnosticSignWarn' })
    vim.fn.sign_define('DiagnosticSignInfo', { text = '', texthl = 'DiagnosticSignInfo' })
    vim.fn.sign_define('DiagnosticSignHint', { text = '', texthl = 'DiagnosticSignHint' })
  end,
}

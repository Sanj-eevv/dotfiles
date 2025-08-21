-- Language Server Protocol
return {
  'neovim/nvim-lspconfig',
  event = 'VeryLazy',
  dependencies = {
    'williamboman/mason.nvim',
    'williamboman/mason-lspconfig.nvim',
    'b0o/schemastore.nvim',
  },
  config = function()
    require('mason').setup({
      PATH = "prepend",
      ui = {
        height = 0.8,
      },
    })
    require('mason-lspconfig').setup({
      automatic_installation = true,
      ensure_installed = {
        'intelephense',
        'volar',
        'eslint',
        'tailwindcss',
        'jsonls',
        'lua_ls',
      }
    })

    -- Ensure proper file type detection for Vue files
    vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
      pattern = "*.vue",
      command = "set filetype=vue"
    })

    -- PHP
    require('lspconfig').intelephense.setup({})
    vim.api.nvim_create_user_command('IntelephenseIndex', function()
      vim.notify("Starting Intelephense workspace indexing...", vim.log.levels.INFO, { title = "Intelephense" })
      vim.lsp.buf_request(0, 'workspace/executeCommand', {
        command = 'intelephense.index.workspace'
      }, function(err, result)
        if err then
          vim.notify("Indexing failed: " .. tostring(err), vim.log.levels.ERROR, { title = "Intelephense" })
        else
          vim.notify("Workspace indexing completed!", vim.log.levels.INFO, { title = "Intelephense" })
        end
      end)
    end, { desc = "Reindex Intelephense workspace" })

    -- Vue.js (Simple configuration without TypeScript)
    require('lspconfig').volar.setup({
      filetypes = { 'vue' },
      on_attach = function(client, bufnr)
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
      end,
    })

    -- ESLint for JavaScript linting in Vue and JS files
    require('lspconfig').eslint.setup({
      filetypes = { 'javascript', 'javascriptreact', 'vue' },
      on_attach = function(client, bufnr)
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          command = "EslintFixAll",
        })
      end,
    })

    -- Tailwind CSS
    require('lspconfig').tailwindcss.setup({
      filetypes = {
        "css",
        "scss",
        "sass",
        "html",
        "javascript",
        "javascriptreact",
        "vue",
        "svelte",
      },
    })

    -- JSON
    require('lspconfig').jsonls.setup({
      settings = {
        json = {
          schemas = require('schemastore').json.schemas(),
          validate = { enable = true },
        },
      },
    })

    -- Lua
    require('lspconfig').lua_ls.setup({
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
            globals = { 'vim' },
          },
          diagnostics = {
            globals = { 'vim' },
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

    -- LSP handlers configuration
    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
      border = 'rounded',
    })

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
      border = 'rounded',
    })
  end,
}

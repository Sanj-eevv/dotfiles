-- Syntax highlighting
return {
  'nvim-treesitter/nvim-treesitter',
  event = 'VeryLazy',
  build = function()
    require('nvim-treesitter.install').update({ with_sync = true })
  end,
  dependencies = {
    {
      'JoosepAlviste/nvim-ts-context-commentstring',
      opts = {
        languages = {
          php_only = '// %s',
          php = '// %s',
          vue = '// %s',
          javascript = '// %s',
          typescript = '// %s',
        },
        custom_calculation = function(node, language_tree)
          if vim.bo.filetype == 'blade' then
            if language_tree._lang == 'html' then
              return '{{-- %s --}}'
            else
              return '// %s'
            end
          elseif vim.bo.filetype == 'vue' then
            -- Handle different sections in Vue files
            if language_tree._lang == 'html' then
              return '<!-- %s -->'
            elseif language_tree._lang == 'css' then
              return '/* %s */'
            else
              return '// %s'
            end
          end
        end,
      },
    },
    'nvim-treesitter/nvim-treesitter-textobjects',
  },
  main = 'nvim-treesitter.configs',
  opts = {
    ensure_installed = {
      'bash',
      'blade',
      'comment',
      'css',
      'diff',
      'dockerfile',
      'git_config',
      'git_rebase',
      'gitattributes',
      'gitcommit',
      'gitignore',
      'go',
      'html',
      'http',
      'ini',
      'javascript',
      'json',
      'jsonc',
      'lua',
      'make',
      'markdown',
      'passwd',
      'php',
      'php_only',
      'phpdoc',
      'python',
      'regex',
      'ruby',
      'rust',
      'scss', -- Added for Vue style sections
      'sql',
      'svelte',
      'typescript',
      'vim',
      'vue',
      'xml',
      'yaml',
    },
    auto_install = true,
    highlight = {
      enable = true,
      additional_vim_regex_highlighting = false,
    },
    indent = {
      enable = true,
      disable = { "yaml", "python" }
    },
    rainbow = {
      enable = true,
    },
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = '<C-space>',
        node_incremental = '<C-space>',
        scope_incremental = '<C-s>',
        node_decremental = '<C-backspace>',
      },
    },
    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ['if'] = '@function.inner',
          ['af'] = '@function.outer',
          ['ia'] = '@parameter.inner',
          ['aa'] = '@parameter.outer',
          -- Vue-specific textobjects
          ['ic'] = '@class.inner', -- Vue component
          ['ac'] = '@class.outer', -- Vue component
          ['ib'] = '@block.inner', -- template/script/style blocks
          ['ab'] = '@block.outer', -- template/script/style blocks
        },
      },
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          [']m'] = '@function.outer',
          [']]'] = '@class.outer',
        },
        goto_next_end = {
          [']M'] = '@function.outer',
          [']['] = '@class.outer',
        },
        goto_previous_start = {
          ['[m'] = '@function.outer',
          ['[['] = '@class.outer',
        },
        goto_previous_end = {
          ['[M'] = '@function.outer',
          ['[]'] = '@class.outer',
        },
      },
    },
  },
  config = function(_, opts)
    -- Custom parser configurations
    local parser_config = require "nvim-treesitter.parsers".get_parser_configs()

    -- Blade parser configuration
    parser_config.blade = {
      install_info = {
        url = "https://github.com/EmranMR/tree-sitter-blade",
        files = { "src/parser.c" },
        branch = "main",
      },
      filetype = "blade"
    }

    -- File type detection
    vim.filetype.add({
      pattern = {
        ['.*%.blade%.php'] = 'blade',
        ['.*%.vue'] = 'vue',
      },
    })

    -- Blade autocmd group
    local bladeGrp = vim.api.nvim_create_augroup("BladeFiltypeRelated", { clear = true })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      pattern = "*.blade.php",
      group = bladeGrp,
      callback = function()
        vim.opt.filetype = "blade"
      end,
    })

    -- Vue autocmd group
    local vueGrp = vim.api.nvim_create_augroup("VueFiltypeRelated", { clear = true })
    vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
      pattern = "*.vue",
      group = vueGrp,
      callback = function()
        vim.opt.filetype = "vue"
        -- Set up proper commenting for Vue files
        vim.opt_local.commentstring = "// %s"
      end,
    })

    -- Enhanced folding for Vue files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "vue",
      callback = function()
        vim.opt_local.foldmethod = "expr"
        vim.opt_local.foldexpr = "nvim_treesitter#foldexpr()"
        vim.opt_local.foldenable = true
        vim.opt_local.foldlevel = 99
      end,
    })

    -- Setup treesitter
    require('nvim-treesitter.configs').setup(opts)
  end,
}

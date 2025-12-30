-- Fuzzy finder
return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-telescope/telescope-live-grep-args.nvim',
    { 'nvim-telescope/telescope-fzf-native.nvim', build = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release' },
  },
  keys = {
    { '<leader>f',  function() require('telescope.builtin').find_files() end },
    { '<leader>F',  function() require('telescope.builtin').find_files({ no_ignore = true, prompt_title = 'All Files' }) end },
    { '<leader>b',  function() require('telescope.builtin').buffers() end },
    { '<leader>er', function() require('telescope.builtin').oldfiles({ cwd_only = true }) end },
    { '<leader>d',  function() require('telescope.builtin').diagnostics({ bufnr = 0 }) end },
    { '<leader>D',  function() require('telescope.builtin').diagnostics() end },
    { '<leader>/',  function() require('telescope.builtin').current_buffer_fuzzy_find() end },
    { '<leader>;',  function() require('telescope.builtin').resume() end },
    { '<leader>g', function()
      require('telescope').extensions.live_grep_args.live_grep_args({
        prompt_title = 'Grep Project',
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "-L",
          "--color=never",
          "--sort=path",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        }
      })
    end },
    { '<leader>G', function()
      require('telescope').extensions.live_grep_args.live_grep_args({
        prompt_title = 'Grep All Files',
        vimgrep_arguments = {
          "rg",
          "--hidden",
          "--no-ignore",
          "-L",
          "--color=never",
          "--sort=path",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
        },
      })
    end },
    { '<leader>h', function() require('telescope.builtin').help_tags() end },
    { '<leader>s', function() require('telescope.builtin').lsp_document_symbols() end },
  },
  config = function()
    local actions = require('telescope.actions')
    require('telescope').setup({
      defaults = {
        path_display = { truncate = 1 },
        layout_config = {
          prompt_position = 'top',
        },
        preview = {
          filesize_limit = 1,
          timeout = 200,
          msg_bg_fillchar = ' ',
        },
        sorting_strategy = 'ascending',
        mappings = {
          i = {
            ['<esc>'] = actions.close,
          },
        },
        file_ignore_patterns = { '.git/' },
      },
      extensions = {
        live_grep_args = {
          mappings = {
            i = {
              ["<C-k>"] = function(prompt_bufnr)
                local current_picker = require("telescope.actions.state").get_current_picker(prompt_bufnr)
                local prompt = current_picker:_get_prompt()
                if prompt:match('^".*"$') then
                  -- Remove quotes
                  local unquoted = prompt:sub(2, -2)
                  current_picker:set_prompt(unquoted)
                else
                  -- Add quotes
                  current_picker:set_prompt('"' .. prompt .. '"')
                end
              end,
              ["<C-space>"] = actions.to_fuzzy_refine,
              ["<C-i>"] = require("telescope-live-grep-args.actions").quote_prompt({ postfix = " --iglob " }), -- Add glob pattern
            },
          },
        },
      },
      pickers = {
        find_files = {
          hidden = true,
        },
        buffers = {
          previewer = false,
          layout_config = {
            width = 80,
          },
        },
        oldfiles = {
          prompt_title = 'History',
          cwd_only = true,
        },
        lsp_references = {
          previewer = false,
        },
        lsp_definitions = {
          previewer = false,
        },
        lsp_document_symbols = {
          symbol_width = 55,
        },
        resume = {
          prompt_title = "Resume Last Screen"
        }
      },
    })
    require('telescope').load_extension('fzf')
  end,
}

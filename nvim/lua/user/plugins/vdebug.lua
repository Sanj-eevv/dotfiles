return {
    "vim-vdebug/vdebug",
    lazy = true,
    ft = { "php" },
    config = function()
        vim.g.vdebug_options = {
            port = 9003,
            timeout = 20,
            server = '',
            on_close = 'detach',
            break_on_open = 1,
            ide_key = 'NVIM',
            debug_file = '~/vdebug.log',
            debug_file_level = 2,
            watch_window_style = 'expanded',
            path_maps = {} -- You might need to configure this based on your setup
        }
        vim.cmd [[
        let g:vdebug_keymap = {
          \ 'run': '<F5>',
          \ 'run_to_cursor': '<F9>',
          \ 'step_over': '<F2>',
          \ 'step_into': '<F3>',
          \ 'step_out': '<F4>',
          \ 'close': '<F6>',
          \ 'detach': '<F7>',
          \ 'set_breakpoint': '<F10>',
          \ 'get_context': '<F11>',
          \ 'eval_under_cursor': '<F12>'
        \ }
      ]]
    end,
}

-- Close buffers without closing the split window.

return {
  'famiu/bufdelete.nvim',
  config = function ()
    vim.keymap.set('n','<leader>q', ':Bdelete<CR>')
    vim.keymap.set('n', '<leader>Q', ':bufdo Bdelete<CR>')
  end,
}

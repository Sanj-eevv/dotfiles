vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

-- Clear search highlighting.
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Close all open buffers.
vim.keymap.set('n', '<leader>Q', ':bufdo bdelete<CR>')

-- Diagnostics.
vim.keymap.set('n', '[d', function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = 'Go to prev [d]iagnostic' })

vim.keymap.set('n', ']d', function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = 'Go to next [d]iagnostic' })

-- Reselect visual selection after indenting.
vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '>', '>gv')

-- Maintain the cursor position when yanking a visual selection.
vim.keymap.set('v', 'y', 'myy`y')
vim.keymap.set('v', 'Y', 'myY`y')

-- When text is wrapped, move by terminal rows, not lines, unless a count is provided.
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Paste replace visual selection without copying it.
vim.keymap.set('v', 'p', '"_dP')

-- copy file path
vim.keymap.set('n', '<leader>cp', function()
	vim.fn.setreg('+', vim.fn.expand('%:p'))
end, { desc = 'Copy full file path to clipboard' })


-- Open the current file in the default program (on Linux this should just be just `xdg-open`).
vim.keymap.set('n', '<leader>x', ':!open %<cr><cr>')

-- Disable annoying command line thing.
vim.keymap.set('n', 'q:', ':q<CR>')

-- redo
vim.keymap.set('n', 'U', '<C-r>')

-- Fugitive
vim.pack.add { 'https://github.com/tpope/vim-fugitive' }

vim.keymap.set('v', '<leader>vg', '"vy:Ggrep <C-R>v<cr>:copen<cr>', { desc = 'Search with fugitive\'s :Ggrep' })

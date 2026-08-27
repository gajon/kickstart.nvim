--------------------------------------------------
-- PROMOTE A VARIABLE TO RSPEC LET.
-- From https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
local M = {}

function M.promote_to_let()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1
  local line = vim.api.nvim_buf_get_lines(0, row, row + 1, false)[1]

  if line == nil then
    return
  end

  local promoted, replacements = line:gsub('^(%s*)([a-z_][%w_]*)%s*=%s*(.*)$', '%1let(:%2) { %3 }', 1)
  if replacements == 0 then
    return
  end

  vim.api.nvim_buf_set_lines(0, row, row + 1, false, { promoted })
  vim.api.nvim_command 'normal! =='
end

local promote_to_let_mappings = vim.api.nvim_create_augroup('promote_to_let_mappings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = promote_to_let_mappings,
  pattern = 'ruby',
  callback = function(event)
    vim.keymap.set('n', '\\p', M.promote_to_let, {
      buffer = event.buf,
      silent = true,
      desc = 'Promote variable to let',
    })
  end,
})

return M

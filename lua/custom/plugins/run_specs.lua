--------------------------------------------------
-- RUNNING TESTS
-- Adapted from https://github.com/garybernhardt/dotfiles/blob/master/.vimrc
local M = {}
local uv = vim.uv or vim.loop

local function file_readable(path)
  local stat = uv.fs_stat(path)
  return stat ~= nil and stat.type == 'file'
end

local function should_use_dox_do()
  return vim.env.DOX_DC_CONTAINER_HOST == 'local'
    or (vim.env.DOX_CLOUD_PERSONAL_INSTANCE ~= nil and vim.env.DOX_CLOUD_PERSONAL_INSTANCE ~= '')
end

local function append_args(args, additions)
  for _, arg in ipairs(additions) do
    table.insert(args, arg)
  end

  return args
end

local function shell_join(command)
  return table.concat(vim.tbl_map(vim.fn.shellescape, command), ' ')
end

local function display_join(command)
  return table.concat(command, ' ')
end

local function current_file()
  local filename = vim.api.nvim_buf_get_name(0)
  if filename == '' then
    return ''
  end

  local cwd = uv.cwd()
  if cwd ~= nil and vim.fs ~= nil and vim.fs.relpath ~= nil then
    local relative = vim.fs.relpath(cwd, filename)
    if relative ~= nil then
      return relative
    end
  end

  return filename
end

local function open_terminal_split(command)
  vim.api.nvim_command 'split'

  local buf = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_win_set_buf(0, buf)
  vim.api.nvim_set_option_value('bufhidden', 'wipe', { buf = buf })

  local command_line = shell_join(command)
  local display_line = display_join(command)
  local terminal_command = string.format("printf '%%s\\n\\n' %s; %s", vim.fn.shellescape('$ ' .. display_line), command_line)
  local job_id = vim.fn.termopen(terminal_command)
  if job_id <= 0 then
    vim.notify('Failed to start test command', vim.log.levels.ERROR)
    return
  end
end

function M.set_test_file()
  vim.t.grb_test_file = current_file()
end

function M.run_tests(filename)
  vim.api.nvim_command 'wall'

  if filename:match '%.feature$' then
    open_terminal_split { 'script/features', filename }
    return
  end

  local dox_do = should_use_dox_do() and { 'dox-do' } or {}
  local command

  if file_readable 'script/test' then
    command = append_args(vim.deepcopy(dox_do), { 'script/test', filename })
  elseif file_readable 'bin/rspec' then
    command = append_args({ 'time' }, dox_do)
    command = append_args(command, { './bin/rspec', filename })
  elseif file_readable 'Gemfile' then
    command = append_args({ 'time' }, dox_do)
    command = append_args(command, { 'bundle', 'exec', 'rspec', filename })
  else
    command = append_args({ 'time' }, dox_do)
    command = append_args(command, { 'rspec', filename })
  end

  open_terminal_split(command)
end

function M.run_test_file(command_suffix)
  command_suffix = command_suffix or ''

  local filename = current_file()
  local in_test_file = filename:match '%.feature$' ~= nil or filename:match '_spec%.rb$' ~= nil

  if in_test_file then
    M.set_test_file()
  elseif vim.t.grb_test_file == nil then
    return
  end

  M.run_tests(vim.t.grb_test_file .. command_suffix)
end

function M.run_nearest_test()
  local spec_line_number = vim.api.nvim_win_get_cursor(0)[1]
  M.run_test_file(':' .. spec_line_number)
end

--------------------------------------------------
-- The commands for ruby files
local ruby_custom_mappings = vim.api.nvim_create_augroup('ruby_custom_mappings', { clear = true })

vim.api.nvim_create_autocmd('FileType', {
  group = ruby_custom_mappings,
  pattern = 'ruby',
  callback = function(event)
    local function ruby_map(lhs, rhs, desc)
      vim.keymap.set('n', lhs, rhs, { buffer = event.buf, silent = true, desc = desc })
    end

    ruby_map('\\t', M.run_test_file, 'Run test file')
    ruby_map('\\T', M.run_nearest_test, 'Run nearest test')
  end,
})

return M

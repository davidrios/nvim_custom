local autocmd = vim.api.nvim_create_autocmd
local config_group = vim.api.nvim_create_augroup('MyInit', {})

-- load .nvimrcj json into global variable nvimrcj
local fd = io.open(vim.loop.cwd() .. '/.nvim/config.json', 'r')
if fd then
  vim.g.nvimrcj = vim.json.decode(fd:read("a"))
  fd:close()
else
  vim.g.nvimrcj = {}
end

vim.o.clipboard = ''

autocmd({ 'User' }, {
  pattern = "SessionLoadPost",
  group = config_group,
  callback = function()
  end,
})

-- Auto resize panes when resizing nvim window
-- autocmd("VimResized", {
--   pattern = "*",
--   command = "tabdo wincmd =",
-- })

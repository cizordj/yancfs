vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
local map = vim.api.nvim_buf_set_keymap
local options = { noremap = true }
vim.cmd("packadd")
map(0, 'n', '<leader>u', ':call phpactor#UseAdd()<cr>', options)
map(0, 'n', '<leader>mm', ':call phpactor#ContextMenu()<cr>', options)
map(0, 'n', '<leader>nc', ':call phpactor#ClassNew()<cr>', options)

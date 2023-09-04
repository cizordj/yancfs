vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.api.nvim_set_var('php_folding', true)
vim.wo.foldlevel = 1
vim.bo.expandtab = true
local map = vim.api.nvim_buf_set_keymap
local options = { noremap = true }
if nil == package.loaded["phpactor"] then
  vim.cmd("packadd phpactor")
end
map(0, 'n', '<leader>u', ':call phpactor#UseAdd()<cr>', options)
map(0, 'n', '<leader>mm', ':call phpactor#ContextMenu()<cr>', options)
map(0, 'n', '<leader>nc', ':call phpactor#ClassNew()<cr>', options)
map(0, 'n', '<leader>ov', ':call phpactor#GotoDefinition("vsplit")<cr>', options)
map(0, 'n', '<leader>oh', ':call phpactor#GotoDefinition("split")<cr>', options)

-- Add phpactor to path in order to run arbitrary commands
local initPath = require('caesar.functions').initpath {}
local phpactorPath = initPath .. '/' .. './pack/plugins/opt/phpactor/bin'
local has_been_added = vim.env.PATH:find(phpactorPath, 0, true) ~= nil
if false == has_been_added then
  vim.env.PATH = vim.env.PATH .. ':' .. phpactorPath
end

-- Add the project's path if the folder exists
local vendorDirectory = vim.env.PWD .. '/vendor/bin'
local vendorExists = vim.env.PATH:find(vendorDirectory, 0, true) ~= nil
if false == vendorExists then
  vim.env.PATH = vim.env.PATH .. ':' .. vendorDirectory
end

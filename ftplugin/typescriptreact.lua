vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

-- local node_binaries_path = vim.fn.getcwd() .. '/node_modules/.bin'
-- local has_been_added = string.find(vim.env.PATH, node_binaries_path)
-- if 1 == vim.fn.isdirectory(node_binaries_path) and nil == has_been_added then
--     vim.notify('Configurei o diretório')
--     vim.env.PATH = vim.env.PATH .. ':' .. node_binaries_path
-- end
if nil == package.loaded["nvim-autopairs"] then
  vim.cmd("packadd nvim-autopairs")
  require("nvim-autopairs").setup {}
end

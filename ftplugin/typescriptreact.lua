vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

local node_binaries_path = vim.fn.getcwd() .. '/node_modules/.bin/'
if vim.fn.isdirectory(node_binaries_path) then
    vim.env.PATH = vim.env.PATH .. ':' .. node_binaries_path
end

require('lspconfig')['tsserver'].setup {
    on_attach = require('caesar.functions')['onAttach'],
    flags = {
        debounce_text_changes = 150,
    },
}

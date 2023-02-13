vim.bo.shiftwidth = 2
vim.bo.tabstop = 2
vim.bo.expandtab = true

require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
}

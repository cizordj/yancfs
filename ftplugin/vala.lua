vim.bo.shiftwidth = 4
vim.bo.tabstop = 4
vim.bo.expandtab = true
if nil == package.loaded["vala.vim"] then
  vim.cmd("packadd vala.vim")
end

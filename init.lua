-- mouse integration
vim.g.mouse = 'n'
-- dictionary completion
vim.o.dictionary = "/usr/share/dict/brazilian,/usr/share/dict/american-english"

-- colorscheme stuff
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_contrast_light = 'hard'
vim.g.gruvbox_italic = 1
vim.api.nvim_set_option('termguicolors', true)
vim.cmd("colorscheme gruvbox")

-- plugins configuration
require("nvim-tree").setup({
  sort_by = "case_sensitive",
  view = {
    adaptive_size = true,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})

-- keybingings
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>NvimTreeToggle<CR>', { noremap = true, desc = "Open up the file manager"})
vim.api.nvim_set_keymap('n', '<F2>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true, desc = "See the current file in the file manager"})

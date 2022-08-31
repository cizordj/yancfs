-- mouse integration
vim.g.mouse = 'n'
-- dictionary completion
vim.o.dictionary = "/usr/share/dict/brazilian,/usr/share/dict/american-english"
-- show line numbers
vim.o.number = true

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

-- keybingings >>>
vim.g.mapleader = ','

-- window navigation
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>vsplit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', '<cmd>split<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-Up>', '<cmd>resize -1<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-Down>', '<cmd>resize +1<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-Left>', '<cmd>vertical resize -1<CR>', { noremap = true})
vim.api.nvim_set_keymap('n', '<C-Right>', '<cmd>vertical resize +1<CR>', { noremap = true})
-- code manipulation
vim.api.nvim_set_keymap('x', 'K', ":move '<-2<CR>gv-gv", { noremap = true})
vim.api.nvim_set_keymap('x', 'J', ":move '>+1<CR>gv-gv", { noremap = true})
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true})
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true})

vim.api.nvim_set_keymap('n', '<F2>', '<cmd>NvimTreeFindFileToggle<CR>', { noremap = true, desc = "See the current file in the file manager"})
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>NvimTreeToggle<CR>', { noremap = true, desc = "Open up the file manager"})
vim.api.nvim_set_keymap('n', '<F4>', '<cmd>TagbarToggle<CR>', { noremap = true, desc = "Open up the tagbar"})
-- <<< keybindings

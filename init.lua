-- vim:foldmethod=marker

-- Global options {{{
-- mouse integration
vim.g.mouse = 'n'
-- dictionary completion
vim.o.dictionary = "/usr/share/dict/brazilian,/usr/share/dict/american-english"
-- show line numbers
vim.o.number = true
vim.o.background = "light"

-- colorscheme stuff
vim.g.gruvbox_contrast_dark = 'hard'
vim.g.gruvbox_contrast_light = 'hard'
vim.g.gruvbox_italic = 1
vim.api.nvim_set_option('termguicolors', true)
vim.cmd("colorscheme moonfly")
require("caesar/commands")

-- }}}

-- Plugins setups {{{
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
    git = {
        ignore = false,
    },
})
require('gitsigns').setup()
require("nvim-treesitter.configs").setup({
    ensure_installed = { "lua", "php", "javascript", "json" },
    auto_install = true,
    highlight = {
        enable = true
    }
})
require('lualine').setup({
    options = {
        theme = 'auto',
        disabled_filetypes = {
            statusline = { "NvimTree" },
        }
    },
    tabline = {
        lualine_a = { 'buffers' },
        lualine_z = { 'tabs' },
    }
})
-- }}}

-- Lsp configs {{{
local lsp_flags = {
    debounce_text_changes = 150,
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, bufopts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, bufopts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, bufopts)
    vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, bufopts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    vim.keymap.set('n', '<leader>wl', function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, bufopts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, bufopts)
    vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    vim.keymap.set('n', 'gr', vim.lsp.buf.references, bufopts)
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.formatting, bufopts)
end

-- Mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
local opts = { noremap = true, silent = true }
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, opts)

require('lspconfig')['phpactor'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { vim.env.HOME .. "/.config/nvim/pack/plugins/opt/phpactor/bin/phpactor", "language-server" }
}
require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
}
require('lspconfig')['sumneko_lua'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    settings = {
        Lua = {
            diagnostics = {
                globals = { "vim" }
            }
        }
    },
    workspace = {
        library = vim.api.nvim_get_runtime_file("", true),
    },
    telemetry = {
        enable = false,
    }
}

require("null-ls").setup({
    sources = {
        require("null-ls").builtins.formatting.stylua,
        require("null-ls").builtins.formatting.prettier,
        require("null-ls").builtins.formatting.phpcsfixer,
    },
})
-- }}}

-- Keybindings {{{
vim.g.mapleader = ','

-- window navigation
vim.api.nvim_set_keymap('n', '<leader>v', '<cmd>vsplit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>h', '<cmd>split<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Up>', '<cmd>resize -1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<cmd>resize +1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<cmd>vertical resize -1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<cmd>vertical resize +1<CR>', { noremap = true })
-- buffer navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>bp<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>bn<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>q', '<cmd>bp<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', '<cmd>bn<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>bd<cr>', { noremap = true })

-- code manipulation
vim.api.nvim_set_keymap('x', 'K', ":move '<-2<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('x', 'J', ":move '>+1<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

vim.api.nvim_set_keymap('n', '<F2>', '<cmd>NvimTreeFindFileToggle<CR>',
    { noremap = true, desc = "See the current file in the file manager" })
vim.api.nvim_set_keymap('n', '<F3>', '<cmd>NvimTreeToggle<CR>', { noremap = true, desc = "Open up the file manager" })
vim.api.nvim_set_keymap('n', '<F4>', '<cmd>TagbarToggle<CR>', { noremap = true, desc = "Open up the tagbar" })

-- telescope
vim.api.nvim_set_keymap('n', '<leader>ff', '<cmd>Telescope find_files<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>fb', '<cmd>Telescope buffers<cr>', { noremap = true })

-- git integration
vim.api.nvim_set_keymap('n', '<leader>ga', "<cmd>Gitsigns stage_buffer<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gs', "<cmd>Gitsigns stage_hunk<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gd', "<cmd>Gitsigns diffthis<cr>", { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>gl', "<cmd>Gitsigns blame_line<cr>", { noremap = true })

-- }}}

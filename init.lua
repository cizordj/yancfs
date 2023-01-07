-- vim:foldmethod=marker

-- Global options {{{
-- mouse integration
vim.g.mouse = 'n'
-- dictionary completion
vim.o.dictionary = "/usr/share/dict/brazilian,/usr/share/dict/american-english"
-- show line numbers
vim.o.number = true
vim.o.background = "dark"
vim.o.timeoutlen = 300

-- colorscheme stuff
vim.g.guifont = "Fira Code Sans"
vim.api.nvim_set_option('termguicolors', true)
vim.cmd("colorscheme gruvbox")
require("caesar/commands")
local notify = require("notify")
vim.notify = notify
notify.setup({
    fps = 60,
    top_down = false
})

-- DBUI config
vim.g.db_ui_user_nerd_fonts = true
vim.g.db_ui_auto_execute_table_helpers = true
vim.g.db_ui_win_position = 'right'
vim.g.db_ui_show_database_icon = 1
local scriptpath = require('caesar.functions').scriptpath {}

-- Neovide
if (vim.g.neovide)
then
    require('caesar.functions').setupNeovide {}
end
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
require('gitsigns').setup({
    on_attach = function()
        local gitsigns = require('gitsigns.actions')
        vim.keymap.set('n', '<leader>ga', gitsigns.stage_buffer, { noremap = true })
        vim.keymap.set('n', '<leader>gs', gitsigns.stage_hunk, { noremap = true })
        vim.keymap.set('n', '<leader>gd', gitsigns.diffthis, { noremap = true })
        vim.keymap.set('n', '<leader>gl', gitsigns.blame_line, { noremap = true })
    end
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

---Use an on_attach function to only map the following keys
---after the language server attaches to the current buffer
---@param _ any
---@param bufnr number
local on_attach = function(_, bufnr)
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
    vim.keymap.set('n', '<leader>f', vim.lsp.buf.format, bufopts)
    vim.keymap.set('n', '<leader>q', function()
        vim.diagnostic.open_float({
            bufnr = bufnr,
            scope = "buffer"
        })
    end, bufopts)
end

local lsp_flags = {
    debounce_text_changes = 150,
}
require('lspconfig')['phpactor'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { scriptpath .. "pack/plugins/opt/phpactor/bin/phpactor", "language-server" }
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
require('lspconfig')['tailwindcss'].setup {
    cmd = { scriptpath .. "node_modules/.bin/tailwindcss-language-server", "--stdio" },
    on_attach = on_attach,
    filetypes = {
        "typescriptreact", "typescript"
    }
}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            command = { scriptpath .. "node_modules/.bin/prettier" },
            extra_filetypes = { "php", "html" }
        }),
        null_ls.builtins.diagnostics.phpstan.with({
            command = { scriptpath .. "vendor/bin/phpstan" },
            extra_args = { "--level=9" }
        })
    }
})
null_ls = nil

require('lspconfig')['sqls'].setup({
    cmd = { "sqls", "-config", "~/.config/sqls/config.yml" }
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
vim.api.nvim_set_keymap('n', '<leader>c', '<cmd>bd<cr>', { noremap = true })

-- code manipulation
vim.api.nvim_set_keymap('x', 'K', ":move '<-2<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('x', 'J', ":move '>+1<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

local nvim_tree = require('nvim-tree.api').tree
vim.keymap.set('n', '<F2>', function() nvim_tree.toggle(true) end,
    { noremap = true, desc = "See the current file in the file manager" })
vim.keymap.set('n', '<F3>', nvim_tree.toggle, { noremap = true, desc = "Open up the file manager" })

vim.api.nvim_set_keymap('n', '<F4>', '<cmd>TagbarToggle<CR>', { noremap = true, desc = "Open up the tagbar" })
vim.keymap.set('n', '<F5>', require('caesar.functions').loadUpDadbod,
    { noremap = false, desc = "Load up the database viewer" })

-- telescope
local telescope = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', telescope.find_files, { noremap = true })
vim.keymap.set('n', '<leader>fg', telescope.live_grep, { noremap = true })
vim.keymap.set('n', '<leader>fb', telescope.buffers, { noremap = true })

-- open this own configuration file
vim.api.nvim_set_keymap('n', '<leader>Lc', "<cmd>e " .. scriptpath .. 'init.lua<cr>',
    { noremap = true, desc = "Configuration file" })

-- copy to system clipboard
vim.keymap.set(
    'v',
    '<C-y>',
    '"+y',
    { noremap = true, desc = "Copy to system clipboard" }
)

-- }}}

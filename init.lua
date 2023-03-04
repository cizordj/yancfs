-- vim:foldmethod=marker

-- Global options {{{
vim.cmd("helptags ALL")
-- mouse integration
vim.g.mouse = 'n'
-- show line numbers
vim.o.number = true
vim.o.timeoutlen = 300

-- colorscheme stuff
vim.g.guifont = "JetBrains Mono"
vim.api.nvim_set_option('termguicolors', true)
-- vim.cmd("highlight DiagnosticFloatingError ctermfg=white")
vim.cmd("colorscheme kanagawa")

-- notifications
local notify = require("notify")
vim.notify = notify
notify.setup({
    fps = 60,
    top_down = false,
    background_colour = "#eeeeee"
})

-- DBUI config
vim.g.db_ui_user_nerd_fonts = true
vim.g.db_ui_auto_execute_table_helpers = true
vim.g.db_ui_win_position = 'right'
vim.g.db_ui_show_database_icon = 1
local scriptpath = require('caesar.functions').initpath {}

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

local on_attach = require('caesar.functions')['onAttach']

local lsp_flags = {
    debounce_text_changes = 150,
}
require('lspconfig')['phpactor'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    cmd = { scriptpath .. "/pack/plugins/opt/phpactor/bin/phpactor", "language-server" }
}
require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150,
    },
}
require('lspconfig')['eslint'].setup {
    flags = lsp_flags,
    on_attach = on_attach
}
require('lspconfig')['lua_ls'].setup {
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
    on_attach = on_attach,
    filetypes = {
        "typescriptreact", "typescript"
    }
}

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            command = { scriptpath .. "/node_modules/.bin/prettier" },
            extra_filetypes = { "php", "html", "markdown" }
        }),
        null_ls.builtins.diagnostics.phpstan.with({
            command = { scriptpath .. "/vendor/bin/phpstan" },
            extra_args = { "--level=9" }
        }),
    },
    debounce = 300,
    temp_dir = vim.go.directory
})
null_ls = nil
-- }}}

-- Keybindings {{{
vim.g.mapleader = ','

-- window navigation
vim.api.nvim_set_keymap('n', '<C-Up>', '<cmd>resize -1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Down>', '<cmd>resize +1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Left>', '<cmd>vertical resize -1<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-Right>', '<cmd>vertical resize +1<CR>', { noremap = true })
-- buffer navigation
vim.api.nvim_set_keymap('n', '<C-h>', '<cmd>bp<cr>', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<cmd>bn<cr>', { noremap = true })

-- code manipulation
vim.api.nvim_set_keymap('x', 'K', ":move '<-2<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('x', 'J', ":move '>+1<CR>gv-gv", { noremap = true })
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- getting out of insert mode
vim.api.nvim_set_keymap('i', 'jj', '<ESC>', { noremap = true })

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
vim.api.nvim_set_keymap('n', '<leader>Lc', "<cmd>e " .. scriptpath .. '/init.lua<cr>',
    { noremap = true, desc = "Configuration file" })

-- copy to system clipboard
vim.keymap.set(
    'v',
    '<C-y>',
    '"+y',
    { noremap = true, desc = "Copy to system clipboard" }
)

-- }}}

-- Command {{{
local create_command = vim.api.nvim_create_user_command

create_command(
    "ClearCache",
    ":!docker compose exec --user www-data -T php php bin/console cache:clear",
    {}
)
create_command(
    "DeleteFile",
    ":call delete(expand('%')) | bdelete!",
    {}
)
create_command(
    "DeleteFile",
    ":call delete(expand('%')) | bdelete!",
    {}
)
create_command(
    "FixWhitespace",
    [[:%s/\s\+$//e]],
    {}
)
create_command(
    "GAmmend",
    ":Git commit --amend --verbose",
    {}
)
create_command(
    "GimmePermission",
    require('caesar.functions').gimmePermission,
    {}
)
create_command(
    "GCommit",
    ":Git commit --verbose",
    {}
)
create_command(
    "JsonPrettify",
    [[:%!jq '.']],
    {}
)
create_command(
    "JsonUglify",
    [[:%!jq --compact-output '.']],
    {}
)
create_command(
    "MakeItFast",
    [[:!xset r rate 200 40]],
    {}
)
create_command(
    "PgFormat",
    [[:%!pg_format -B -g -L -b -e -]],
    {}
)
create_command(
    "RebaseCurrentBranch",
    require('caesar.functions').rebaseCurrentBranch,
    {}
)
create_command(
    "ReviseCode",
    ":Git diff develop HEAD",
    {}
)
create_command(
    "SortByLength",
    [[:'<,'>!awk '{ print length(), $0 | "sort -n | cut -d\\  -f2-" }']],
    {
        range = true
    }
)
-- No one is really happy until you have these shortcuts
vim.cmd(":abbreviate W! w!")
vim.cmd(":abbreviate W w")
vim.cmd(":abbreviate WQ wq")
vim.cmd(":abbreviate WQ! wq!")
vim.cmd(":abbreviate Wq wq")
-- }}}

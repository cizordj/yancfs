-- vim:foldmethod=marker

-- Global options {{{
vim.cmd("helptags ALL")
-- mouse integration
vim.o.mouse = nil
-- show line numbers
vim.o.number = true
vim.o.timeoutlen = 300
-- Remove the annoying preview window
vim.o.completeopt = 'menu'

-- colorscheme stuff
vim.g.guifont = "JetBrains Mono"
vim.api.nvim_set_option('termguicolors', true)
-- vim.cmd("highlight DiagnosticFloatingError ctermfg=white")
vim.cmd("packadd kanagawa.nvim")
vim.cmd("colorscheme elflord")

-- notifications
local notify = require("notify")
vim.notify = notify
notify.setup({
    fps = 10,
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
local lsp_flags = {
    debounce_text_changes = 150,
}

vim.api.nvim_create_autocmd('LspAttach', {
  ---Use an on_attach function to only map the following keys
  ---after the language server attaches to the current buffer
  callback = function(args)
    local bufnr = args.buf
    -- Avoid running the attach function multiple times
    -- when the buffer has multiple LSPs
    local ok, value = pcall(vim.api.nvim_buf_get_var, bufnr, 'has_run_the_attach')
    if ok == true then
      if value then
        vim.notify(string.format('Buffer %d has attached already', bufnr), vim.log.levels.DEBUG)
        return
      end
    else
      vim.api.nvim_buf_set_var(bufnr, 'has_run_the_attach', false)
    end

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
    vim.keymap.set(
      'n',
      '<leader>f',
      function()
        vim.lsp.buf.format({ timeout_ms = 4000 })
      end,
      bufopts
    )
    vim.keymap.set('n', '<leader>q', function()
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "line"
      })
    end, bufopts)
    vim.keymap.set('n', '<leader>Q', function()
      vim.diagnostic.open_float({
        bufnr = bufnr,
        scope = "buffer"
      })
    end, bufopts)
    vim.notify(
      string.format(
        'Buffer %d has been successfully configured!',
        bufnr
      ),
      vim.log.levels.DEBUG
    )
    vim.api.nvim_buf_set_var(bufnr, 'has_run_the_attach', true)
  end
})

require('lspconfig')['vala_ls'].setup {
    flags = lsp_flags,
}
require('lspconfig')['phpactor'].setup {
    flags = lsp_flags,
    cmd = {
      scriptpath .. '/' .. './bin/phpactor-wrapper.sh'
    }
}
require('lspconfig')['tsserver'].setup {
    flags = {
        debounce_text_changes = 150,
    },
    cmd = {
      scriptpath .. '/' .. './bin/tsserver-wrapper.sh'
    }
}
require('lspconfig')['eslint'].setup {
    flags = lsp_flags,
}
require('lspconfig')['lua_ls'].setup {
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
    filetypes = {
        "typescriptreact", "typescript"
    }
}
-- }}}

-- NullLs {{{

local null_ls = require("null-ls")
null_ls.setup({
    sources = {
        null_ls.builtins.formatting.prettier.with({
            command = { scriptpath .. "/node_modules/.bin/prettier" },
            extra_filetypes = { "php", "html" },
            disabled_filetypes = { "markdown" }
        }),
        null_ls.builtins.diagnostics.shellcheck,
        null_ls.builtins.diagnostics.phpcs,
        null_ls.builtins.code_actions.shellcheck,
        null_ls.builtins.diagnostics.php.with({
            command = {
              'docker',
              'compose',
            },
            args = {
              'run',
              '--rm',
              '-u',
              '1000',
              'php',
              'php',
              '-l',
              '-d',
              'display_errors=STDERR',
              '-d',
              ' log_errors=Off'
            }
        })
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
    "SetupGitubIdentity",
    require('caesar.functions').setupGithubIdentity,
    {}
)
create_command(
    "SetupSenaiIdentity",
    require('caesar.functions').setupSenaiIdentity,
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
-- }}}

-- Shortcuts {{{
-- No one is really happy until you have these shortcuts
vim.cmd(":abbreviate W! w!")
vim.cmd(":abbreviate W w")
vim.cmd(":abbreviate WQ wq")
vim.cmd(":abbreviate WQ! wq!")
vim.cmd(":abbreviate Wq wq")
-- }}}

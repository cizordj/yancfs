local M = {}

function M:rebaseCurrentBranch()
  local currentBranch = vim.api.nvim_exec("Git rev-parse --abbrev-ref HEAD", true)
  local weAreOnGitFlow = string.match(currentBranch, [[^feature/.*]])
  if not weAreOnGitFlow then
    return
  end
  local numberOfCommits = vim.api.nvim_exec("Git rev-list --count HEAD ^develop", true)
  local command = "Git rebase -i HEAD~" .. numberOfCommits
  return vim.api.nvim_command(command)
end

---@return nil
function M:preWriteSenaiCommitMessage()
  local currentBranch = vim.api.nvim_exec("Git rev-parse --abbrev-ref HEAD", true)
  local weAreOnGitFlow = string.match(currentBranch, [[^feature/.*]])
  if not weAreOnGitFlow then
    return
  end
  local firstLine = vim.fn.getline(1)
  local lineLength = vim.fn.strlen(firstLine)
  if lineLength > 0 then
    return
  end
  local branchName = string.gsub(currentBranch, [[^feature/]], '')
  vim.cmd("norm gg04j5wywggI[" .. branchName .. "]")
end

---@return nil
function M:gimmePermission()
  vim.api.nvim_exec([[!doas chown "$(id -u)" %]], false)
  vim.api.nvim_exec([[!doas chmod +rw "$(id -u)" %]], false)
end

---@return nil
function M:loadUpDadbod()
  vim.cmd("packadd vim-dadbod.git")
  vim.cmd("packadd vim-dadbod-ui")
  vim.api.nvim_set_keymap('n', '<F5>', "<cmd>DBUIToggle<cr>", { noremap = true, desc = "Open up the database viewer" })
  vim.cmd("DBUIToggle")
end

---@return string
---Returns the path to the init.lua file
function M:initLuaPath()
  return string.gsub(vim.api.nvim_get_runtime_file("init.lua", false)[1], "init.lua", "", 1)
end

---@return nil
function M:setupNeovide()
  local cursor_particles = {
      "railgun",
      "torpedo",
      "pixiedust",
      "sonicboom",
      "ripple",
      "wireframe"
  }
  vim.g.guifont = "JetBrains Mono:h14"
  local i = math.random(0, #(cursor_particles) - 1)
  -- vim.g.neovide_cursor_vfx_mode = cursor_particles[i];
  vim.cmd('let g:neovide_cursor_vfx_mode = "' .. cursor_particles[i] .. '"')
  vim.keymap.set(
      'n',
      '<C-S-PageUp>',
      function()
        vim.g.neovide_scale_factor =
            vim.g.neovide_scale_factor + 0.1
      end
  )
  vim.keymap.set(
      'n',
      '<C-S-PageDown>',
      function()
        vim.g.neovide_scale_factor =
            vim.g.neovide_scale_factor - 0.1
      end
  )
  vim.keymap.set(
      'n',
      '<C-S-Home>',
      function()
        vim.g.neovide_scale_factor = 1
      end
  )
  vim.keymap.set(
      { 'c', 'i' },
      '<C-S-v>',
      '<C-R>+'
  )
end

---Use an on_attach function to only map the following keys
---after the language server attaches to the current buffer
---@param bufnr number
function M:onAttach(bufnr)
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
end

return M

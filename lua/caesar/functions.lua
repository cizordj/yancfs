local M = {}

function M:rebaseCurrentBranch()
  local currentBranch = vim.api.nvim_exec("Git rev-parse --abbrev-ref HEAD", true)
  local weAreOnGitFlow = string.match(currentBranch, [[^feature/.*]])
  if not weAreOnGitFlow then
    return
  end
  local numberOfCommits = vim.api.nvim_exec("Git rev-list --count HEAD ^develop", true)
  local command = "Git rebase -i HEAD~"..numberOfCommits
  return vim.api.nvim_command(command)
end

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
  vim.cmd("norm gg04j5wywggI["..branchName.."]")
end

function M:gimmePermission()
  vim.api.nvim_exec([[!doas chown "$(id -u)" %]], false)
  vim.api.nvim_exec([[!doas chmod +rw "$(id -u)" %]], false)
end

function M:loadUpDadbod()
  vim.cmd("packadd vim-dadbod.git")
  vim.cmd("packadd vim-dadbod-ui")
  vim.api.nvim_set_keymap('n', '<F5>', "<cmd>DBUIToggle<cr>", { noremap = true, desc = "Open up the database viewer"})
  vim.cmd("DBUIToggle")
end

function M:scriptpath()
  local str = debug.getinfo(2, "S").source:sub(2)
  return str:match("(.*/)")
end

return M

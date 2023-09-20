local M = {}

---Rebase the current git branch interactively using the
---“develop” branch as an entry point. This is especially
---useful if you follow the git-flow model and want to squash
---your changes before the next release.
---This function won't do anything if it detects that you're
---not in a git-flow feature branch.
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

---This is a little vim macro that pre writes the commit message
---according to Senai's policy.
---The main rule is that the messages must have the task number
---inside brackets which is usually the branch name as well.
---The task number is extracted from the git branch and then put in
---the commit message automatically so you won't need to do
---that repetitive task every time you make a commit.
---This function won't do anything if it detects that you're
---not in a git-flow feature branch.
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

---Gives you permission to read and write the currently opened
---file using the “doas” command-line utility as root
---authentication.
---@return nil
function M:gimmePermission()
  vim.api.nvim_exec([[!doas chown "$(id -u)" %]], false)
  vim.api.nvim_exec([[!doas chmod +rw "$(id -u)" %]], false)
end

---@return nil
function M:loadUpDadbod()
  vim.cmd("packadd vim-dadbod.git")
  vim.cmd("packadd vim-dadbod-ui")
  vim.cmd("packadd vim-dadbod-completion")
  vim.api.nvim_set_keymap('n', '<F5>', "<cmd>DBUIToggle<cr>", { noremap = true, desc = "Open up the database viewer" })
  vim.cmd("helptags ALL")
  vim.cmd("DBUIToggle")
end

---@return string
---Returns the path to the init.lua file
function M:initpath()
  return vim.fs.dirname(vim.api.nvim_get_runtime_file("init.lua", false)[1])
end

---@return nil
function M:setupNeovide()
  if vim.o.background == 'dark' then 
    vim.cmd("highlight Normal guibg=#000000")
  else
    vim.cmd("highlight Normal guibg=#ffffff")
  end
  local cursor_particles = {
      "railgun",
      "torpedo",
      "pixiedust",
      "sonicboom",
      "ripple",
      "wireframe"
  }
  vim.o.guifont = "JetBrainsMono Nerd Font:h20"
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

---Makes the current git project use my identity
---from github, which includes username, email,
---gpg key and so on.
function M:setupGithubIdentity()
  vim.cmd("Git config user.name cizordj")
  vim.cmd('Git config user.email "32869222+cizordj@users.noreply.github.com"')
  vim.cmd("Git config user.signingKey 16DC13CE15C3BA0053383E689466E26E3D20204C")
  vim.cmd("Git config commit.verbose true")
  vim.cmd("Git config commit.gpgSign true")
end

---Makes the current git project use my identity
---from senai, which includes username, email,
---gpg key and so on.
function M:setupSenaiIdentity()
  vim.cmd('Git config user.name "Cézar Augusto de Campos"')
  vim.cmd('Git config user.email "cezar.campos@sc.senai.br"')
  vim.cmd("Git config user.signingKey 16DC13CE15C3BA0053383E689466E26E3D20204C")
  vim.cmd("Git config commit.verbose true")
  vim.cmd("Git config commit.gpgSign true")
end

return M

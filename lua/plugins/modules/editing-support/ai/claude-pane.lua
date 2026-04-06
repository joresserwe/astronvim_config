-- 외부 터미널 pane에서 Claude CLI 직접 실행 (wezterm > tmux)
-- claudecode.nvim과 별도로, 터미널 기반 워크플로우를 보조적으로 유지한다.
-- nvim 종료 시 생성된 pane을 자동으로 정리한다.
local M = {}

---@type string[]
local pane_ids = {}

-- 현재 실행 중인 터미널 멀티플렉서 감지
local backend, nvim_pane
if vim.env.WEZTERM_PANE then
  backend = "wezterm"
  nvim_pane = vim.env.WEZTERM_PANE
elseif vim.env.TMUX then
  backend = "tmux"
  nvim_pane = vim.env.TMUX_PANE or vim.trim(vim.fn.system("tmux display-message -p '#{pane_id}'"))
end

local smart_split = {
  wezterm = "~/.config/wezterm/smart-split --percent 35 -- claude",
  tmux = "~/.config/tmux/smart-split.sh --pane-id " .. (nvim_pane or "") .. " --percent 35 -- claude",
}

local function open()
  local raw = vim.fn.system(smart_split[backend])
  if vim.v.shell_error == 0 then
    table.insert(pane_ids, vim.trim(raw))
  end
end

local function kill_all()
  for _, id in ipairs(pane_ids) do
    if backend == "wezterm" then
      vim.fn.system("wezterm cli kill-pane --pane-id " .. id)
    else
      vim.fn.system("tmux kill-pane -t " .. id .. " 2>/dev/null")
    end
  end
  pane_ids = {}
end

--- 새 외부 pane 열기 (복수 가능)
function M.open()
  if not backend then
    vim.notify("claude-pane: wezterm/tmux 환경이 아닙니다", vim.log.levels.WARN)
    return
  end
  open()
end

--- 외부 pane 사용 가능 여부
---@return boolean
function M.is_available()
  return backend ~= nil
end

-- nvim 종료 시 pane 자동 정리
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = kill_all,
  desc = "claude-pane: 외부 pane 정리",
})

return M

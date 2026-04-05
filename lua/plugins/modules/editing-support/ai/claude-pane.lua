-- 외부 터미널 pane에서 Claude CLI 직접 실행 (wezterm > tmux)
-- claudecode.nvim과 별도로, 터미널 기반 워크플로우를 보조적으로 유지한다.
-- nvim 종료 시 생성된 pane을 자동으로 정리한다.
local M = {}

local pane_id = nil

-- 현재 실행 중인 터미널 멀티플렉서 감지
local backend, nvim_pane
if vim.env.WEZTERM_PANE then
  backend = "wezterm"
  nvim_pane = vim.env.WEZTERM_PANE
elseif vim.env.TMUX then
  backend = "tmux"
  nvim_pane = vim.env.TMUX_PANE or vim.trim(vim.fn.system("tmux display-message -p '#{pane_id}'"))
end

--- pane이 살아있는지 확인 (죽었으면 pane_id 초기화)
---@return boolean
local function is_alive()
  if not pane_id then return false end
  if backend == "wezterm" then
    vim.fn.system("wezterm cli list 2>/dev/null | grep -qw " .. pane_id)
  else
    vim.fn.system("tmux display-message -t " .. pane_id .. " -p '' 2>/dev/null")
  end
  if vim.v.shell_error ~= 0 then
    pane_id = nil
    return false
  end
  return true
end

--- 패인 크기에 따라 분할 방향 결정 (셀 종횡비 2.2x 보정)
---@return string wez_dir, string tmux_flag
local function smart_dir()
  local cols, rows
  if backend == "wezterm" then
    local info = vim.fn.system("wezterm cli list --format json 2>/dev/null")
    local ok, panes = pcall(vim.json.decode, info)
    if ok then
      for _, p in ipairs(panes) do
        if tostring(p.pane_id) == nvim_pane then
          cols, rows = p.size.cols, p.size.rows
          break
        end
      end
    end
  else
    cols = tonumber(vim.fn.system("tmux display-message -t " .. nvim_pane .. " -p '#{pane_width}'"))
    rows = tonumber(vim.fn.system("tmux display-message -t " .. nvim_pane .. " -p '#{pane_height}'"))
  end
  if cols and rows and cols > rows * 2.2 then
    return "--right", "-h"
  end
  return "--bottom", "-v"
end

local function open()
  if is_alive() then return end
  local cmd = "claude"
  local wez_dir, tmux_flag = smart_dir()
  local raw
  if backend == "wezterm" then
    raw = vim.fn.system(
      "wezterm cli split-pane --pane-id "
        .. nvim_pane
        .. " "
        .. wez_dir
        .. " --percent 35 -- bash -c "
        .. vim.fn.shellescape(cmd)
    )
  else
    raw = vim.fn.system(
      "tmux split-window -t "
        .. nvim_pane
        .. " "
        .. tmux_flag
        .. " -l 35% -P -F '#{pane_id}' "
        .. vim.fn.shellescape(cmd)
    )
  end
  if vim.v.shell_error == 0 then
    pane_id = vim.trim(raw)
  end
end

local function kill()
  if not pane_id then return end
  if backend == "wezterm" then
    vim.fn.system("wezterm cli kill-pane --pane-id " .. pane_id)
  else
    vim.fn.system("tmux kill-pane -t " .. pane_id .. " 2>/dev/null")
  end
  pane_id = nil
end

--- 외부 pane 토글
function M.toggle()
  if not backend then
    vim.notify("claude-pane: wezterm/tmux 환경이 아닙니다", vim.log.levels.WARN)
    return
  end
  if is_alive() then
    kill()
  else
    open()
  end
end

--- 외부 pane 사용 가능 여부
---@return boolean
function M.is_available()
  return backend ~= nil
end

-- nvim 종료 시 pane 자동 정리
vim.api.nvim_create_autocmd("VimLeavePre", {
  callback = kill,
  desc = "claude-pane: 외부 pane 정리",
})

return M

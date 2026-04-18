-- WezTerm pane navigation: IS_NVIM user_var broadcast.
-- wezterm.lua의 is_vim() 이 proc-tree walk(get_foreground_process_name) 대신
-- O(1) pane:get_user_vars() 조회로 동작하도록 OSC 1337 시퀀스를 내보낸다.
-- WSL에서 foreground proc 이름이 wslhost.exe로 나오고 호출 자체가 느린 문제 회피.

local platform = require "core.platform"
if not platform.in_wezterm then return end

-- wezterm 의 Ctrl+hjkl 콜백이 sync `wezterm cli` 호출 없이 SendKey / ActivatePaneDirection 을
-- 바로 선택할 수 있도록, nvim 쪽에서 아래 user_var 들을 OSC 1337 로 broadcast.
--   IS_NVIM           : 이 pane 에 nvim 떠있음
--   NVIM_AT_{LEFT,...} : 현재 nvim 창이 해당 방향 edge 에 있음
local function set_var(key, val)
  local seq = "\027]1337;SetUserVar=" .. key .. "=" .. vim.base64.encode(val) .. "\007"
  if platform.in_tmux then
    -- tmux DCS passthrough (allow-passthrough on 필요)
    seq = "\027Ptmux;" .. seq:gsub("\027", "\027\027") .. "\027\\"
  end
  io.stdout:write(seq)
  io.stdout:flush()
end

local edge_dirs = { LEFT = "h", RIGHT = "l", UP = "k", DOWN = "j" }
local function update_edges()
  local cur = vim.fn.winnr()
  for name, key in pairs(edge_dirs) do
    set_var("NVIM_AT_" .. name, vim.fn.winnr(key) == cur and "1" or "")
  end
end
local function setup_all()
  set_var("IS_NVIM", "1")
  update_edges()
end

vim.api.nvim_create_autocmd({ "UIEnter", "VimEnter", "VimResume", "FocusGained" }, {
  callback = function() vim.schedule(setup_all) end,
  desc = "wezterm: IS_NVIM + edge flags 설정",
})
vim.api.nvim_create_autocmd({ "WinEnter", "WinResized", "VimResized", "WinNew", "WinClosed" }, {
  callback = function() vim.schedule(update_edges) end,
  desc = "wezterm: edge flags 갱신",
})
vim.api.nvim_create_autocmd({ "VimLeavePre", "VimSuspend" }, {
  callback = function()
    set_var("IS_NVIM", "")
    for name in pairs(edge_dirs) do
      set_var("NVIM_AT_" .. name, "")
    end
  end,
  desc = "wezterm: IS_NVIM + edge flags 해제",
})

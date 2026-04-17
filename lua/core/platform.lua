-- OS/환경 감지 단일 진실 공급원.
-- 부작용 없음. require 시점에 1회 감지하여 모듈 테이블에 캐시.
local M = {}

local uname = vim.uv.os_uname()

M.sysname = uname.sysname
M.is_mac = uname.sysname == "Darwin"
M.is_linux = uname.sysname == "Linux"
M.is_windows = uname.sysname:match "Windows" ~= nil

-- WSL 감지: 환경변수 우선, 실패 시 커널 릴리즈 문자열 검사
M.is_wsl = M.is_linux
  and (
    vim.env.WSL_DISTRO_NAME ~= nil
    or vim.env.WSL_INTEROP ~= nil
    or (uname.release or ""):lower():match "microsoft" ~= nil
  )

-- 사용자 로그인 셸 (rc 파일 source 보장). 없으면 sh.
M.shell = vim.env.SHELL or "/bin/sh"

-- 터미널 멀티플렉서
-- WSL 도메인에서는 WEZTERM_PANE이 전달되지 않으므로 TERM_PROGRAM으로도 감지.
-- 환경에 따라 TERM_PROGRAM 값이 "WezTerm"/"wezterm"/"WEZ_TERM" 등으로 달라질 수 있어 substring 매칭.
M.in_wezterm = vim.env.WEZTERM_PANE ~= nil
  or ((vim.env.TERM_PROGRAM or ""):lower():find "wez") ~= nil
M.in_tmux = vim.env.TMUX ~= nil

--- 실행 파일이 PATH에 있는지 확인
---@param name string
---@return boolean
function M.has_exec(name) return vim.fn.executable(name) == 1 end

return M

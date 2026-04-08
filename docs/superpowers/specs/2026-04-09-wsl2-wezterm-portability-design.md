# WSL2 + WezTerm + zsh 포팅 설계 (표준 범위)

**Date**: 2026-04-09
**Status**: Draft
**Scope**: Standard (B) — Broken 수정 + `core/platform.lua` 신설 + WSL2 시스템 클립보드

## 배경

현재 Neovim 설정은 macOS에서는 원활하게 동작하지만 WinOS + WSL2(zsh) + WezTerm 환경에서는 두 가지 치명적 문제가 있다:

1. **`im-select.nvim`**이 WSL2에서 `im-select.exe`를 실행하려 하지만 WSL 내부 컨텍스트에서는 Windows IME 전환이 실질적으로 동작하지 않는다.
2. **`claude-pane.lua`**가 새 pane에서 `bash -lc`를 하드코딩하여, 사용자의 zsh rc(PATH, nvm 등)가 source되지 않아 `claude` CLI를 찾지 못할 수 있다. macOS에서 동작하는 것은 Homebrew가 시스템 전역 PATH(`/etc/paths`)에 있기 때문이다.

또한 CLAUDE.md는 `lua/core/platform.lua`의 존재를 전제하지만 실제 파일은 존재하지 않아 OS 분기가 임시방편으로 흩어져 있다.

## 목표

- WSL2 + WezTerm + zsh에서 nvim이 다음을 만족:
  - `claude` CLI가 외부 pane에서 올바르게 실행됨 (zsh rc source됨)
  - `"+y`로 Windows 시스템 클립보드에 복사, `"+p`로 Windows에서 복사한 텍스트 붙여넣기
  - im-select 관련 오류/경고 없음 (플러그인 자체 로드 안 함)
- macOS 회귀 없음 — 기존 동작 1:1 유지
- CLAUDE.md의 "OS 격리 규칙" 준수 — 변경은 모두 포터블 또는 명시적 `if is_wsl` 블록 내부

## 비목표 (YAGNI)

- WSL에서 Windows IME를 직접 전환하는 대체 툴 구현
- `open` 명령 포팅(`xdg-open`/`wslview`) — 현재 codebase에 사용처 없음
- Mason / Python provider / font 감사 — 감사 결과 이슈 없음
- native Windows(비 WSL) 지원 — 범위 밖

## 설계

### 1. `lua/core/platform.lua` (신규)

OS/환경 감지 단일 진실 공급원. 순수 테이블 + 간단한 헬퍼. 부작용 없음.

```lua
local M = {}

local uname = vim.uv.os_uname()
M.sysname = uname.sysname

M.is_mac     = uname.sysname == "Darwin"
M.is_linux   = uname.sysname == "Linux"
M.is_windows = uname.sysname:match("Windows") ~= nil

-- WSL 감지: 환경변수 우선, 실패 시 커널 릴리즈 문자열 검사
M.is_wsl = M.is_linux
  and (vim.env.WSL_DISTRO_NAME ~= nil
       or vim.env.WSL_INTEROP ~= nil
       or (uname.release or ""):lower():match("microsoft") ~= nil)

-- 사용자의 로그인 셸 (rc 파일 source 보장). 없으면 sh.
M.shell = vim.env.SHELL or "/bin/sh"

-- 터미널 멀티플렉서
M.in_wezterm = vim.env.WEZTERM_PANE ~= nil
M.in_tmux    = vim.env.TMUX ~= nil

--- 실행 파일이 PATH에 있는지 확인
---@param name string
---@return boolean
function M.has_exec(name)
  return vim.fn.executable(name) == 1
end

return M
```

로드 방식: 필요한 파일이 `local platform = require("core.platform")`로 직접 require. 전역 주입 없음.

### 2. `lua/plugins/modules/utils/im-select.lua` (수정)

- Lazy spec에 `cond` 게이트 추가: macOS에서만 로드.
- WSL2/Linux/Windows에서는 플러그인 자체가 설치/로드되지 않음.
- mac 전용이 되므로 `is_mac` 분기 제거 가능.

```lua
return {
  "keaising/im-select.nvim",
  event = "VeryLazy",
  cond = function() return require("core.platform").is_mac end,
  config = function()
    require("im_select").setup {
      default_im_select = "com.apple.keylayout.ABC",
      default_command = "macism",
      set_default_events = { "InsertLeave", "CmdlineLeave" },
      set_previous_events = { "InsertEnter" },
      async_switch_im = false,
    }
  end,
}
```

### 3. `lua/plugins/modules/editing-support/ai/claude-pane.lua` (수정)

변경 지점: 62번째 줄 `{ "--", "bash", "-lc", shell_cmd }`.

```lua
-- 파일 상단 근처에 추가
local platform = require("core.platform")

-- line 62 교체
vim.list_extend(cmd, { "--", platform.shell, "-lc", shell_cmd })
```

근거:
- `$SHELL`은 사용자의 로그인 셸(mac/WSL2 모두 zsh)이므로 `-lc`가 올바른 rc 파일(`~/.zshrc` + `~/.zprofile`)을 source → nvm/npm으로 설치한 `claude` CLI가 PATH에 들어옴.
- tmux 분기(line 72)는 shell_cmd를 문자열로 넘겨 tmux가 기본 셸로 실행 → 이미 올바름, 변경 불필요.
- mac 회귀 영향: mac에서도 `$SHELL`은 zsh이므로 동작 동일 또는 개선(기존 `bash -lc`보다 의도에 부합).

### 4. `polish.lua` (WSL2 클립보드 프로바이더)

`polish.lua`는 lazy_setup 이후 실행되는 공식 후처리 훅으로, `vim.g.clipboard` 런타임 할당에 가장 적합.

```lua
-- polish.lua 내부 추가
local platform = require("core.platform")

if platform.is_wsl then
  if platform.has_exec("win32yank.exe") then
    vim.g.clipboard = {
      name = "win32yank",
      copy = {
        ["+"] = "win32yank.exe -i --crlf",
        ["*"] = "win32yank.exe -i --crlf",
      },
      paste = {
        ["+"] = "win32yank.exe -o --lf",
        ["*"] = "win32yank.exe -o --lf",
      },
      cache_enabled = 0,
    }
  elseif platform.has_exec("clip.exe") and platform.has_exec("powershell.exe") then
    vim.g.clipboard = {
      name = "WslClipboard-fallback",
      copy = {
        ["+"] = "clip.exe",
        ["*"] = "clip.exe",
      },
      paste = {
        ["+"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", "Get-Clipboard" },
        ["*"] = { "powershell.exe", "-NoLogo", "-NoProfile", "-Command", "Get-Clipboard" },
      },
      cache_enabled = 0,
    }
  end
  -- 둘 다 없으면 기본 provider(대개 무동작)로 fallback. 경고 notify 없음 — polish 단계에서 과도한 알림 방지.
end
```

**win32yank 선호 이유**:
- PowerShell 부팅 오버헤드 없음(수백 ms 절약)
- CRLF/LF 변환 내장으로 줄바꿈 이슈 없음
- `--lf` 플래그로 paste 시 Windows CRLF → Unix LF 정규화

**win32yank 설치 안내**는 README에 별도 섹션으로 추가(범위에 포함).

### 5. 파일 목록

| 파일 | 변경 유형 | 주요 내용 |
|---|---|---|
| `lua/core/platform.lua` | 신규 | OS/환경 감지 헬퍼 |
| `lua/plugins/modules/utils/im-select.lua` | 수정 | `cond` 게이트 추가, mac 전용화 |
| `lua/plugins/modules/editing-support/ai/claude-pane.lua` | 수정 | `bash` → `platform.shell` |
| `polish.lua` | 수정 | WSL2 클립보드 provider 등록 |
| `README.md` | 수정 | WSL2 섹션: win32yank 설치 안내 |

## 테스트 계획

### macOS 회귀
- [ ] nvim 시작 — 오류 없음
- [ ] `:Lazy` — im-select.nvim 로드됨 (기존과 동일)
- [ ] Insert → Normal 전환 시 IME 자동 전환 동작
- [ ] `:ClaudeCode` (wezterm) — 오른쪽/아래 pane에 claude 실행, CLI 발견됨
- [ ] tmux 세션 내 `:ClaudeCode` — tmux split 동작
- [ ] `"+y`/`"+p` — 기본 clipboard provider 정상

### WSL2 + WezTerm + zsh
- [ ] nvim 시작 — 오류 없음
- [ ] `:Lazy` — im-select.nvim 목록에 없음(cond false)
- [ ] `:checkhealth` — clipboard provider가 `win32yank` 또는 `WslClipboard-fallback`으로 표시
- [ ] `"+y` 후 Windows 메모장에 붙여넣기 → 내용 일치
- [ ] Windows 브라우저에서 복사 후 nvim `"+p` → 내용 일치, CRLF 없음
- [ ] `:ClaudeCode` — WezTerm split-pane으로 claude 실행, `claude` 바이너리 발견(zsh rc source됨)
- [ ] WezTerm CLI(`wezterm.exe`)가 WSL PATH에 노출되어 있지 않으면 사전 안내 메시지 적절

## 리스크 및 완화

- **리스크**: `vim.uv.os_uname()` 미사용 가능 (구버전 nvim). → AstroNvim v6은 nvim 0.10+ 요구, `vim.uv` 존재 확정.
- **리스크**: polish.lua에서 `require("core.platform")`이 너무 일찍 실행되어 env 미설정. → polish는 lazy_setup 이후 실행, env는 프로세스 시작 시 확정되므로 안전.
- **리스크**: WezTerm CLI가 WSL 내부에 노출되지 않아 `wezterm cli list` 실패. → 기존 코드가 `shell_error` 체크로 안전 fallback. 변경 없음, README에 권장 설정만 기록.
- **리스크**: `win32yank` 없고 `clip.exe`/`powershell.exe` fallback도 느림. → 사용자에게 win32yank 설치 권장. fallback은 기능 보장용.

## Out of Scope (차기)

- WSL에서 Windows IME 직접 전환하는 대체 툴
- `open` 유틸 포팅(`xdg-open`/`wslview`)
- native Windows(비 WSL) 지원
- Mason 바이너리 경로 OS별 최적화

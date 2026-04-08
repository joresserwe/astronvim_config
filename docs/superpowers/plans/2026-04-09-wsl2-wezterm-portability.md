# WSL2 + WezTerm + zsh Portability Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** nvim 설정을 WSL2 + WezTerm + zsh에서 원활히 동작하도록 개선하면서 macOS 회귀 없음.

**Architecture:** 신설 `lua/core/platform.lua`로 OS/환경 감지 단일화 → im-select는 mac 전용으로 gating → claude-pane의 하드코딩된 `bash`를 `$SHELL`로 교체 → WSL2 한정 clipboard provider를 `polish.lua`에서 런타임 등록 (`win32yank.exe` 우선, `clip.exe`/`powershell.exe` fallback).

**Tech Stack:** Neovim 0.10+ (AstroNvim v6), lua, lazy.nvim, win32yank

**Spec:** `docs/superpowers/specs/2026-04-09-wsl2-wezterm-portability-design.md`

**Testing note:** 이 config 레포는 자동화 테스트 프레임워크가 없음. "테스트"는 nvim을 실제 기동하여 수동 수락 체크리스트로 검증한다. 각 Task는 구문 검증 + 수동 기동 확인 + 커밋 순서로 진행.

---

## File Structure

| 파일 | 상태 | 책임 |
|---|---|---|
| `lua/core/platform.lua` | 신규 | OS/환경 감지 단일 진실 공급원 |
| `lua/plugins/modules/utils/im-select.lua` | 수정 | macOS 전용 로드로 gating |
| `lua/plugins/modules/editing-support/ai/claude-pane.lua` | 수정 | 하드코딩 `bash` 제거 |
| `polish.lua` | 수정 | WSL2 clipboard provider 등록 |
| `README.md` | 수정 | WSL2 win32yank 설치 안내 |

---

## Task 1: `core/platform.lua` 신설

**Files:**
- Create: `lua/core/platform.lua`

- [ ] **Step 1: 파일 작성**

Create `lua/core/platform.lua`:

```lua
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
M.in_wezterm = vim.env.WEZTERM_PANE ~= nil
M.in_tmux = vim.env.TMUX ~= nil

--- 실행 파일이 PATH에 있는지 확인
---@param name string
---@return boolean
function M.has_exec(name) return vim.fn.executable(name) == 1 end

return M
```

- [ ] **Step 2: 구문 검증 및 런타임 로드 확인**

Run:
```bash
nvim --headless -c 'lua local p = require("core.platform"); print(vim.inspect({is_mac=p.is_mac, is_wsl=p.is_wsl, is_linux=p.is_linux, shell=p.shell, in_wezterm=p.in_wezterm, in_tmux=p.in_tmux}))' -c 'qa' 2>&1
```

Expected: 오류 없이 테이블 출력. 현재 환경(WSL2)에서 `is_wsl=true`, `is_linux=true`, `is_mac=false`, `shell`에 `/usr/bin/zsh` 또는 유사 경로.

- [ ] **Step 3: 커밋**

```bash
git add lua/core/platform.lua
git commit -m "Add core.platform module for OS/env detection

Single source of truth for cross-platform checks: is_mac, is_wsl,
is_linux, is_windows, shell, in_wezterm, in_tmux, has_exec."
```

---

## Task 2: `im-select.lua` macOS 전용 gating

**Files:**
- Modify: `lua/plugins/modules/utils/im-select.lua`

- [ ] **Step 1: 파일 전체 교체**

Replace entire contents of `lua/plugins/modules/utils/im-select.lua` with:

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

- [ ] **Step 2: 현재 환경(WSL2)에서 플러그인이 로드되지 않는지 확인**

Run:
```bash
nvim --headless -c 'lua vim.defer_fn(function() local loaded = require("lazy.core.config").plugins["im-select.nvim"]; print("loaded state:", loaded and loaded._.loaded and "LOADED" or "NOT LOADED") vim.cmd("qa") end, 2000)' 2>&1
```

Expected: `loaded state: NOT LOADED` (cond가 false이므로 lazy가 로드 생략).

주: `:Lazy` UI에서는 `im-select.nvim`이 목록에 나타나되 회색(disabled) 처리됨 — 정상.

- [ ] **Step 3: 커밋**

```bash
git add lua/plugins/modules/utils/im-select.lua
git commit -m "Gate im-select.nvim to macOS only

WSL2/Linux/Windows cannot meaningfully switch Windows IME from
inside WSL. Use cond from core.platform to skip loading entirely
on non-mac systems. Remove is_mac branch since plugin is now
mac-exclusive."
```

---

## Task 3: `claude-pane.lua` shell 하드코딩 제거

**Files:**
- Modify: `lua/plugins/modules/editing-support/ai/claude-pane.lua`

- [ ] **Step 1: 상단에 platform require 추가**

Edit `lua/plugins/modules/editing-support/ai/claude-pane.lua`:

old_string (line 4):
```lua
local M = {}
```

new_string:
```lua
local platform = require "core.platform"

local M = {}
```

- [ ] **Step 2: 62번째 줄 `bash` → `platform.shell`**

Edit same file:

old_string (line 62):
```lua
    vim.list_extend(cmd, { "--", "bash", "-lc", shell_cmd })
```

new_string:
```lua
    vim.list_extend(cmd, { "--", platform.shell, "-lc", shell_cmd })
```

- [ ] **Step 3: 구문 검증 — nvim 기동 오류 없음**

Run:
```bash
nvim --headless -c 'lua require("plugins.modules.editing-support.ai.claude-pane")' -c 'qa' 2>&1
```

Expected: 오류 없음. 빈 출력.

- [ ] **Step 4: platform.shell 값 확인**

Run:
```bash
nvim --headless -c 'lua print("shell =", require("core.platform").shell)' -c 'qa' 2>&1
```

Expected: `shell = /usr/bin/zsh` 또는 유사 zsh 경로(사용자 환경에 따라).

- [ ] **Step 5: 커밋**

```bash
git add lua/plugins/modules/editing-support/ai/claude-pane.lua
git commit -m "Use \$SHELL instead of hardcoded bash in claude-pane

Hardcoded 'bash -lc' sourced bash profiles only, missing PATH
entries set in user's zshrc (nvm, npm). Claude CLI installed via
nvm was not discoverable. Replace with platform.shell (= \$SHELL)
so the user's actual login shell rc files are sourced.

Mac regression: none — macOS default shell is also zsh."
```

---

## Task 4: `polish.lua` WSL2 clipboard provider

**Files:**
- Modify: `polish.lua`

- [ ] **Step 1: 현재 polish.lua 내용 확인**

Run: `cat polish.lua`

polish.lua는 lazy_setup 이후 실행되는 후처리 훅. 새 블록을 파일 끝(return 직전 또는 마지막 실행부)에 추가한다.

- [ ] **Step 2: polish.lua에 clipboard provider 블록 추가**

Add this block to `polish.lua`. Add near the top (after any existing requires) or end (before the final return if present) — whichever is consistent with the existing file's organization. If the file is effectively empty/template, replace with the block below wrapped in sensible scaffolding.

Block to add:

```lua
-- WSL2 전용 clipboard provider 등록.
-- mac/native linux은 nvim 기본 provider 사용.
do
  local platform = require "core.platform"
  if platform.is_wsl then
    if platform.has_exec "win32yank.exe" then
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
    elseif platform.has_exec "clip.exe" and platform.has_exec "powershell.exe" then
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
    -- 둘 다 없으면 기본 provider로 fallback (대개 무동작). notify 없음.
  end
end
```

- [ ] **Step 3: 구문 검증 — nvim 기동 오류 없음**

Run:
```bash
nvim --headless -c 'lua print("clipboard name:", (vim.g.clipboard and vim.g.clipboard.name) or "default")' -c 'qa' 2>&1
```

Expected (WSL2에서 win32yank 미설치 시): `clipboard name: WslClipboard-fallback` 또는 `default`. 설치 후: `clipboard name: win32yank`.

- [ ] **Step 4: `:checkhealth provider` 확인 (수동)**

사용자가 직접 실행:
```
nvim -c 'checkhealth provider.clipboard'
```

Expected: `Clipboard tool found: win32yank` 또는 fallback 이름 표시. 오류 없음.

- [ ] **Step 5: 커밋**

```bash
git add polish.lua
git commit -m "Register WSL2 clipboard provider in polish.lua

Prefer win32yank.exe for speed and CRLF handling; fall back to
clip.exe + powershell.exe Get-Clipboard when win32yank is absent.
Mac/native linux untouched — uses nvim default clipboard provider."
```

---

## Task 5: README WSL2 섹션 추가

**Files:**
- Modify: `README.md`

- [ ] **Step 1: 현재 README 구조 확인**

Run: `cat README.md`

WSL2 관련 섹션 또는 "Installation" / "Requirements" 부근에 새 subsection을 추가할 위치를 정한다.

- [ ] **Step 2: WSL2 섹션 추가**

Append (or insert under an existing "Installation"/"Platform" section) this markdown block:

```markdown
## WSL2 + WezTerm + zsh

이 설정은 WSL2 Ubuntu + WezTerm(Windows 측) + zsh 조합에서 동작하도록
포팅되어 있다.

### 권장 설치: win32yank

WSL2에서 Windows 시스템 클립보드와 `"+y`/`"+p`를 연동하려면 `win32yank`
설치를 권장한다. 미설치 시 `clip.exe` + `powershell.exe` fallback으로
동작하지만 느리고 CRLF 처리가 부정확할 수 있다.

설치:
```bash
curl -sLo /tmp/win32yank.zip https://github.com/equalsraf/win32yank/releases/download/v0.1.1/win32yank-x64.zip
unzip -p /tmp/win32yank.zip win32yank.exe > /tmp/win32yank.exe
chmod +x /tmp/win32yank.exe
sudo mv /tmp/win32yank.exe /usr/local/bin/
rm /tmp/win32yank.zip
```

확인: `nvim -c 'checkhealth provider.clipboard'` → `win32yank` 표시.

### WezTerm CLI 요구사항

`:ClaudeCode` 등 외부 pane 분할 기능은 WSL 내부에서 `wezterm` 바이너리를
호출한다. WezTerm을 Windows에 설치한 뒤 `wezterm.exe`를 WSL PATH에
노출해야 한다 (보통 WSL interop으로 `/mnt/c/Program Files/WezTerm/`이
자동 노출됨). 노출되지 않으면 `~/.zshrc`에 다음을 추가:

```zsh
export PATH="$PATH:/mnt/c/Program Files/WezTerm"
alias wezterm='wezterm.exe'
```

### IME 전환

`im-select.nvim`은 macOS 전용이다. WSL2에서는 Windows 측 IME 전환을
Windows에 맡긴다 (nvim 내부 제어 없음).
```

- [ ] **Step 3: 커밋**

```bash
git add README.md
git commit -m "Document WSL2 + WezTerm + zsh setup in README

win32yank install instructions, WezTerm CLI PATH requirement,
and IME note."
```

---

## Task 6: 통합 수락 테스트 (수동 체크리스트)

구현 완료 후 사용자가 직접 수행. 실패 시 해당 Task로 돌아가 수정.

### WSL2 + WezTerm + zsh (현재 환경)

- [ ] `nvim` 기동 시 오류 없음
- [ ] `:Lazy` — `im-select.nvim`이 disabled/grey로 표시 (로드 안 됨)
- [ ] `:checkhealth provider.clipboard` — `win32yank` 또는 `WslClipboard-fallback` 표시
- [ ] 에디터에서 텍스트 선택 후 `"+y` → Windows 메모장에 붙여넣기 → 내용 일치
- [ ] Windows 브라우저에서 텍스트 복사 → nvim에서 `"+p` → 내용 일치, 줄바꿈 이슈 없음
- [ ] `:ClaudeCode` 실행 → WezTerm이 새 pane을 분할 → 해당 pane에서 `claude` CLI 발견되어 프롬프트 진입 (zsh rc source 확인)
- [ ] nvim 종료 시 생성된 claude pane이 자동 정리됨

### macOS 회귀 (사용자가 mac 머신에서 별도 수행)

- [ ] `nvim` 기동 시 오류 없음
- [ ] `:Lazy` — `im-select.nvim` 정상 로드
- [ ] Insert → Normal 전환 시 IME 자동 전환 동작 (macism)
- [ ] `"+y`/`"+p` — macOS 시스템 클립보드 정상
- [ ] `:ClaudeCode` (wezterm) → split pane, claude CLI 실행 정상
- [ ] tmux 세션 내 `:ClaudeCode` → tmux split-window 정상

---

## Self-Review

1. **Spec coverage**
   - platform.lua 신설 → Task 1 ✓
   - im-select gating → Task 2 ✓
   - claude-pane shell 수정 → Task 3 ✓
   - polish.lua clipboard → Task 4 ✓
   - README WSL2 섹션 → Task 5 ✓
   - 수락 테스트(mac 회귀 + WSL2) → Task 6 ✓
   - 모든 스펙 요구사항이 Task에 매핑됨.

2. **Placeholder scan**: 없음. 모든 코드 블록은 완성 상태.

3. **Type consistency**: `platform.shell`, `platform.is_wsl`, `platform.is_mac`, `platform.has_exec` 이름이 Task 1 정의와 Task 2/3/4 사용 전반에서 일치.

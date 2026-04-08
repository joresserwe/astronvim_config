-- lazy.nvim 플러그인 로딩이 모두 끝난 뒤 마지막에 실행되는 순수 Lua 스크립트.
-- 플러그인 spec으로 표현하기 어려운 마무리 작업(autocmd, 전역 변수 등)을 여기에 작성.

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

if true then return end -- WARN: 이 줄을 제거하면 아래 코드가 활성화됩니다

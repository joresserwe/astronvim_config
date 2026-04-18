-- WSL2 전용 clipboard provider 등록.
-- mac/native linux은 nvim 기본 provider 사용.
-- WSL2 clipboard: executable 확인이 느리므로 비동기로 지연.

local platform = require "core.platform"
if not platform.is_wsl then return end

vim.schedule(function()
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
end)

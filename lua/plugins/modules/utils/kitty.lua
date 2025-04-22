return {
  "fladson/vim-kitty",
  -- `kitty.conf` 파일을 열 때만 플러그인을 로드합니다.
  cond = function() return vim.fn.expand "%:t" == "kitty.conf" end,
}

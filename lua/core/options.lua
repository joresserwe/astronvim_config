local M = {}

-- Configure core features of AstroNvim
M.features = {
  large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
  autopairs = false, -- blink.pairs 사용
  cmp = true, -- enable completion at start
  -- diagnostics = { virtual_text = true, virtual_lines = false }, -- diagnostic settings on startup
  -- diagnostics_mode = 3, -- diagnostic mode on start (0 = off, 1 = no signs/virtual text, 2 = no virtual text, 3 = on)
  highlighturl = true, -- highlight URLs at start
  notifications = true, -- enable notifications at start
}

-- vim options can be configured here
M.options = {
  opt = {
    -- set to true or false etc.
    --cmdheight = 1, -- more space in the neovim command line for displaying messages
    autoindent = true, -- 자동 들여쓰기 기능
    relativenumber = true, -- sets vim.opt.relativenumber
    number = true, -- sets vim.opt.number
    smartindent = true, -- 들여쓰기를 자동으로 맞춘다
    spell = false, -- sets vim.opt.spell
    signcolumn = "yes", -- sets vim.opt.signcolumn to yes
    wrap = false, -- sets vim.opt.wrap
    winminwidth = 10, -- 최대화 시 다른 창 최소 너비
    foldcolumn = "0", -- fold 레벨 숫자 표시 비활성화
    -- 한글 2벌식 langmap: 노멀모드에서 한글 입력 시 영문 키로 인식
    langmap = table.concat({
      -- 일반 (ㅂ=q ~ ㅔ=p, ㅁ=a ~ ㅣ=l, ㅋ=z ~ ㅡ=m)
      "ㅂq", "ㅈw", "ㄷe", "ㄱr", "ㅅt", "ㅛy", "ㅕu", "ㅑi", "ㅐo", "ㅔp",
      "ㅁa", "ㄴs", "ㅇd", "ㄹf", "ㅎg", "ㅗh", "ㅓj", "ㅏk", "ㅣl",
      "ㅋz", "ㅌx", "ㅊc", "ㅍv", "ㅠb", "ㅜn", "ㅡm",
      -- Shift (쌍자음 + ㅒㅖ)
      "ㅃQ", "ㅉW", "ㄸE", "ㄲR", "ㅆT", "ㅒO", "ㅖP",
    }, ","),
    langremap = false, -- langmap이 매핑 RHS에 영향주지 않도록
  },
  g = {
    autoformat = false,
  },
}

M.filetypes = {
  -- see `:h vim.filetype.add` for usage
  extension = {
    -- foo = "fooscript",
  },
  filename = {

  },
  pattern = {
    -- [".*/etc/foo/.*"] = "fooscript",
  },
}

return M

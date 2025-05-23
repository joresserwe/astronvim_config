local M = {}

-- Configure core features of AstroNvim
M.features = {
  large_buf = { size = 1024 * 256, lines = 10000 }, -- set global limits for large files for disabling features like treesitter
  autopairs = true, -- enable autopairs at start
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
    -- [".foorc"] = "fooscript",
  },
  pattern = {
    -- [".*/etc/foo/.*"] = "fooscript",
  },
}

return M

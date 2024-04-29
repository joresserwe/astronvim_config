return {
  "fladson/vim-kitty",
  cond = function() return vim.fn.expand "%:t" == "kitty.conf" end,
}

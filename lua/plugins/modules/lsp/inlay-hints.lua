return {
  {
    "lvimuser/lsp-inlayhints.nvim",
    init = function() end,
    optional = true,
  },
  {
    "p00f/clangd_extensions.nvim",
    optional = true,
    opts = { extensions = { autoSetHints = false } },
  },
  {
    "simrat39/rust-tools.nvim",
    optional = true,
    opts = { tools = { inlay_hints = { auto = false } } },
  },
}

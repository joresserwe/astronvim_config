return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.completion.copilot-lua-cmp" },

  { import = "astrocommunity.color.mini-hipatterns" },

  -- { import = "astrocommunity.diagnostics.lsp_lines-nvim" },
  -- { import = "astrocommunity.diagnostics.trouble-nvim" },

  { import = "astrocommunity.editing-support.refactoring-nvim" },

  -- zoxide(가장 빈번히 방문한 디렉토리)를 telescope와 결합해서 사용할 수 있다.
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },

  -- Git
  { import = "astrocommunity.git.neogit" },
  { import = "astrocommunity.git.diffview-nvim" },

  { import = "astrocommunity.motion.nvim-surround" },

  { import = "astrocommunity.utility.noice-nvim" },

  -- LSP garbage collection
  { import = "astrocommunity.lsp.garbage-day-nvim" },
  -- { import = "astrocommunity.lsp.lsp-signature-nvim" },
}

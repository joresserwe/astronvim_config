return {
  -- Add the community repository of plugin specifications
  "AstroNvim/astrocommunity",
  -- example of importing a plugin, comment out to use it or add your own
  -- available plugins can be found at https://github.com/AstroNvim/astrocommunity

  -- { import = "astrocommunity.colorscheme.catppuccin" },
  -- { import = "astrocommunity.completion.copilot-lua-cmp" },
  --
  { import = "astrocommunity.bars-and-lines.lualine-nvim" },

  -- zoxide(가장 빈번히 방문한 디렉토리)를 telescope와 결합해서 사용할 수 있다.
  { import = "astrocommunity.fuzzy-finder.telescope-zoxide" },

  { import = "astrocommunity.pack.lua" },
  { import = "astrocommunity.pack.java" },
  { import = "astrocommunity.pack.kotlin" },
  { import = "astrocommunity.pack.python" },
  { import = "astrocommunity.pack.yaml" },
  { import = "astrocommunity.pack.docker" },
  { import = "astrocommunity.pack.typescript" },
  { import = "astrocommunity.pack.helm" },

  { import = "astrocommunity.motion.nvim-surround" },
}

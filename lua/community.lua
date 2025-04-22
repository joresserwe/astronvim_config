-- AstroCommunity: import any community modules here
-- We import this file in `lazy_setup.lua` before the `plugins/` folder.
-- This guarantees that the specs are processed before any user plugins.

---@type LazySpec
return {
  "AstroNvim/astrocommunity",
  { import = "astrocommunity.editing-support.conform-nvim" },
  { import = "astrocommunity.editing-support.refactoring-nvim" },

  { import = "astrocommunity.git.diffview-nvim" },

  { import = "astrocommunity.lsp.garbage-day-nvim" },
  { import = "astrocommunity.lsp.inc-rename-nvim" },

  { import = "astrocommunity.markdown-and-latex/markdown-preview-nvim" },

  { import = "astrocommunity.motion.nvim-surround" },

  { import = "astrocommunity.scrolling.vim-smoothie" },

  { import = "astrocommunity.split-and-window.colorful-winsep-nvim" },

  { import = "astrocommunity.utility.noice-nvim" },
}

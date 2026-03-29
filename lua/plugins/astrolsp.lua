-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = require("lsp.formatting").linters_by_ft,
    },
  },
  {
    "stevearc/conform.nvim",
    opts = require("lsp.formatting").conform_opts,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts = require("lsp.installer").mason,
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = require("lsp.installer").treesitter,
  },
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      local extend = function(a, b) return vim.tbl_deep_extend("force", a or {}, b or {}) end
      -- Configuration table of features provided by AstroLSP
      opts.features = extend(opts.features, require("lsp.config").features)

      -- Configuration table of features provided by AstroLSP
      opts.formatting = extend(opts.formatting, require("lsp.formatting").formatting)

      -- enable servers that you already have installed without mason
      opts.servers = extend(opts.servers, require "lsp.servers")

      -- customize how language servers are attached
      opts.handlers = extend(opts.handlers, require("lsp.config").handlers)

      -- customize language server configuration options passed to `lspconfig`
      opts.config = extend(opts.config, require("lsp.config").config)

      -- Configure buffer local auto commands to add when attaching a language server
      opts.autocmds = extend(opts.autocmds, require "lsp.autocmds")

      -- mappings to be set up on attaching of a language server
      opts.mappings = extend(opts.mappings, require "lsp.mappings"(opts))

      -- A custom `on_attach` function to be run after the default `on_attach` function
      opts.on_attach = require "lsp.on_attach"
    end
  },
}

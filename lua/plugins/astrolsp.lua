---@type LazySpec
return {
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = require("lsp.formatting").formatters_by_ft,
    },
  },
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters_by_ft = require("lsp.formatting").linters_by_ft,
    },
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
    ---@params opts AstroLSPOpts
    opts = function(_, opts)
      local extend_tbl = require("astrocore").extend_tbl

      -- customize lsp formatting options
      opts.formatting = extend_tbl(opts.formatting, require("lsp.formatting").formatting)

      -- enable servers that you already have installed without mason
      opts.servers = extend_tbl(opts.servers, require "lsp.servers")

      -- Configuration table of features provided by AstroLSP
      opts.features = extend_tbl(opts.features, require("lsp.config").features)

      -- customize how language servers are attached
      opts.handlers = extend_tbl(opts.handlers, require("lsp.config").handlers)

      -- customize language server configuration options passed to `lspconfig`
      opts.config = extend_tbl(opts.config, require("lsp.config").config)

      -- Configure buffer local auto commands to add when attaching a language server
      opts.autocmds = extend_tbl(opts.autocmds, require "lsp.autocmds")

      -- mappings to be set up on attaching of a language server
      opts.mappings = extend_tbl(opts.mappings, require "lsp.mappings"(opts))

      -- A custom `on_attach` function to be run after the default `on_attach` function
      opts.on_attach = require "lsp.on_attach"
    end,
  },
}
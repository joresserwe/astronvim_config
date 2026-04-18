-- AstroLSP allows you to customize the features in AstroNvim's LSP configuration engine
-- Configuration documentation can be found with `:h astrolsp`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  {
    "mfussenegger/nvim-lint",
    opts = {
      linters_by_ft = require "lsp.linting",
    },
  },
  {
    "stevearc/conform.nvim",
    opts = require("lsp.formatting").conform_opts,
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    event = "VeryLazy", -- 누락 패키지 자동 설치 체크는 startup 이후로 지연해도 무해
    opts = require("lsp.installer").mason,
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

      -- mappings to be set up on attaching of a language server
      opts.mappings = extend(opts.mappings, require "lsp.mappings"(opts))
    end
  },
}

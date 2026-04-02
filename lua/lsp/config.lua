local M = {}

-- Configuration table of features provided by AstroLSP
M.features = {
  codelens = false, -- enable/disable codelens refresh on start
  inlay_hints = true, -- enable/disable inlay hints on start
  semantic_tokens = true, -- enable/disable semantic token highlighting
}

-- customize how language servers are attached
M.handlers = {
  -- a function without a key is simply the default handler, functions take two parameters, the server name and the configured options table for that server
  -- function(server, opts) require("lspconfig")[server].setup(opts) end

  -- the key is the server that is being setup with `lspconfig`
  -- rust_analyzer = false, -- setting a handler to false will disable the set up of that language server
  -- pyright = function(_, opts) require("lspconfig").pyright.setup(opts) end -- or a custom handler function can be passed
}

-- customize language server configuration options passed to `lspconfig`
M.config = {
  
  lua_ls = {
    settings = {
      Lua = {
        hint = {
          enable = true,
          arrayIndex = "Disable",
        },
      },
    },
  },
  vtsls = {
    settings = {
      javascript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
          parameterTypes = { enabled = false },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = false },
        },
        suggest = {
          completeFunctionCalls = true,
        },
        updateImportsOnFileMove = { enabled = "always" },
      },
      typescript = {
        inlayHints = {
          parameterNames = { enabled = "literals" },
          functionLikeReturnTypes = { enabled = true },
          enumMemberValues = { enabled = true },
          parameterTypes = { enabled = false },
          variableTypes = { enabled = false },
          propertyDeclarationTypes = { enabled = false },
        },
        suggest = {
          completeFunctionCalls = true,
        },
        updateImportsOnFileMove = { enabled = "always" },
      },
      vtsls = {
        autoUseWorkspaceTsdk = true,
        enableMoveToFileCodeAction = true,
        experimental = {
          maxInlayHintLength = 30,
          completion = {
            enableServerSideFuzzyMatch = true,
          },
        },
      },
    },
  },
  tailwindcss = {
    -- root_dir = require("lspconfig").util.root_pattern(
    --   "tailwind.config.js",
    --   "tailwind.config.cjs",
    --   "tailwind.config.ts",
    --   "postcss.config.js",
    --   "postcss.config.cjs",
    --   "postcss.config.ts"
    -- ),
  },
}

return M

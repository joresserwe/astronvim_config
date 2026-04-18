return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  -- {
  --   "pmizio/typescript-tools.nvim",
  --   dependencies = {
  --     ---@type AstroLSPOpts
  --     "AstroNvim/astrolsp",
  --     optional = true,
  --     ---@diagnostic disable: missing-fields
  --     opts = {
  --       handlers = { tsserver = false }, -- disable tsserver setup, this plugin does it
  --       config = {
  --         ["typescript-tools"] = { -- enable inlay hints by default for `typescript-tools`
  --           settings = {
  --             tsserver_file_preferences = {
  --               includeInlayParameterNameHints = "all",
  --               includeInlayParameterNameHintsWhenArgumentMatchesName = false,
  --               includeInlayFunctionParameterTypeHints = true,
  --               includeInlayVariableTypeHints = true,
  --               includeInlayVariableTypeHintsWhenTypeMatchesName = false,
  --               includeInlayPropertyDeclarationTypeHints = true,
  --               includeInlayFunctionLikeReturnTypeHints = true,
  --               includeInlayEnumMemberValueHints = true,
  --             },
  --           },
  --         },
  --       },
  --     },
  --   },
  --   ft = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
  --   -- get AstroLSP provided options like `on_attach` and `capabilities`
  --   opts = function()
  --     local astrolsp_avail, astrolsp = pcall(require, "astrolsp")
  --     if astrolsp_avail then return astrolsp.lsp_opts "typescript-tools" end
  --   end,
  -- },
  {
    "dmmulroy/tsc.nvim",
    cmd = "TSC",
    opts = {},
  },
}

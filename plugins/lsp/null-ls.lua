return {
  "jose-elias-alvarez/null-ls.nvim",
  opts = function(_, config)
    -- config variable is the default configuration table for the setup function call

    local null_ls = require "null-ls"
    local utils = require "astronvim.utils"

    -- Check supported formatters and linters
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/formatting
    -- https://github.com/jose-elias-alvarez/null-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
    config.sources = utils.list_insert_unique(config.sources, {
      null_ls.builtins.formatting.deno_fmt.with {
        filetypes = { "json", "jsonc", "markdown", "markdown_inline" },
      },
    })
    config.sources = utils.list_insert_unique(config.sources, require "typescript.extensions.null-ls.code-actions")
    return config -- return final config table
  end,
}

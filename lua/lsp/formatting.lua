local M = {}

-- conform.nvim
M.conform_opts = {
  formatters_by_ft = {
    lua = { "stylua" },
    javascript = { "biome" },
    javascriptreact = { "biome" },
    typescript = { "biome" },
    typescriptreact = { "biome" },
    json = { "biome" },
    html = { "stylelint", "prettierd", stop_after_first = true },
    css = { "stylelint", "prettierd", stop_after_first = true },
    scss = { "stylelint", "prettierd", stop_after_first = true },
    less = { "stylelint", "prettierd", stop_after_first = true },
    sh = { "shfmt" },
    zsh = { "shfmt" },
    markdown = { "mdformat" },
    -- Conform will run multiple formatters sequentially
    -- python = { "isort", "black" },
    -- Use a sub-list to run only the first available formatter
    -- javascript = { { "prettierd", "prettier" } },
  },
  formatters = {
    biome = {
      command = "biome",
      args = {
        "check",
        "--write",
        "--stdin-file-path",
        "$FILENAME",
      },
      stdin = true,
    },
  },
}
-- nvim-lint
M.linters_by_ft = {
  -- javascript = { "biomejs", "eslint_d" },
  -- javascriptreact = { "biomejs", "eslint_d" },
  -- typescript = { "biomejs" },
  -- typescript = { "biomejs", "eslint_d" },
  -- typescriptreact = { "biomejs", "eslint_d" },
  css = { "stylelint" },
  scss = { "stylelint" },
  less = { "stylelint" },
  sh = { "shellcheck" },
  marksman = { "marksman" },
}

-- customize lsp formatting options
M.formatting = {
  -- control auto formatting on save
  format_on_save = {
    enabled = false, -- enable or disable format on save globally
    allow_filetypes = { -- enable format on save for specified filetypes only
      -- "go",
    },
    ignore_filetypes = { -- disable format on save for specified filetypes
      -- "python",
    },
  },
  disabled = { -- disable formatting capabilities for the listed language servers
    -- disable lua_ls formatting capability if you want to use StyLua to format your lua code
  },
  filter = function(client) -- fully override the default formatting function
    -- INFO: conform을 대신 사용!!

    -- use plugin.lsp.formatting
    -- local formatter_filter = { "null-ls" }
    -- return vim.tbl_contains(formatter_filter, client.name)
    return true
  end,
}

return M

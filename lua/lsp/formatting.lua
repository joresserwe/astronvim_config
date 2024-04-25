local M = {}

-- conform.nvim
M.formatters_by_ft = {
  lua = { "stylua" },
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  json = { "jq" },
  html = { { "stylelint", "prettierd" } },
  css = { { "stylelint", "prettierd" } },
  scss = { { "stylelint", "prettierd" } },
  less = { { "stylelint", "prettierd" } },
  sh = { "shfmt" },
  zsh = { "shfmt" },

  -- Conform will run multiple formatters sequentially
  -- python = { "isort", "black" },
  -- Use a sub-list to run only the first available formatter
  -- javascript = { { "prettierd", "prettier" } },
}

-- nvim-lint
M.linters_by_ft = {
  javascriptreact = { "eslint_d" },
  typescriptreact = { "eslint_d" },
  css = { "stylelint" },
  scss = { "stylelint" },
  less = { "stylelint" },
  sh = { "shellcheck" },
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
  --timeout_ms = 1000, -- default format timeout
}

return M

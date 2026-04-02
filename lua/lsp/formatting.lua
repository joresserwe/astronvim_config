local M = {}

-- conform.nvim
M.conform_opts = {
  formatters_by_ft = {
    lua = { "stylua" },

    html = { "stylelint", "prettierd", stop_after_first = true },
    css = { "stylelint", "prettierd", stop_after_first = true },
    scss = { "stylelint", "prettierd", stop_after_first = true },
    less = { "stylelint", "prettierd", stop_after_first = true },
    sh = { "shfmt" },
    zsh = { "shfmt" },
    markdown = { "mdformat" },
  },
  formatters = {
  },
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
  },
  filter = function(client) -- fully override the default formatting function
    -- INFO: conform을 대신 사용!!
    return true
  end,
}

return M

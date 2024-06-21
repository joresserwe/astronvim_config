local M = {}

M.mason = function(_, opts)
  -- add more things to the ensure_installed table protecting against community packs modifying it
  opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
    "eslint_d",
    "js-debug-adapter",
    "lua-language-server",
    "stylua",
    "typescript-language-server",
    "tailwindcss-language-server",
    "html-lsp",
    "css-lsp",
    "emmet-ls",
    "prettierd",
    "stylelint",
    "bash-language-server",
    "shfmt",
    "shellcheck"
    -- "marksman",
  })
end

M.treesitter = function(_, opts)
  -- add more things to the ensure_installed table protecting against community packs modifying it
  opts.ensure_installed = require("astrocore").list_insert_unique(opts.ensure_installed, {
    "html",
    "css",
    "javascript",
    "typescript",
    "tsx",
    "jsdoc",
    "bash",
    -- "lua",
    -- "luap",
    -- "json",
    -- "jsonc",
    -- "markdown",
    -- "markdown_inline",
    -- "yaml",
  })
end
return M

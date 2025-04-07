return function(opts)
  local astro = require "astrocore"
  local is_available = astro.is_available
  local mappings = astro.empty_map_table()

  mappings.i["<>"] = {
    "<></><left><left><left>",
    desc = "which_key_ignore",
    cond = function() return vim.tbl_contains({ "javascriptreact", "typescriptreact" }, vim.bo.filetype) end,
  }

  mappings.n["sp"] = {
    "<cmd>MarkdownPreviewToggle<cr>",
    desc = "Toggle Markdown Preview",
    cond = function() return vim.bo.filetype == "markdown" and is_available "markdown-preview.nvim" end,
  }

  -- LSP Code Action
  local code_action = vim.tbl_get(opts, "mappings", "n", "<Leader>la")
  if code_action then
    mappings.n[";a"] = code_action
    mappings.v[";a"] = code_action
    mappings.n["<Leader>la"] = false
    mappings.v["<Leader>la"] = false
  end

  -- telescope diagnostic
  local telescope_diagnostic = vim.tbl_get(opts, "mappings", "n", "<Leader>lD")
  if telescope_diagnostic then
    mappings.n["<Leader>fd"] = telescope_diagnostic
    mappings.n["<Leader>lD"] = false
  end

  -- LSP Default rename symbol 비활성화
  if is_available "inc-rename.nvim" then
    mappings.n[";r"] = {
      function()
        require "inc_rename"
        return ":IncRename " .. vim.fn.expand "<cword>"
      end,
      expr = true,
      desc = "IncRename",
    }
    mappings.n["<Leader>lr"] = false
  end

  -- Disable mappings
  mappings.n["<Leader>lR"] = false -- use 'gr'

  -- a `cond` key can provided as the string of a server capability to be required to attach, or a function with `client` and `bufnr` parameters from the `on_attach` that returns a boolean
  mappings.n["<Leader>g'"] = {
    function() vim.lsp.buf.declaration() end,
    desc = "Declaration of current symbol",
    cond = "textDocument/declaration",
  }
  
  mappings.n["<Leader>uY"] = {
    function() require("astrolsp.toggles").buffer_semantic_tokens() end,
    desc = "Toggle LSP semantic highlight (buffer)",
    cond = function(client)
      return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens ~= nil
    end,
  }
  
  return mappings
end

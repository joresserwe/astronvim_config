-- A custom `on_attach` function to be run after the default `on_attach` function
-- takes two parameters `client` and `bufnr`  (`:h lspconfig-setup`)
return function(client, bufnr)
  -- this would disable semanticTokensProvider for all clients
  -- client.server_capabilities.semanticTokensProvider = nil
  -- vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  --   border = border.default[vim.g.border],
  -- })
  -- vim.lsp.handlers["textDocument/signatureHelp"] =
  --   vim.lsp.with(vim.lsp.handlers.signature_help, {
  --     border = border.default[vim.g.border],
  --   })
  -- vim.diagnostic.config {
  --   float = { border = border.default[vim.g.border] },
  -- }
  --
  --client.server_capabilities.documentFormattingProvider = false
end

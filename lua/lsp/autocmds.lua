-- Configure buffer local auto commands to add when attaching a language server
return {
  -- first key is the `augroup` to add the auto commands to (:h augroup)
  lsp_codelens_refresh = {
    -- Optional condition to create/delete auto command group
    -- can either be a string of a client capability or a function of `fun(client, bufnr): boolean`
    -- condition will be resolved for each client on each execution and if it ever fails for all clients,
    -- the auto commands will be deleted for that buffer
    cond = "textDocument/codeLens",
    -- cond = function(client, bufnr) return client.name == "lua_ls" end,
    -- list of auto commands to set
    {
      -- events to trigger
      event = { "InsertLeave", "BufEnter" },
      -- the rest of the autocmd options (:h nvim_create_autocmd)
      desc = "Refresh codelens (buffer)",
      callback = function(args)
        if require("astrolsp").config.features.codelens then vim.lsp.codelens.refresh { bufnr = args.buf } end
      end,
    },
  },
}

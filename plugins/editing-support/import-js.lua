return {
  "kristijanhusak/vim-js-file-import",
  dependencies = {
    "ludovicchabant/vim-gutentags",
  },
  ft = { "javascript", "typescript", "javascriptreact", "typescriptreact" },
  keys = {
    {";i", mode="n", "<Cmd>JsFileImport<CR>" ,desc="JS File Import"}
  },
  config = function()
    vim.g.js_file_import_no_mappings = 1
    vim.g.js_file_import_use_fzf = 1
    --require("vim-js-file-import").setup()
  end
}

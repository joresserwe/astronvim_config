local utils = require "astronvim.utils"

local function on_file_remove(args)
  local ts_clients = vim.lsp.get_active_clients { name = "tsserver" }
  for _, ts_client in ipairs(ts_clients) do
    ts_client.request("workspace/executeCommand", {
      command = "_typescript.applyRenameFile",
      arguments = {
        {
          sourceUri = vim.uri_from_fname(args.source),
          targetUri = vim.uri_from_fname(args.destination),
        },
      },
    })
  end
end

return {
  {
    "vuki656/package-info.nvim",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {},
    event = "BufRead package.json",
  },
  {
    "jose-elias-alvarez/typescript.nvim",
    init = function() astronvim.lsp.skip_setup = utils.list_insert_unique(astronvim.lsp.skip_setup, "tsserver") end,
    ft = {
      "typescript",
      "typescriptreact",
      "javascript",
      "javascriptreact",
    },
    opts = function() return { server = require("astronvim.utils.lsp").config "tsserver" } end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    opts = function(_, opts)
      local events = require "neo-tree.events"
      if not opts.event_handlers then opts.event_handlers = {} end
      vim.list_extend(opts.event_handlers, {
        { event = events.FILE_MOVED, handler = on_file_remove },
        { event = events.FILE_RENAMED, handler = on_file_remove },
      })
    end,
  },
  {
    "dmmulroy/tsc.nvim",
    cmd = { "TSC" },
    opts = {},
  },
  {
    "mfussenegger/nvim-dap",
    optional = true,
    config = function()
      local dap = require "dap"
      dap.adapters["pwa-node"] = {
        type = "server",
        host = "localhost",
        port = "${port}",
        executable = {
          command = "node",
          args = {
            require("mason-registry").get_package("js-debug-adapter"):get_install_path()
              .. "/js-debug/src/dapDebugServer.js",
            "${port}",
          },
        },
      }
      local js_config = {
        {
          type = "pwa-node",
          request = "launch",
          name = "Launch file",
          program = "${file}",
          cwd = "${workspaceFolder}",
        },
        {
          type = "pwa-node",
          request = "attach",
          name = "Attach",
          processId = require("dap.utils").pick_process,
          cwd = "${workspaceFolder}",
        },
      }

      if not dap.configurations.javascript then
        dap.configurations.javascript = js_config
      else
        utils.extend_tbl(dap.configurations.javascript, js_config)
      end
    end,
  },
  -- {
  --   "kristijanhusak/vim-js-file-import",
  --   dependencies = {
  --     "ludovicchabant/vim-gutentags",
  --   },
  --   ft = {
  --     "typescript",
  --     "typescriptreact",
  --     "javascript",
  --     "javascriptreact",
  --   },
  --   keys = {
  --     { ";i", mode = "n", "<Cmd>JsFileImport<CR>", desc = "JS File Import" },
  --   },
  --   config = function()
  --     vim.g.js_file_import_no_mappings = 1
  --     vim.g.js_file_import_use_fzf = 1
  --     --require("vim-js-file-import").setup()
  --   end,
  -- },
  -- {
  --   "Galooshi/vim-import-js",
  --   ft = {
  --     "typescript",
  --     "typescriptreact",
  --     "javascript",
  --     "javascriptreact",
  --   },
  -- },
}

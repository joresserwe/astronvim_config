-- JavaScript/TypeScript DAP 어댑터 + 기본 configuration.
-- mason으로 설치된 js-debug-adapter를 사용한 pwa-node 구동.
return {
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
      vim.list_extend(dap.configurations.javascript, js_config)
    end
  end,
}

-- AstroCore provides a central place to modify mappings, vim options, autocommands, and more!
-- Configuration documentation can be found with `:h astrocore`
-- NOTE: We highly recommend setting up the Lua Language Server (`:LspInstall lua_ls`)
--       as this provides autocomplete and documentation while editing

---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = function(_, opts)
    local extend_tbl = require("astrocore").extend_tbl

    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    opts.diagnostics = extend_tbl(opts.diagnostics, require "core.diagnostics")

    -- Configure core features of AstroNvim
    opts.features = extend_tbl(opts.features, require("core.options").features)

    -- vim options can be configured here
    opts.options = extend_tbl(opts.options, require("core.options").options)

    -- vim options can be configured here
    opts.filetypes = extend_tbl(opts.options, require("core.options").filetypes)

    -- Mappings can be configured through AstroCore as well.
    opts.mappings = extend_tbl(opts.mappings, require "core.mappings"(opts))

    -- Configure buffer local auto commands
    opts.autocmds = extend_tbl(opts.autocmds, require "core.autocmds")
  end,
}

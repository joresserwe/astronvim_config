---@type LazySpec
return {
  "AstroNvim/astrocore",
  ---@params opts AstroCoreOpts
  opts = function(_, opts)
    local extend_tbl = require("astrocore").extend_tbl

    -- Diagnostics configuration (for vim.diagnostics.config({...})) when diagnostics are on
    opts.diagnostics = extend_tbl(opts.diagnostics, require("core.diagnostics"))
    -- Configure core features of AstroNvim
    opts.features = extend_tbl(opts.features, require("core.options").features)
    -- vim options can be configured here
    opts.options = extend_tbl(opts.options, require("core.options").options)
    -- Mappings can be configured through AstroCore as well.
    opts.mappings = extend_tbl(opts.mappings, require("core.mappings")(opts))
  end,
}

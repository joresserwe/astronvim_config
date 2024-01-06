local utils = require "astronvim.utils"
local is_available = utils.is_available

local maps = { n = {} }

if is_available "inc-rename.nvim" then maps.n["<leader>lr"] = { ":IncRename ", desc = "Inc rename symbol" } end

return maps

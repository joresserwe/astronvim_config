-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local sections = {
  ["'"] = { desc = get_icon("Package", 1, true) .. "Packages" },
  [","] = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
}

return {
  [""] = {
    ["("] = { "10k" },
    [")"] = { "10j" },
    ["y"] = { '"ky', desc = "copy to inner clipboard" },
    ["Y"] = { "y", desc = "copy to system clipboard" },
    ["p"] = { '"kp', desc = "paste from inner clipboard ('k')" },
    ["P"] = { "p", desc = "paste from system clipboard" },
  },
  n = {
    ["<leader>c"] = { "ciw", desc = "단어 편집" },
    ["<leader>x"] = { "viwx", desc = "단어 제거(clipboard x)" },
    ["<leader>d"] = { "viwd", desc = "단어 제거(clipboard o)" },
    ["<leader>p"] = { 'viw"kP', desc = "paste from inner clipboard('k')" },
    ["<leader>P"] = { "viwP", desc = "paste from system clipboard" },
    ["yy"] = { '"kyy' },
    ["<C-a>"] = { "gg<S-v>G" },

    ["<S-h>"] = { "h", desc = "오타 방지" },
    ["<S-l>"] = { "l", desc = "오타 방지" },

    ["<leader>o"] = { "o<ESC>", desc = "아래로 한줄 띄기" },
    ["<leader>O"] = { "O<ESC>", desc = "위로 한줄 띄기" },
    ["<leader><CR>"] = { "i<CR><ESC>k", desc = "현재 커서 위치에서 줄바꿈" },

    -- Split
    -- ["<leader>\\"] = { "<C-w>v<C-w>l", desc = "세로 분할" },
    ["<leader>\\"] = { "<C-w>v", desc = "세로 분할" },
    ["<leader>-"] = { "<C-w>s", desc = "가로 분할" },
    ["<C-=>"] = { "<C-w>>" },
    ["<C-9>"] = { "<C-w><" },
    ["<C-_>"] = { "<C-w>-" },
    ["<C-0>"] = { "<C-w>+" },

    ["<leader>w"] = { function() require("astronvim.utils.buffer").close() end, desc = "Close buffer" },
    ["<leader>qa"] = { function() require("astronvim.utils.buffer").close_all() end, desc = "Close all buffers" },
    ["<tab>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<S-tab>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- multi cursor
    ["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" },
    ["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" },

    -- telescope
    ["<leader>f/"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" },
    ["<leader>f?"] = {
      function()
        require("telescope.builtin").live_grep {
          additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
        }
      end,
      desc = "Find words(숨김파일포함)",
    },
    ["<leader>fe"] = {
      function() require("telescope.builtin").oldfiles { cwd_only = true } end,
      desc = "Find history in CWD",
    },
    ["<leader>fE"] = { function() require("telescope.builtin").oldfiles {} end, desc = "Find history All Path" },
    ["<leader>fo"] = false,
    ["<leader>fw"] = false,
    ["<leader>fW"] = false,

    -- Plugin Manager (<leader>p => <leader>')
    ["<leader>'"] = sections["'"],
    ["<leader>'i"] = { function() require("lazy").install() end, desc = "Plugins Install" },
    ["<leader>'s"] = { function() require("lazy").home() end, desc = "Plugins Status" },
    ["<leader>'S"] = { function() require("lazy").sync() end, desc = "Plugins Sync" },
    ["<leader>'u"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" },
    ["<leader>'U"] = { function() require("lazy").update() end, desc = "Plugins Update" },

    -- AstroNvim (<leader>p => <leader>')
    ["<leader>'a"] = { "<cmd>AstroUpdatePackages<cr>", desc = "Update Plugins and Mason Packages" },
    ["<leader>'A"] = { "<cmd>AstroUpdate<cr>", desc = "AstroNvim Update" },
    ["<leader>'v"] = { "<cmd>AstroVersion<cr>", desc = "AstroNvim Version" },
    ["<leader>'l"] = { "<cmd>AstroChangelog<cr>", desc = "AstroNvim Changelog" },

    -- Disabled
    ["<leader>q"] = false,
    ["\\"] = false,
    ["|"] = false,

    -- surround
    ["<leader>y"] = { "ysiw", remap = false, desc = "Surround word" },
  },
  x = {
    -- visual
    ["J"] = { ":move '>+1<CR>gv-gv", desc = "한줄 아래로 내림" },
    ["K"] = { ":move '<-2<CR>gv-gv", desc = "한줄 위로 올림" },
    ["<"] = { "<gv" },
    [">"] = { ">gv" },

    ["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" },
  },
}

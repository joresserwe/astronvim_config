-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
-- TODO
-- telescope-live-grep-args 확인
-- autosave시 null-ls 동작하게
-- markdown-and-latex 플러그인 확인
--
local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local sections = {
  ["'"] = { desc = get_icon("Package", 1, true) .. "Packages" },
  [","] = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
}

local maps = {
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
    ["<leader>\\"] = { "<C-w>v", desc = "세로 분할" },
    ["<leader>-"] = { "<C-w>s", desc = "가로 분할" },
    ["<leader>m"] = { "<C-w>x", desc = "가로 분할" },
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

    -- NeoTree
    ["<leader>E"] = {
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd "p"
        else
          vim.cmd.Neotree "focus"
        end
      end,
      desc = "Toggle Explorer Focus",
    },

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

    -- surround
    ["<leader>y"] = { "ysiw", remap = false, desc = "Surround word" },
  },
  x = {
    -- visual
    ["J"] = { ":move '>+1<CR>gv-gv", desc = "한줄 아래로 내림" },
    ["K"] = { ":move '<-2<CR>gv-gv", desc = "한줄 위로 올림" },
    ["<"] = { "<gv" },
    [">"] = { ">gv" },
  },
}

-- Telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f/"] = { function() require("telescope.builtin").live_grep() end, desc = "Find words" }
  maps.n["<leader>f?"] = {
    function()
      require("telescope.builtin").live_grep {
        additional_args = function(args) return vim.list_extend(args, { "--hidden", "--no-ignore" }) end,
      }
    end,
    desc = "Find words(숨김파일포함)",
  }
  maps.n["<leader>fe"] = {
    function() require("telescope.builtin").oldfiles { cwd_only = true } end,
    desc = "Find history in CWD",
  }
  maps.n["<leader>fE"] = { function() require("telescope.builtin").oldfiles {} end, desc = "Find history All Path" }
  maps.n["<leader>fz"] = { function() require("telescope").extensions.zoxide.list() end, desc = "Find directories" }
end

-- Session Manager (<leader>S => <leader>s)
if is_available "neovim-session-manager" then
  maps.n["<leader>s"] = sections.s
  maps.n["<leader>sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
  maps.n["<leader>ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
  maps.n["<leader>sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>s."] =
    { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }
end
if is_available "resession.nvim" then
  maps.n["<leader>s"] = sections.s
  maps.n["<leader>sl"] = { function() require("resession").load "Last Session" end, desc = "Load last session" }
  maps.n["<leader>ss"] = { function() require("resession").save() end, desc = "Save this session" }
  maps.n["<leader>st"] = { function() require("resession").save_tab() end, desc = "Save this tab's session" }
  maps.n["<leader>sd"] = { function() require("resession").delete() end, desc = "Delete a session" }
  maps.n["<leader>sf"] = { function() require("resession").load() end, desc = "Load a session" }
  maps.n["<leader>s."] = {
    function() require("resession").load(vim.fn.getcwd(), { dir = "dirsession" }) end,
    desc = "Load current directory session",
  }
end

-- Multicursor
if is_available "multicursors.nvim" then
  -- multi cursor
  maps.n["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" }
  maps.n["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" }
  maps.x["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" }
end

-- Package Manager (<leader>p => <leader>')
if is_available "mason.nvim" then
  maps.n["<leader>'m"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
  maps.n["<leader>'M"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
end

-- ###############Disabled Keys################
maps.n["|"] = false
maps.n["\\"] = false
maps.n["]t"] = false
maps.n["[t"] = false

maps.n["<leader>h"] = false

maps.n["<leader>pm"] = false
maps.n["<leader>pM"] = false
maps.n["<leader>pi"] = false
maps.n["<leader>ps"] = false
maps.n["<leader>pS"] = false
maps.n["<leader>pu"] = false
maps.n["<leader>pU"] = false
maps.n["<leader>pa"] = false
maps.n["<leader>pA"] = false
maps.n["<leader>pv"] = false
maps.n["<leader>pl"] = false

maps.n["<leader>S"] = false
maps.n["<leader>Sl"] = false
maps.n["<leader>Ss"] = false
maps.n["<leader>Sd"] = false
maps.n["<leader>Sf"] = false
maps.n["<leader>St"] = false
maps.n["<leader>Sf"] = false
maps.n["<leader>S."] = false

maps.n["<leader>c"] = false
maps.n["<leader>C"] = false

maps.n["<leader>fo"] = false
maps.n["<leader>fw"] = false
maps.n["<leader>fW"] = false
-- ##########################################
return maps

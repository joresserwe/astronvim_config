-- Mapping data with "desc" stored directly by vim.keymap.set().
--
-- Please use this mappings table to set keyboard mapping since this is the
-- lower level configuration and more robust one. (which-key will
-- automatically pick-up stored data by this setting.)
--
-- TODO
-- telescope-live-grep-args 확인

local utils = require "astronvim.utils"
local get_icon = utils.get_icon
local is_available = utils.is_available
local sections = {
  ["'"] = { desc = get_icon("Package", 1, true) .. "Packages" },
  [","] = { desc = get_icon("Debugger", 1, true) .. "Debugger" },
  ["ss"] = { desc = get_icon("Session", 1, true) .. "Session" },
  ["s"] = { desc = get_icon("Session", 1, true) .. "Show" },
}

local maps = {
  [""] = {
    ["("] = { "10k" },
    [")"] = { "10j" },
    ["x"] = { '"_x' },
    ["c"] = { '"_c' },
    ["y"] = { '"iy' },
    ["Y"] = { "y" },
    ["d"] = { '"dd' },
    ["ps"] = { "p", desc = "paste from system clipboard" },
    ["pi"] = { '"ip', desc = "paste from inner clipboard ('k')" },
    ["pd"] = { '"dp', desc = "paste from deleted" },
  },

  n = {
    -- copy & paste
    ["<leader>c"] = { '"_ciw', desc = "단어 편집" },
    ["<leader>x"] = { "viwx", remap = true, desc = "단어 제거(clipboard x)" },
    ["<leader>d"] = { "viwd", remap = true, desc = "단어 제거(clipboard o)" },
    ["<leader>pi"] = { 'viw"_x"iP', desc = "paste from inner clipboard('i')" },
    ["<leader>pd"] = { 'viw"_x"dP', desc = "paste from deleted" },
    ["<leader>ps"] = { 'viw"_xP', desc = "paste from system clipboard" },
    ["yy"] = { '"iyy' },
    ["Yy"] = { "yy" },
    ["dd"] = { '"ddd' },

    ["<C-a>"] = { "gg<S-v>G" },

    ["<S-h>"] = { "h", desc = "오타 방지" },
    ["<S-l>"] = { "l", desc = "오타 방지" },

    ["<leader>o"] = { "o<ESC>", desc = "아래로 한줄 띄기" },
    ["<leader>O"] = { "O<ESC>", desc = "위로 한줄 띄기" },
    ["<leader><CR>"] = { "i<CR><ESC>k", desc = "현재 커서 위치에서 줄바꿈" },

    -- Split
    ["<leader>\\"] = { "<C-w>v", desc = "세로 분할" },
    ["<leader>-"] = { "<C-w>s", desc = "가로 분할" },
    ["<leader>="] = { "<C-w>x", desc = "분할창 순서 변경" },
    ["<leader>m"] = { function() vim.fn["zoom#toggle"]() end, desc = "Zoom Pane" },
    ["<C-=>"] = { "<C-w>>" },
    ["<C-9>"] = { "<C-w><" },
    ["<C-_>"] = { "<C-w>-" },
    ["<C-0>"] = { "<C-w>+" },

    ["<leader>w"] = { function() require("astronvim.utils.buffer").close() end, desc = "Close buffer" },
    ["<tab>"] = {
      function() require("astronvim.utils.buffer").nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    },
    ["<S-tab>"] = {
      function() require("astronvim.utils.buffer").nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    },

    -- NeoTree
    ["<leader>e"] = {
      function()
        if vim.bo.filetype == "neo-tree" then
          vim.cmd.wincmd "c"
          vim.cmd.wincmd "p"
        else
          vim.cmd.Neotree "focus"
        end
      end,
      desc = "Toggle Explorer Focus",
    },

    -- surround
    ["<leader>y"] = { "ysiw", remap = true, desc = "Surround word" },
  },
  x = {
    -- visual
    ["J"] = { ":move '>+1<CR>gv-gv", desc = "한줄 아래로 내림" },
    ["K"] = { ":move '<-2<CR>gv-gv", desc = "한줄 위로 올림" },
    ["<"] = { "<gv" },
    [">"] = { ">gv" },
    ["mf"] = { "<C-v>^<S-i>", desc = "multicursor for visual" },
    ["mb"] = { "<C-v>$<S-a>", desc = "multicursor for visual" },
  },
  t = {
    ["<C-=>"] = { "<C-w>>" },
    ["<C-9>"] = { "<C-w><" },
    ["<C-_>"] = { "<C-w>-" },
    ["<C-0>"] = { "<C-w>+" },
  },
}

-- NeoTree
if is_available "neo-tree.nvim" then
  maps.n["<leader>e"] = {
    function()
      if vim.bo.filetype == "neo-tree" then
        vim.cmd.Neotree "toggle"
      else
        vim.cmd.Neotree "focus"
      end
    end,
    desc = "Toggle Explorer",
  }
end

-- Telescope
if is_available "telescope.nvim" then
  maps.n["<leader>f`"] = { function() require("telescope.builtin").marks() end, desc = "Find marks" }
  maps.n["<leader>f'"] = { function() require("telescope.builtin").registers() end, desc = "Find registers" }
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
  if is_available "telescope-import.nvim" then
    maps.n["<leader>fi"] =
      { function() require("telescope").extensions.import.import {} end, desc = "Open import Browser" }
  end
  maps.n["<leader>fs"] = {
    function()
      local aerial_avail, _ = pcall(require, "aerial")
      if aerial_avail then
        require("telescope").extensions.aerial.aerial()
      else
        require("telescope.builtin").lsp_document_symbols()
      end
    end,
    desc = "Search symbols",
  }
  maps.n["<leader>fz"] = { function() require("telescope").extensions.zoxide.list() end, desc = "Find directories" }
  if is_available "telescope-file-browser.nvim" then
    maps.n["<leader>fu"] = { function() require("telescope").extensions.undo.undo {} end, desc = "Find Undo" }
  end
end

-- Session Manager (<leader>S => <leader>s)
if is_available "neovim-session-manager" then
  maps.n["<leader>s"] = sections.ss
  maps.n["<leader>sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
  maps.n["<leader>ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
  maps.n["<leader>sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>s."] =
    { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }
end

if is_available "resession.nvim" then
  maps.n["<leader>s"] = sections.ss
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
  maps.n["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" }
  maps.n["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" }
  maps.x["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" }
end

-- Plugin/AstroNvim/Package Manager (<leader>p => <leader>')
maps.n["<leader>'"] = sections["'"]
maps.n["<leader>'i"] = { function() require("lazy").install() end, desc = "Plugins Install" }
maps.n["<leader>'s"] = { function() require("lazy").home() end, desc = "Plugins Status" }
maps.n["<leader>'S"] = { function() require("lazy").sync() end, desc = "Plugins Sync" }
maps.n["<leader>'u"] = { function() require("lazy").check() end, desc = "Plugins Check Updates" }
maps.n["<leader>'U"] = { function() require("lazy").update() end, desc = "Plugins Update" }
maps.n["<leader>'a"] = { "<cmd>AstroUpdatePackages<cr>", desc = "Update Plugins and Mason Packages" }
maps.n["<leader>'A"] = { "<cmd>AstroUpdate<cr>", desc = "AstroNvim Update" }
maps.n["<leader>'v"] = { "<cmd>AstroVersion<cr>", desc = "AstroNvim Version" }
maps.n["<leader>'l"] = { "<cmd>AstroChangelog<cr>", desc = "AstroNvim Changelog" }
if is_available "mason.nvim" then
  maps.n["<leader>'m"] = { "<cmd>Mason<cr>", desc = "Mason Installer" }
  maps.n["<leader>'M"] = { "<cmd>MasonUpdateAll<cr>", desc = "Mason Update" }
end

-- Debugger (<leader>d => <leader>,)
if is_available "nvim-dap" then
  maps.n["<leader>,"] = sections[","]
  maps.x["<leader>,"] = sections[","]
  maps.n["<leader>,b"] = { function() require("dap").toggle_breakpoint() end, desc = "Toggle Breakpoint (F9)" }
  maps.n["<leader>,B"] = { function() require("dap").clear_breakpoints() end, desc = "Clear Breakpoints" }
  maps.n["<leader>,c"] = { function() require("dap").continue() end, desc = "Start/Continue (F5)" }
  maps.n["<leader>,C"] = {
    function()
      vim.ui.input({ prompt = "Condition: " }, function(condition)
        if condition then require("dap").set_breakpoint(condition) end
      end)
    end,
    desc = "Conditional Breakpoint (S-F9)",
  }
  maps.n["<leader>,i"] = { function() require("dap").step_into() end, desc = "Step Into (F11)" }
  maps.n["<leader>,o"] = { function() require("dap").step_over() end, desc = "Step Over (F10)" }
  maps.n["<leader>,O"] = { function() require("dap").step_out() end, desc = "Step Out (S-F11)" }
  maps.n["<leader>,q"] = { function() require("dap").close() end, desc = "Close Session" }
  maps.n["<leader>,Q"] = { function() require("dap").terminate() end, desc = "Terminate Session (S-F5)" }
  maps.n["<leader>,p"] = { function() require("dap").pause() end, desc = "Pause (F6)" }
  maps.n["<leader>,r"] = { function() require("dap").restart_frame() end, desc = "Restart (C-F5)" }
  maps.n["<leader>,R"] = { function() require("dap").repl.toggle() end, desc = "Toggle REPL" }
  maps.n["<leader>,s"] = { function() require("dap").run_to_cursor() end, desc = "Run To Cursor" }

  if is_available "nvim-dap-ui" then
    maps.n["<leader>,E"] = {
      function()
        vim.ui.input({ prompt = "Expression: " }, function(expr)
          if expr then require("dapui").eval(expr, { enter = true }) end
        end)
      end,
      desc = "Evaluate Input",
    }
    maps.x["<leader>,E"] = { function() require("dapui").eval() end, desc = "Evaluate Input" }
    maps.n["<leader>,u"] = { function() require("dapui").toggle() end, desc = "Toggle Debugger UI" }
    maps.n["<leader>,h"] = { function() require("dap.ui.widgets").hover() end, desc = "Debugger Hover" }
  end
end

maps.n["s"] = sections.s
if is_available "telescope-file-browser.nvim" then
  maps.n["su"] = { function() require("telescope").extensions.undo.undo {} end, desc = "Find Undo" }
end
if is_available "telescope-file-browser.nvim" then
  maps.n["sf"] =
    { function() require("telescope").extensions.file_browser.file_browser {} end, desc = "Open File Browser" }
end
if is_available "aerial.nvim" then
  maps.n["sh"] = { function() require("aerial").toggle() end, desc = "Symbols outline(Hierarchy)" }
end

if is_available "neovim-session-manager" then
  maps.n["<leader>sl"] = { "<cmd>SessionManager! load_last_session<cr>", desc = "Load last session" }
  maps.n["<leader>ss"] = { "<cmd>SessionManager! save_current_session<cr>", desc = "Save this session" }
  maps.n["<leader>sd"] = { "<cmd>SessionManager! delete_session<cr>", desc = "Delete session" }
  maps.n["<leader>sf"] = { "<cmd>SessionManager! load_session<cr>", desc = "Search sessions" }
  maps.n["<leader>s."] =
    { "<cmd>SessionManager! load_current_dir_session<cr>", desc = "Load current directory session" }
end

-- terminal
if is_available "toggleterm.nvim" then
  maps.n["<leader>t-"] = { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
  maps.n["<leader>t\\"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
end

-- AutoSave
if is_available "auto-save.nvim" then maps.n["<leader>uA"] = { "<cmd>ASToggle<cr>", desc = "Toggle Autosave" } end

-- disable key
maps.n["|"] = false
maps.n["\\"] = false
maps.n["<leader>C"] = false
maps.n["<leader>S"] = false
maps.n["<leader>S."] = false
maps.n["<leader>Sd"] = false
maps.n["<leader>Sf"] = false
maps.n["<leader>Sf"] = false
maps.n["<leader>Sl"] = false
maps.n["<leader>Ss"] = false
maps.n["<leader>St"] = false
maps.n["<leader>dB"] = false
maps.n["<leader>dC"] = false
maps.n["<leader>dE"] = false
maps.n["<leader>dO"] = false
maps.n["<leader>dQ"] = false
maps.n["<leader>dR"] = false
maps.n["<leader>db"] = false
maps.n["<leader>dc"] = false
maps.n["<leader>dh"] = false
maps.n["<leader>di"] = false
maps.n["<leader>do"] = false
maps.n["<leader>dp"] = false
maps.n["<leader>dq"] = false
maps.n["<leader>dr"] = false
maps.n["<leader>ds"] = false
maps.n["<leader>du"] = false
maps.n["<leader>fW"] = false
maps.n["<leader>fo"] = false
maps.n["<leader>fr"] = false
maps.n["<leader>fw"] = false
maps.n["<leader>h"] = false
maps.n["<leader>lS"] = false
maps.n["<leader>ls"] = false
maps.n["<leader>pA"] = false
maps.n["<leader>pM"] = false
maps.n["<leader>pS"] = false
maps.n["<leader>pU"] = false
maps.n["<leader>pa"] = false
maps.n["<leader>pl"] = false
maps.n["<leader>pm"] = false
maps.n["<leader>pu"] = false
maps.n["<leader>pv"] = false
maps.n["<leader>th"] = false
maps.n["<leader>tl"] = false
maps.n["<leader>tv"] = false

return maps

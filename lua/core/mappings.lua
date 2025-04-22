---@param opts AstroCoreOpts
return function(opts)
  local astro = require "astrocore"

  local is_available = astro.is_available
  local buffer = require "astrocore.buffer"
  local get_icon = require("astroui").get_icon

  opts._map_sections = astro.extend_tbl(opts._map_sections, {
    s = { desc = get_icon("Window", 1, true) .. "Show" },
  })

  local mappings = astro.extend_tbl(astro.empty_map_table(), {
    [""] = {
      ["("] = { "7k" },
      [")"] = { "7j" },
      ["x"] = { '"_x' },
      ["c"] = { '"_c' },
      ["y"] = { '"iy' },
      ["Y"] = { '"+y' },
      ["d"] = { '"dd' },
      ["ps"] = { '"+p', desc = "paste from system clipboard" },
      ["pi"] = { '"ip', desc = "paste from inner clipboard ('k')" },
      ["pd"] = { '"dp', desc = "paste from deleted" },
      ["Ps"] = { '"+P', desc = "paste from system clipboard" },
      ["Pi"] = { '"iP', desc = "paste from inner clipboard ('k')" },
      ["Pd"] = { '"dP', desc = "paste from deleted" },
    },
    n = {
      -- copy & paste
      ["<Leader>c"] = { '"_ciw', desc = "단어 편집" },
      ["<Leader>x"] = { "viwx", remap = true, desc = "단어 제거(clipboard x)" },
      ["<Leader>d"] = { "viwd", remap = true, desc = "단어 제거(clipboard o)" },
      ["<Leader>pi"] = { 'viw"_x"iP', desc = "paste from inner clipboard('i')" },
      ["<Leader>pd"] = { 'viw"_x"dP', desc = "paste from deleted" },
      ["<Leader>ps"] = { 'viw"_xP', desc = "paste from system clipboard" },
      ["yy"] = { '"iyy' },
      ["Yy"] = { '"+yy' },
      ["dd"] = { '"ddd' },

      ["<C-a>"] = { "gg<S-v>G" },

      ["<S-h>"] = { "h", desc = "오타 방지" },
      ["<S-l>"] = { "l", desc = "오타 방지" },

      ["<Leader>o"] = { "o<ESC>", desc = "아래로 한줄 띄기" },
      ["<Leader>O"] = { "O<ESC>", desc = "위로 한줄 띄기" },
      ["<Leader><CR>"] = { "i<CR><ESC>k", desc = "현재 커서 위치에서 줄바꿈" },

      -- Prevent conflict <C-i> and <Tab>
      ["<C-p>"] = { "<C-o>" },
      ["<C-n>"] = { "<C-i>" },
      ["<C-o>"] = { "<Nop>" },

      -- Split
      ["<Leader>\\"] = { "<C-w>v", desc = "세로 분할" },
      ["<Leader>-"] = { "<C-w>s", desc = "가로 분할" },
      ["<Leader>="] = { "<C-w>x", desc = "분할창 순서 변경" },
      ["<C-=>"] = { "<C-w>>" },
      ["<C-9>"] = { "<C-w><" },
      ["<C-_>"] = { "<C-w>-" },
      ["<C-0>"] = { "<C-w>+" },

      ["<Leader>w"] = {
        function()
          local bufs = vim.fn.getbufinfo { buflisted = true }
          buffer.close(0)
          if is_available "alpha-nvim" and not bufs[2] then require("alpha").start(true) end
        end,
        desc = "Close buffer",
      },

      -- surround
      ["<Leader>y"] = { "ysiw", remap = true, desc = "Surround word" },
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
  })

  -- NeoTree
  if is_available "neo-tree.nvim" then
    mappings.n["<Leader>e"] = {
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

  -- BufferLine Tab
  if is_available "bufferline.nvim" then
    mappings.n["<tab>"] = { function() require("bufferline").cycle(1) end, desc = "Next buffer" }
    mappings.n["<S-tab>"] = { function() require("bufferline").cycle(-1) end, desc = "Next buffer" }
  else
    mappings.n["<tab>"] = {
      function() buffer.nav(vim.v.count > 0 and vim.v.count or 1) end,
      desc = "Next buffer",
    }
    mappings.n["<S-tab>"] = {
      function() buffer.nav(-(vim.v.count > 0 and vim.v.count or 1)) end,
      desc = "Previous buffer",
    }
  end

  -- Telescope
  if is_available "snacks.nvim" then
    mappings.n["<Leader>f`"] = { function() require("snacks").picker.marks() end, desc = "Find marks" }
    mappings.n["<Leader>f'"] = { function() require("snacks").picker.registers() end, desc = "Find registers" }
    mappings.n["<Leader>f/"] = { function() require("snacks").picker.grep() end, desc = "Find words" }
    mappings.n["<Leader>f?"] = {
      function()
        require("snacks").picker.grep {
          hidden = true,
          ignored = false,
        }
      end,
      desc = "Find words(숨김파일포함)",
    }
    mappings.n["<Leader>fe"] = {
      function() require("snacks").picker.recent { filter = { cwd = true } } end,
      desc = "Find history in CWD",
    }
    mappings.n["<Leader>fE"] = { function() require("snacks").picker.recent {} end, desc = "Find history All Path" }

    mappings.n["<Leader>fs"] = {
      function()
        local aerial_avail, _ = pcall(require, "aerial")
        if aerial_avail then
          require("aerial").snacks_picker {}
        else
          require("snacks").picker.lsp_symbols()
        end
      end,
      desc = "Search symbols",
    }

    mappings.n["<Leader>fz"] = { function() require("snacks").picker.zoxide() end, desc = "Find directories" }
    mappings.n["<Leader>fu"] = { function() require("snacks").picker.undo {} end, desc = "Find Undo" }
    mappings.n["<Leader>fl"] = { function() require("snacks").picker.lines {} end, desc = "Find Undo" }
  end

  if is_available "telescope.nvim" then
    if is_available "telescope-import.nvim" then
      mappings.n["<Leader>fi"] =
        { function() require("telescope").extensions.import.import {} end, desc = "Open import Browser" }
    end
  end

  if is_available "resession.nvim" then
    mappings.n["<Leader>s"] = vim.tbl_get(opts, "_map_sections", "S")
    mappings.n["<Leader>sl"] = vim.tbl_get(opts, "mappings", "n", "<Leader>Sl")
    mappings.n["<Leader>ss"] = vim.tbl_get(opts, "mappings", "n", "<Leader>Ss")
    mappings.n["<Leader>sS"] = vim.tbl_get(opts, "mappings", "n", "<Leader>SS")
    mappings.n["<Leader>st"] = vim.tbl_get(opts, "mappings", "n", "<Leader>St")
    mappings.n["<Leader>sd"] = vim.tbl_get(opts, "mappings", "n", "<Leader>Sd")
    mappings.n["<Leader>sD"] = vim.tbl_get(opts, "mappings", "n", "<Leader>SD")
    mappings.n["<Leader>sf"] = vim.tbl_get(opts, "mappings", "n", "<Leader>Sf")
    mappings.n["<Leader>sF"] = vim.tbl_get(opts, "mappings", "n", "<Leader>SF")
    mappings.n["<Leader>s."] = vim.tbl_get(opts, "mappings", "n", "<Leader>S.")
  end

  -- Multicursor
  if is_available "multicursors.nvim" then
    mappings.n["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" }
    mappings.n["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" }
    mappings.v["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" }
  end

  -- Plugin/AstroNvim/Package Manager (<Leader>p => <Leader>')
  mappings.n["<Leader>'"] = vim.tbl_get(opts, "_map_sections", "p")
  mappings.n["<Leader>'i"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pi")
  mappings.n["<Leader>'s"] = vim.tbl_get(opts, "mappings", "n", "<Leader>ps")
  mappings.n["<Leader>'S"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pS")
  mappings.n["<Leader>'u"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pu")
  mappings.n["<Leader>'U"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pU")
  mappings.n["<Leader>'a"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pa")
  mappings.n["<Leader>'m"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pm")
  mappings.n["<Leader>'M"] = vim.tbl_get(opts, "mappings", "n", "<Leader>pM")

  -- Debugger (<Leader>d => <Leader>,)
  if is_available "nvim-dap" then
    mappings.n["<Leader>,"] = vim.tbl_get(opts, "_map_sections", "d")
    mappings.v["<Leader>,"] = vim.tbl_get(opts, "_map_sections", "d")
    mappings.n["<Leader>,b"] = vim.tbl_get(opts, "mappings", "n", "<Leader>db")
    mappings.n["<Leader>,B"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dB")
    mappings.n["<Leader>,c"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dc")
    mappings.n["<Leader>,C"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dC")
    mappings.n["<Leader>,i"] = vim.tbl_get(opts, "mappings", "n", "<Leader>di")
    mappings.n["<Leader>,o"] = vim.tbl_get(opts, "mappings", "n", "<Leader>do")
    mappings.n["<Leader>,O"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dO")
    mappings.n["<Leader>,q"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dq")
    mappings.n["<Leader>,Q"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dQ")
    mappings.n["<Leader>,p"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dp")
    mappings.n["<Leader>,r"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dr")
    mappings.n["<Leader>,R"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dR")
    mappings.n["<Leader>,s"] = vim.tbl_get(opts, "mappings", "n", "<Leader>ds")

    if is_available "nvim-dap-ui" then
      mappings.n["<Leader>,E"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dE")
      mappings.v["<Leader>,E"] = vim.tbl_get(opts, "mappings", "v", "<Leader>dE")
      mappings.n["<Leader>,u"] = vim.tbl_get(opts, "mappings", "n", "<Leader>du")
      mappings.n["<Leader>,h"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dh")
    end
  end

  mappings.n["s"] = vim.tbl_get(opts, "_map_sections", "s")
  mappings.n["sd"] = vim.tbl_get(opts, "mappings", "n", "gl")

  if is_available "telescope-file-browser.nvim" then
    mappings.n["sf"] =
      { function() require("telescope").extensions.file_browser.file_browser {} end, desc = "Open File Browser" }
  end
  if is_available "snacks.nvim" then
    mappings.n["su"] = { function() require("snacks").picker.undo {} end, desc = "Find Undo" }
  end

  if is_available "aerial.nvim" then
    mappings.n["sh"] = { function() require("aerial").toggle() end, desc = "Symbols outline(Hierarchy)" }
  end

  -- terminal
  if is_available "toggleterm.nvim" then
    mappings.n["<Leader>t-"] =
      { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
    mappings.n["<Leader>t\\"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
  end

  -- AutoSave
  if is_available "auto-save.nvim" then mappings.n["<Leader>uA"] = { "<cmd>ASToggle<cr>", desc = "Toggle Autosave" } end

  -- Windows
  if is_available "windows.nvim" then
    mappings.n["<Leader>m"] = { "<cmd>WindowsMaximize<cr>", desc = "Maximize Pane" }
  end

  -- Conform(Formatting)
  if is_available "conform.nvim" then
    mappings.n[";f"] = {
      function() require("conform").format { lsp_fallback = true, async = true, timeout_ms = 1000 } end,
      desc = "Format buffer",
    }
    mappings.v[";f"] = {
      function() require("conform").format { lsp_fallback = true, async = true, timeout_ms = 1000 } end,
      desc = "Format buffer(Visual)",
    }
    mappings.n["<Leader>lc"] = { "<cmd>ConformInfo<cr>", desc = "Conform Information" }
  end

  -- disable key
  mappings.n["|"] = false
  mappings.n["\\"] = false
  mappings.n["s"] = "<Nop>"
  mappings.n["p"] = "<Nop>"
  mappings.n["P"] = "<Nop>"
  mappings.n["<Leader>C"] = false
  mappings.n["<Leader>S"] = false
  mappings.n["<Leader>S."] = false
  mappings.n["<Leader>Sd"] = false
  mappings.n["<Leader>SD"] = false
  mappings.n["<Leader>Sf"] = false
  mappings.n["<Leader>SF"] = false
  mappings.n["<Leader>Sl"] = false
  mappings.n["<Leader>Ss"] = false
  mappings.n["<Leader>SS"] = false
  mappings.n["<Leader>St"] = false
  mappings.n["<Leader>dB"] = false
  mappings.n["<Leader>dC"] = false
  mappings.n["<Leader>dE"] = false
  mappings.n["<Leader>dO"] = false
  mappings.n["<Leader>dQ"] = false
  mappings.n["<Leader>dR"] = false
  mappings.n["<Leader>db"] = false
  mappings.n["<Leader>dc"] = false
  mappings.n["<Leader>dh"] = false
  mappings.n["<Leader>di"] = false
  mappings.n["<Leader>do"] = false
  mappings.n["<Leader>dp"] = false
  mappings.n["<Leader>dq"] = false
  mappings.n["<Leader>dr"] = false
  mappings.n["<Leader>ds"] = false
  mappings.n["<Leader>du"] = false
  mappings.n["<Leader>fW"] = false
  mappings.n["<Leader>fb"] = false
  mappings.n["<Leader>fo"] = false
  mappings.n["<Leader>fO"] = false
  mappings.n["<Leader>fr"] = false
  mappings.n["<Leader>fw"] = false
  mappings.n["<Leader>h"] = false
  mappings.n["<Leader>lS"] = false
  mappings.n["<Leader>ls"] = false
  mappings.n["<Leader>pM"] = false
  mappings.n["<Leader>pS"] = false
  mappings.n["<Leader>pU"] = false
  mappings.n["<Leader>pa"] = false
  mappings.n["<Leader>pm"] = false
  mappings.n["<Leader>pu"] = false
  mappings.n["<Leader>th"] = false
  mappings.n["<Leader>tl"] = false
  mappings.n["<Leader>tv"] = false
  mappings.n["<Leader>lf"] = false

  return mappings
end

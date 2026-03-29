---@param opts AstroCoreOpts
return function(opts)
  local astro = require "astrocore"

  local is_available = astro.is_available
  local buffer = require "astrocore.buffer"
  local get_icon = require("astroui").get_icon

  --- AstroNvim 기본 매핑을 새 prefix로 일괄 재할당
  ---@param tbl table mappings table
  ---@param mode string "n" | "v" | "x" ...
  ---@param old_prefix string 기존 prefix (e.g. "<Leader>d")
  ---@param new_prefix string 새 prefix (e.g. "<Leader>,")
  ---@param suffixes string[] 접미사 목록 (e.g. {"b", "B", "c"})
  ---@param section_key? string _map_sections 키 (없으면 old_prefix 마지막 글자)
  local function remap_prefix(tbl, mode, old_prefix, new_prefix, suffixes, section_key)
    section_key = section_key or old_prefix:sub(-1)
    tbl[mode][new_prefix] = vim.tbl_get(opts, "_map_sections", section_key)
    for _, s in ipairs(suffixes) do
      tbl[mode][new_prefix .. s] = vim.tbl_get(opts, "mappings", mode, old_prefix .. s)
    end
  end

  --- 키 목록 일괄 비활성화
  local function disable_keys(tbl, mode, keys)
    for _, key in ipairs(keys) do
      tbl[mode][key] = false
    end
  end

  opts._map_sections = vim.tbl_deep_extend("force", opts._map_sections or {}, {
    s = { desc = get_icon("Window", 1, true) .. "Show" },
  })

  ---------------------------------------------------------------------------
  -- 기본 매핑
  ---------------------------------------------------------------------------
  local mappings = vim.tbl_deep_extend("force", astro.empty_map_table(), {
    [""] = {
      ["("] = { "7k", desc = "7줄 위로" },
      [")"] = { "7j", desc = "7줄 아래로" },
      ["x"] = { '"_x' },
      ["c"] = { '"_c' },
      ["y"] = { '"iy', desc = "yank (inner reg)" },
      ["Y"] = { '"+y', desc = "yank (system clipboard)" },
      ["d"] = { '"dd', desc = "delete (del reg)" },
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
      ["<Leader>x"] = { "viwx", remap = true, desc = "단어 제거 (inner reg)" },
      ["<Leader>d"] = { "viwd", remap = true, desc = "단어 제거 (del reg)" },
      ["<Leader>pi"] = { 'viw"_x"iP', desc = "paste from inner clipboard('i')" },
      ["<Leader>pd"] = { 'viw"_x"dP', desc = "paste from deleted" },
      ["<Leader>ps"] = { 'viw"_xP', desc = "paste from system clipboard" },
      ["yy"] = { '"iyy' },
      ["Yy"] = { '"+yy' },
      ["YY"] = { '"+yy' },
      ["dd"] = { '"ddd' },

      ["<C-a>"] = { "gg<S-v>G", desc = "전체 선택" },

      ["<S-h>"] = { "h", desc = "오타 방지" },
      ["<S-l>"] = { "l", desc = "오타 방지" },

      ["<Leader>o"] = { "o<ESC>", desc = "아래로 한줄 띄기" },
      ["<Leader>O"] = { "O<ESC>", desc = "위로 한줄 띄기" },
      ["<Leader><CR>"] = { "i<CR><ESC>k", desc = "현재 커서 위치에서 줄바꿈" },

      ["s"] = vim.tbl_get(opts, "_map_sections", "s"),
      ["sq"] = { "<cmd>botright copen<cr>", desc = "Open Quickfix" },
      ["sd"] = vim.tbl_get(opts, "mappings", "n", "gl"),

      -- Prevent conflict <C-i> and <Tab>
      ["<C-p>"] = { "<C-o>", desc = "Jumplist back" },
      ["<C-n>"] = { "<C-i>", desc = "Jumplist forward" },
      ["<C-o>"] = { "<Nop>", desc = "Disabled (use <C-p>)" },

      -- Split
      ["<Leader>\\"] = { "<C-w>v", desc = "세로 분할" },
      ["<Leader>-"] = { "<C-w>s", desc = "가로 분할" },
      ["<Leader>="] = { "<C-w>x", desc = "분할창 순서 변경" },

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
      ["J"] = { ":move '>+1<CR>gv-gv", desc = "한줄 아래로 내림" },
      ["K"] = { ":move '<-2<CR>gv-gv", desc = "한줄 위로 올림" },
      ["<"] = { "<gv" },
      [">"] = { ">gv" },
      ["mf"] = { "<C-v>^<S-i>", desc = "Block insert (앞)" },
      ["mb"] = { "<C-v>$<S-a>", desc = "Block append (뒤)" },
    },
  })

  ---------------------------------------------------------------------------
  -- Yanky
  ---------------------------------------------------------------------------
  if is_available "yanky.nvim" and is_available "snacks.nvim" then
    local yanky = function() require("snacks").picker.yanky() end
    mappings.n["<Leader>fy"] = { yanky, desc = "Find yanks" }
    mappings.x["<Leader>fy"] = { yanky, desc = "Find yanks" }
    mappings.n["sy"] = { yanky, desc = "Find yanks" }
    mappings.x["sy"] = { yanky, desc = "Find yanks" }
  end

  ---------------------------------------------------------------------------
  -- NeoTree
  ---------------------------------------------------------------------------
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

  ---------------------------------------------------------------------------
  -- Window Resizer
  ---------------------------------------------------------------------------
  if is_available "winresizer" then
    mappings.n["<C-e>"] = { "<cmd>WinResizerStartResize<cr>", desc = "Start window resize mode" }
  end

  ---------------------------------------------------------------------------
  -- BufferLine
  ---------------------------------------------------------------------------
  if is_available "bufferline.nvim" then
    mappings.n["<tab>"] = { function() require("bufferline").cycle(1) end, desc = "Next buffer" }
    mappings.n["<S-tab>"] = { function() require("bufferline").cycle(-1) end, desc = "Previous buffer" }
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

  ---------------------------------------------------------------------------
  -- Snacks Picker
  ---------------------------------------------------------------------------
  if is_available "snacks.nvim" then
    local pick = function(name, picker_opts)
      return function() require("snacks").picker[name](picker_opts or {}) end
    end

    mappings.n["<Leader>f`"] = { pick "marks", desc = "Find marks" }
    mappings.n["<Leader>f'"] = { pick "registers", desc = "Find registers" }
    mappings.n["<Leader>f/"] = { pick "grep", desc = "Find words" }
    mappings.n["<Leader>f?"] = {
      pick("grep", { hidden = true, ignored = false }),
      desc = "Find words(숨김파일포함)",
    }
    mappings.n["<Leader>fe"] = {
      pick("recent", { filter = { cwd = true } }),
      desc = "Find history in CWD",
    }
    mappings.n["<Leader>fE"] = { pick "recent", desc = "Find history All Path" }
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
    mappings.n["<Leader>fz"] = { pick "zoxide", desc = "Find directories" }
    mappings.n["<Leader>fu"] = { pick "undo", desc = "Find Undo" }
    mappings.n["<Leader>fl"] = { pick "lines", desc = "Find Lines" }

    mappings.n["su"] = { pick "undo", desc = "Find Undo" }
  end

  ---------------------------------------------------------------------------
  -- Telescope
  ---------------------------------------------------------------------------
  if is_available "telescope.nvim" and is_available "telescope-import.nvim" then
    mappings.n["<Leader>fi"] =
      { function() require("telescope").extensions.import.import {} end, desc = "Open import Browser" }
  end

  if is_available "telescope-file-browser.nvim" then
    mappings.n["sf"] =
      { function() require("telescope").extensions.file_browser.file_browser {} end, desc = "Open File Browser" }
  end

  ---------------------------------------------------------------------------
  -- Resession (<Leader>S => <Leader>s)
  ---------------------------------------------------------------------------
  if is_available "resession.nvim" then
    remap_prefix(mappings, "n", "<Leader>S", "<Leader>s", { "l", "s", "S", "t", "d", "D", "f", "F", "." }, "S")
  end

  ---------------------------------------------------------------------------
  -- Multicursor
  ---------------------------------------------------------------------------
  if is_available "multicursors.nvim" then
    mappings.n["mm"] = { function() require("multicursors").start() end, desc = "multicursor start" }
    mappings.n["m/"] = { function() require("multicursors").new_pattern() end, desc = "multicursor search" }
    mappings.x["mm"] = { function() require("multicursors").search_visual() end, desc = "multicursor search" }
  end

  ---------------------------------------------------------------------------
  -- Plugin Manager (<Leader>p => <Leader>')
  ---------------------------------------------------------------------------
  remap_prefix(mappings, "n", "<Leader>p", "<Leader>'", { "i", "s", "S", "u", "U", "a", "m", "M" }, "p")

  ---------------------------------------------------------------------------
  -- Debugger (<Leader>d => <Leader>,)
  ---------------------------------------------------------------------------
  if is_available "nvim-dap" then
    remap_prefix(
      mappings,
      "n",
      "<Leader>d",
      "<Leader>,",
      { "b", "B", "c", "C", "i", "o", "O", "q", "Q", "p", "r", "R", "s" },
      "d"
    )

    if is_available "nvim-dap-ui" then
      mappings.n["<Leader>,E"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dE")
      mappings.v["<Leader>,E"] = vim.tbl_get(opts, "mappings", "v", "<Leader>dE")
      mappings.n["<Leader>,u"] = vim.tbl_get(opts, "mappings", "n", "<Leader>du")
      mappings.n["<Leader>,h"] = vim.tbl_get(opts, "mappings", "n", "<Leader>dh")
    end
  end

  ---------------------------------------------------------------------------
  -- Aerial
  ---------------------------------------------------------------------------
  if is_available "aerial.nvim" then
    mappings.n["sh"] = { function() require("aerial").toggle() end, desc = "Symbols outline(Hierarchy)" }
  end

  ---------------------------------------------------------------------------
  -- Terminal
  ---------------------------------------------------------------------------
  if is_available "toggleterm.nvim" then
    mappings.n["<Leader>t-"] =
      { "<cmd>ToggleTerm size=10 direction=horizontal<cr>", desc = "ToggleTerm horizontal split" }
    mappings.n["<Leader>t\\"] = { "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm vertical split" }
  end

  ---------------------------------------------------------------------------
  -- AutoSave
  ---------------------------------------------------------------------------
  if is_available "auto-save.nvim" then
    mappings.n["<Leader>uA"] = { "<cmd>ASToggle<cr>", desc = "Toggle Autosave" }
  end

  ---------------------------------------------------------------------------
  -- Windows
  ---------------------------------------------------------------------------
  if is_available "windows.nvim" then
    mappings.n["<Leader>m"] = { "<cmd>WindowsMaximize<cr>", desc = "Maximize Pane" }
  end

  ---------------------------------------------------------------------------
  -- Conform (Formatting)
  ---------------------------------------------------------------------------
  if is_available "conform.nvim" then
    local format = function() require("conform").format { async = false } end
    mappings.n[";f"] = { format, desc = "Format buffer" }
    mappings.v[";f"] = { format, desc = "Format buffer(Visual)" }
    mappings.n["<Leader>lc"] = { "<cmd>ConformInfo<cr>", desc = "Conform Information" }
  end


  ---------------------------------------------------------------------------
  -- 비활성화 (AstroNvim 기본 매핑 제거)
  ---------------------------------------------------------------------------
  mappings.n["|"] = false
  mappings.n["\\"] = false
  mappings.n["p"] = "<Nop>"
  mappings.n["P"] = "<Nop>"

  disable_keys(mappings, "n", {
    "<Leader>C",
    -- Sessions (=> <Leader>s 로 이동)
    "<Leader>S", "<Leader>S.", "<Leader>Sd", "<Leader>SD",
    "<Leader>Sf", "<Leader>SF", "<Leader>Sl", "<Leader>Ss", "<Leader>SS", "<Leader>St",
    -- Debugger (=> <Leader>, 로 이동)
    "<Leader>db", "<Leader>dB", "<Leader>dc", "<Leader>dC", "<Leader>dE",
    "<Leader>dh", "<Leader>di", "<Leader>do", "<Leader>dO", "<Leader>dp",
    "<Leader>dq", "<Leader>dQ", "<Leader>dr", "<Leader>dR", "<Leader>ds", "<Leader>du",
    -- Finder (재할당 또는 미사용)
    "<Leader>fb", "<Leader>fo", "<Leader>fO", "<Leader>fr", "<Leader>fw", "<Leader>fW",
    -- LSP
    "<Leader>lS", "<Leader>ls",
    -- Plugins (=> <Leader>' 로 이동)
    "<Leader>pa", "<Leader>pm", "<Leader>pM", "<Leader>pS", "<Leader>pu", "<Leader>pU",
    -- Terminal
    "<Leader>th", "<Leader>tl", "<Leader>tv",
    -- 기타
    "<Leader>h", "<Leader>lf", "<Leader>Mp", "<Leader>Ms", "<Leader>Mt",
    "<Leader>xl", "<Leader>xq",
  })

  return mappings
end

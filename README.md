<h1 align="center">Neovim Config</h1>

<p align="center">
  <a href="https://neovim.io"><img alt="Neovim" src="https://img.shields.io/badge/Neovim-0.12%2B-57A143?style=flat&logo=neovim&logoColor=white" /></a>
  <a href="https://github.com/AstroNvim/AstroNvim"><img alt="AstroNvim" src="https://img.shields.io/badge/AstroNvim-v6-7DC4E4?style=flat" /></a>
  <a href="https://github.com/folke/lazy.nvim"><img alt="lazy.nvim" src="https://img.shields.io/badge/lazy.nvim-plugin%20manager-B7BDF8?style=flat" /></a>
  <img alt="macOS" src="https://img.shields.io/badge/macOS-000000?style=flat&logo=apple&logoColor=white" />
  <img alt="WSL2" src="https://img.shields.io/badge/WSL2-4D4D4D?style=flat&logo=linux&logoColor=white" />
</p>

<p align="center">
  Personal Neovim configuration for full-stack web development.<br/>
  TypeScript/JavaScript focused, AI-assisted, Korean input ready.
</p>

---

## Highlights

> **Modular** — Drop a `.lua` file into `modules/` to add a plugin. No imports needed.
>
> **AI-native** — Claude Code IDE extension with in-editor terminal, diffs, and external pane.
>
> **Portable** — New modules use native `vim.*` APIs. AstroNvim coupling is isolated and replaceable.

<details>
<summary><strong>More features</strong></summary>

- **Tokyo Night** default + 6 alternative colorschemes, all transparent
- **Blink.cmp** completion with LSP, snippets, path, buffer, emoji sources
- **Lualine + Bufferline + Dropbar** — full statusline / tabline / breadcrumb stack
- **Korean langmap** — 2-bul keyboard input without mode switching
- **Register separation** — yank, delete, change, cut each use dedicated registers
- **Session persistence** — auto-save and restore via persistence.nvim

</details>

---

## Architecture

```
init.lua -> lazy_setup.lua -> polish.lua

AstroNvim core
  -> community.lua          AstroCommunity imports
  -> plugins/astrocore.lua  <- lua/core/        options, mappings, autocmds
  -> plugins/astroui.lua    <- lua/highlights/   colors, palette
  -> plugins/astrolsp.lua   <- lua/lsp/          servers, formatting, linting
  -> plugins/modules/*      <- auto-loaded plugin specs
```

<details>
<summary><strong>Directory tree</strong></summary>

```
lua/
├── core/                  Options, mappings, commands, diagnostics
├── lsp/                   Server config, formatting, linting, installer
├── highlights/            Color definitions and utilities
└── plugins/
    ├── astrocore.lua      AstroCore bridge
    ├── astroui.lua        AstroUI bridge
    ├── astrolsp.lua       AstroLSP bridge
    └── modules/
        ├── ui/                16 modules
        ├── colorscheme/        7 themes
        ├── editing-support/    7 modules
        ├── lsp/                6 modules
        ├── utils/              5 modules
        └── disabled.lua       Nullified AstroNvim defaults
```

</details>

---

## Plugins

### UI

| Plugin | Role |
|:-------|:-----|
| **lualine.nvim** | Statusline — custom bubbles theme with mode colors |
| **bufferline.nvim** | Tab-style buffer bar with LSP diagnostics |
| **dropbar.nvim** | Breadcrumb navigation (LSP + Treesitter) |
| **neo-tree.nvim** | File explorer |
| **trouble.nvim** | Diagnostics, references, quickfix |
| **snacks.picker** | Fuzzy finder |
| **namu.nvim** | Zed-style symbol navigator |
| **outline.nvim** | Symbol outline sidebar |
| **noice.nvim** | Command line and message UI |
| **satellite.nvim** | Scrollbar with diagnostics and git signs |
| **snacks.notifier** | Notifications |
| **snacks.scroll** | Smooth scrolling |
| **smear-cursor.nvim** | Cursor trail animation |
| **nvim-colorizer.lua** | Inline color preview (CSS, Tailwind) |
| **mini.icons** | Icon provider |
| **smart-splits.nvim** | Window resize mode |

### Editing

| Plugin | Role |
|:-------|:-----|
| **blink.pairs** | Auto-pairing |
| **multicursor.nvim** | Multi-cursor editing via hydra |
| **nvim-surround** | Surround operations |
| **refactoring.nvim** | Refactoring tools |
| **autosave** | Auto-save on events |
| **markview.nvim** | Markdown preview |
| **helpview.nvim** | Enhanced help viewer |

### LSP and Completion

| Plugin | Role |
|:-------|:-----|
| **blink.cmp** | Completion — LSP, snippets, path, buffer, emoji |
| **conform.nvim** | Formatter dispatcher |
| **nvim-lint** | Linter dispatcher |
| **tiny-inline-diagnostic.nvim** | Inline diagnostic display |
| **inc-rename.nvim** | Rename with preview |
| **dap-view.nvim** | Debugger UI |

### AI

| Plugin | Role |
|:-------|:-----|
| **claudecode.nvim** | Claude Code IDE extension — terminal, diffs, model select |
| **claude-pane** | External Claude CLI pane (wezterm / tmux) |

### Colorschemes

`tokyonight` (default) · `catppuccin` · `onedark` · `solarized-osaka` · `vscode` · `lavi` · `midnights`

All configured with transparent backgrounds.

### Utilities

| Plugin | Role |
|:-------|:-----|
| **which-key.nvim** | Keybinding cheatsheet |
| **persistence.nvim** | Session save / restore |
| **yanky.nvim** | Yank history with picker |
| **im-select.nvim** | Auto input method switching (macOS) |
| **diffview.nvim** | Git diff viewer |

---

## Keymaps

`<Space>` Leader / `,` Local Leader

### Leader Groups

| Prefix | Category | |
|:-------|:---------|:--|
| `<Leader>a` | **AI** | Send to Claude, accept/deny diff, toggle pane |
| `<Leader>e` | **Explorer** | Toggle / focus Neo-tree |
| `<Leader>f` | **Find** | Diagnostics, grep, symbols, marks, registers, undo |
| `<Leader>l` | **LSP** | Code action, rename, declaration, format info |
| `<Leader>s` | **Session** | Load, select, stop |
| `<Leader>t` | **Terminal** | Horizontal / vertical split |
| `<Leader>u` | **UI Toggle** | Autosave, semantic highlighting |
| `<Leader>w` | **Window** | Close window / buffer |
| `<Leader>,` | **Debugger** | DAP controls |
| `<Leader>'` | **Plugins** | Lazy plugin manager |

### Quick Actions

| Key | Action |
|:----|:-------|
| `;f` | Format buffer |
| `;a` | Code action |
| `;r` | Rename symbol (inc-rename) |
| `mm` | Start multicursor |
| `m/` | Multicursor search |
| `<C-a>` | Select all |

### Navigation

| Key | Action |
|:----|:-------|
| `(` / `)` | Jump 7 lines up / down |
| `<Tab>` / `<S-Tab>` | Next / previous buffer |
| `<C-p>` / `<C-n>` | Jumplist back / forward |
| `<Leader>\` / `<Leader>-` | Vertical / horizontal split |

### Register System

Each operation writes to its own named register — no more accidental overwrites.

| Operation | Register | Paste back |
|:----------|:---------|:-----------|
| `y` yank | `"y` | `pi` |
| `d` delete | `"d` | `pd` |
| `x` cut | `"x` | — |
| `c` change | `"c` | — |
| — | system `"+` | `ps` |

<details>
<summary><strong>Submenu &amp; visual mode maps</strong></summary>

#### Submenu (`s` prefix)

| Key | Action |
|:----|:-------|
| `sq` | Quickfix (Trouble) |
| `sd` / `sD` | Diagnostics all / buffer |
| `su` | Undo history |
| `sh` | Symbol outline |
| `sy` | Yank history |

#### Visual Mode

| Key | Action |
|:----|:-------|
| `J` / `K` | Move line down / up |
| `<` / `>` | Indent / dedent (keeps selection) |
| `mf` / `mb` | Block insert at start / end of lines |

</details>

---

## LSP and Tooling

### Language Servers

`lua_ls` · `vtsls` · `tailwindcss` · `html` · `css` · `emmet` · `bashls` · `jsonls` · `marksman`

All auto-installed via Mason.

### Formatters and Linters

| Language | Formatter | Linter |
|:---------|:----------|:-------|
| Lua | stylua | — |
| HTML | stylelint / prettierd | — |
| CSS / SCSS / LESS | stylelint / prettierd | stylelint |
| Shell | shfmt | shellcheck |
| Markdown | mdformat | — |

### Debugger

`pwa-node` adapter via js-debug-adapter — launch current file or attach to process.

### Defaults

| Feature | State |
|:--------|:------|
| Inlay hints | **On** |
| Semantic tokens | **On** |
| Code lens | Off |
| Format on save | Off — manual `;f` |
| Virtual text | Off — tiny-inline-diagnostic |

---

## Requirements

Neovim >= 0.12 · Git · [Nerd Font](https://www.nerdfonts.com/) · Node.js · ripgrep · fd

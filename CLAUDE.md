# CLAUDE.md

Personal Neovim config on **AstroNvim v6** + **lazy.nvim**. Lua, Korean comments.

Runs on **macOS (native)** and **WinOS (WSL2 Ubuntu)** from a single shared repo — no `mac/`/`win/` split. OS differences are handled inline via `core/platform.lua` + `cond =` plugin gating. Single `lazy-lock.json` shared across both. OS isolation rule: a macOS-only edit must not touch WinOS-only code, and vice versa; portable changes apply to both 1:1.

Known OS/environment-sensitive files (exploration map — open these first for cross-platform work):
- `modules/utils/im-select.lua` — IME switcher, macOS vs WinOS binaries.
- `modules/editing-support/ai/claude-pane.lua` — depends on wezterm/tmux env vars and hardcoded shell.

## Architecture

`init.lua` → `lazy_setup.lua` → `polish.lua`. Load order: AstroNvim core → `community.lua` → `plugins/`. Override AstroCommunity opts from `plugins/` (loaded after).

Foundation plugins merge user config from sibling dirs — not colocated:
- **AstroCore** (`plugins/astrocore.lua`) ← `lua/core/` (options, mappings, autocmds, diagnostics)
- **AstroUI** (`plugins/astroui.lua`) ← `lua/highlights/`
- **AstroLSP** (`plugins/astrolsp.lua`) ← `lua/lsp/`

`lua/plugins/modules/init.lua` recursively auto-loads every `.lua` under `modules/` as a flat LazySpec — drop a file in a subdir and it's picked up, no manual registration. Blacklist at top of that file. Categories: `ui/ editing-support/ lsp/ colorscheme/ utils/`.

## Framework Portability (migrating off AstroNvim)

New code: native APIs (`vim.keymap.set`, lazy.nvim directly) over astrocore wrappers. Keep AstroNvim-specific code confined to `plugins/astro{core,ui,lsp}.lua`.

Non-obvious wrapper behaviors — don't naively replace:
- `astrocore.set_mappings` — auto-registers which-key groups from the map table; a plain `vim.keymap.set` loop loses that.
- `astrocore.on_load(plugin, fn)` — runs immediately if already loaded, else waits on `User LazyLoad`. Replacement needs both branches.
- `astrocore.patch_func(orig, override)` — wraps so `override(orig, ...)` is called.

## Conventions

- Leader `<Space>`, **localleader `,`** (non-default).
- **Autoformat off by default** — don't assume format-on-save.
- `modules/ui/` one role per file: statusline→`lualine.lua`, tabline→`bufferline.lua`, winbar→`dropbar.lua`.
- All `enabled = false` specs centralized in `modules/disabled.lua`.
- AstroNvim docs via context7: `/websites/astronvim`.

## Gotchas

- **Replacing AstroNvim `optional = true` plugins (e.g. heirline)**: never just delete the user spec — upstream defaults silently return. Nullify each opt: `{ plugin, optional = true, opts = function(_, opts) opts.XXX = nil end }`.
- **`astroui.status` depends on heirline** — remove them together or neither.
- **Cross-platform OS isolation**: when doing mac-only or WinOS-only work, never touch the other side's branch. Portable changes must apply 1:1 to both. Ask if unsure.

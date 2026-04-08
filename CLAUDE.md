# CLAUDE.md

Personal Neovim config on **AstroNvim v6** + **lazy.nvim**. Lua, Korean comments.

## Architecture

`init.lua` → `lazy_setup.lua` → `polish.lua`

Load order: AstroNvim core → `community.lua` (AstroCommunity) → `plugins/`. To override an AstroCommunity plugin's opts, do it from `plugins/` (loaded after).

Foundation plugins merge user config from sibling dirs:
- **AstroCore** (`plugins/astrocore.lua`) ← `lua/core/` (options, mappings, autocmds, diagnostics)
- **AstroUI** (`plugins/astroui.lua`) ← `lua/highlights/`
- **AstroLSP** (`plugins/astrolsp.lua`) ← `lua/lsp/`

### Module Auto-Loader

`lua/plugins/modules/init.lua` recursively loads every `.lua` under `modules/` as a flat LazySpec — drop a file in a subdir and it's picked up. Blacklist lives at the top of `init.lua`.

Categories: `ui/`, `editing-support/`, `lsp/`, `colorscheme/`, `utils/`

## Goal: Framework Portability

User is migrating off AstroNvim. For new code:
- Prefer native APIs (`vim.tbl_deep_extend`, `vim.keymap.set`, `vim.api.*`, lazy.nvim directly) over astrocore wrappers.
- New `modules/` entries use standard lazy.nvim spec — no astrocore deps.
- Keep AstroNvim-specific code confined to `plugins/astrocore.lua`, `astroui.lua`, `astrolsp.lua`.

Non-obvious wrapper behaviors (don't reinvent blindly):
- `astrocore.set_mappings` — auto-registers which-key groups from the map table; a plain `vim.keymap.set` loop loses that.
- `astrocore.on_load(plugin, fn)` — runs immediately if already loaded, else waits on `User LazyLoad`. Replacement needs both branches.
- `astrocore.patch_func(orig, override)` — wraps so `override(orig, ...)` is called; useful for monkey-patching plugin internals.

## Gotchas

- Replacing an AstroNvim `optional = true` plugin (e.g. heirline): never just delete the user config. Nullify each opt — `{ plugin, optional = true, opts = function(_, opts) opts.XXX = nil end }` — otherwise the upstream defaults silently come back.
- `astroui.status` depends on heirline. Remove them together.
- One role per file in `modules/ui/`: statusline → `lualine.lua`, tabline → `bufferline.lua`, winbar → `dropbar.lua`. Never mix roles across files.
- All `enabled = false` specs live in `modules/disabled.lua`. Don't scatter disables into individual plugin files.
- Respect existing grouping: if a file has a section for a category, add new entries there instead of inlining elsewhere.

## References

- AstroNvim docs via context7: `/websites/astronvim`
- Leader `<Space>`, localleader `,`. StyLua for formatting. Autoformat off by default.

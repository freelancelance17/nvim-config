# CLAUDE.md

Neovim configuration. Lua, lazy.nvim plugin manager.

## Cardinal rule: never directly edit installed lazy packages

Plugin code lives under `~/.local/share/nvim/lazy/<plugin>/`. **Never edit those files
directly.** They are not version-controlled here, lazy.nvim overwrites them on update,
and any change is invisible to anyone else cloning this config.

Reading them to understand behavior is fine and encouraged. Modifying them is not.

When a plugin genuinely needs a source-level patch (e.g. fixing a deprecated
`client.request(` → `client:request(` dot-call for nvim 0.12), do it through the
plugin spec's `build` hook so the patch is reproducible and lives in this repo. See
the existing examples:

- `lua/plugins/lsp.lua` — patches bundled lspconfig server files
- `lua/plugins/editor.lua` — patches `trouble.nvim`'s lsp source
- `lua/plugins/cmp.lua` — (historical) patched a cmp source

Prefer real configuration over patching: plugin `opts`/`config`, `vim.lsp.config`,
autocommands, or overriding via the plugin's own API. Patch only when there's no
config-level option.

## Layout

- `init.lua` — leader keys, core requires, lazy bootstrap, `{ import = "plugins" }`
- `lua/options.lua`, `lua/keymaps.lua`, `lua/autocommands.lua` — core settings
- `lua/plugins/*.lua` — one file per concern, each returns a lazy spec; auto-imported
- `lazy-lock.json` — pinned plugin versions (commit lockfile changes deliberately)
- `lua/features.lua` — feature flags: the single place to turn plugins and IDE
  layout panels on/off without deleting their config (see below)

## Feature flags (`lua/features.lua`)

One module of booleans is the master switch for optional behavior; flip a value and
restart nvim. Nothing is removed — disabled config stays on disk, just dormant.

- `M.plugins.<name>` — one flag per file in `lua/plugins/`, keyed by filename. Each
  plugin file guards itself at the very top so a disabled concern hands lazy nothing:
  ```lua
  if not require("features").plugins.<name> then return {} end
  ```
  **When adding a new plugin file, add its flag to `features.lua` and this guard
  line** (matching the filename key), or the toggle system silently skips it.
- `M.layout.*` — the edgy.nvim IDE layout. `enabled` is the master switch (off = no
  docking, windows open as plain splits); `filetree`/`symbols`/`diagnostics`/
  `terminal` toggle individual panels; `auto_open_panels` controls the `LspAttach`
  opener that pops diagnostics+symbols when you open a source file.
- The layout flags are read in three places that must stay consistent: the edgy spec
  and panel list (`lua/plugins/layout.lua`), the startup panel opener and the
  edgy-only workaround autocmds (`lua/autocommands.lua`, all gated on
  `layout.enabled`), and the `LspAttach` auto-opener (`lua/plugins/lsp.lua`).
- `plugins.filetree`/`plugins.terminal` (remove the plugin) are distinct from
  `layout.filetree`/`layout.terminal` (keep the plugin, just don't dock/auto-open it).

## Conventions

- Match the surrounding comment style: these files explain *why* a workaround exists
  (the failure it prevents), not just *what* the code does. Keep that when editing.
- After config changes, Trouble caches its merged config at `setup()` time and lazy
  reloads don't always clear `package.loaded` — a full nvim restart is the reliable
  way to pick up changes.
- edgy.nvim manages the docked panels and desyncs Trouble's internal view tracking;
  scan real windows (`vim.w[win].trouble.mode`) rather than trusting Trouble's
  `is_open()`/`get()`. See `lua/plugins/lsp.lua` and `lua/autocommands.lua`.
- noice owns LSP signature help (single renderer); do not also enable
  `cmp-nvim-lsp-signature-help`.

## Verifying changes

The user tests config in their live editor — don't run repeated headless `nvim`
verification. A single decisive headless check is fine when isolating a real
question (e.g. dumping a plugin's resolved config), but prefer letting the user
verify behavior live.

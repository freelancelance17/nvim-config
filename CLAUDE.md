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

-- Feature flags: turn plugins and IDE layout panels on/off WITHOUT removing
-- their config. Flip a value to `false` and restart nvim.
--
-- How it works
--   * Each `lua/plugins/<name>.lua` guards itself at the top with
--       if not require("features").plugins.<name> then return {} end
--     so a disabled concern hands lazy.nvim nothing to install/load. The
--     config stays on disk, fully intact, just dormant.
--   * `lua/plugins/layout.lua` reads `M.layout` to decide whether edgy.nvim
--     docks at all, and which panels it docks.
--
-- Toggling an OPTIONAL plugin is always safe. Toggling a CORE one (marked
-- below) can break things other plugins assume are present (e.g. completion
-- capabilities, treesitter highlights) — flip those only if you know why.

local M = {}

-- One flag per file in lua/plugins/. Key == filename (without .lua).
M.plugins = {
  -- ── Languages / debugging ───────────────────────────────────────────────
  rust = true, -- rustaceanvim (rust-analyzer + dap)
  python = true, -- nvim-dap-python
  csharp = true, -- roslyn.nvim

  -- ── Optional tooling ────────────────────────────────────────────────────
  git = true, -- gitsigns + diffview
  telescope = true, -- fuzzy finder
  terminal = true, -- toggleterm (docked + float)
  filetree = true, -- neo-tree (left dock)
  snacks = true, -- snacks.nvim (indent guides, words, gitbrowse)
  autosave = true, -- auto-save.nvim

  -- ── Core (disabling may break other plugins) ────────────────────────────
  lsp = true, -- nvim-lspconfig + mason + format-on-save
  cmp = true, -- blink.cmp completion (lsp pulls capabilities from it)
  treesitter = true, -- syntax / highlighting
  editor = true, -- which-key, autopairs, surround, todo-comments, trouble
  ui = true, -- colorscheme, lualine, noice
}

-- IDE window layout (edgy.nvim docked panels).
M.layout = {
  enabled = false, -- master switch: false = no docking, windows open as plain splits
  filetree = true, -- left dock (neo-tree)
  symbols = true, -- right dock (Trouble symbols)
  diagnostics = true, -- bottom dock (Trouble diagnostics)
  terminal = true, -- bottom dock (toggleterm)

  -- Auto-open the diagnostics + symbols panels when an LSP attaches to a buffer
  -- (e.g. opening a .rs file). Independent of `enabled` — the LspAttach opener in
  -- lua/plugins/lsp.lua fires even with docking off (panels open as plain splits).
  -- Turn this off to stay on a bare buffer until you open a panel yourself
  -- (<leader>xx diagnostics, <leader>cs symbols). Respects the per-panel flags
  -- above, so a disabled panel never auto-opens.
  auto_open_panels = false,
}

return M

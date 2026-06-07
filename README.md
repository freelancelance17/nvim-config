# nvim-config

My personal Neovim configuration — an IDE-style setup for **Rust, Python, C#, and
TypeScript/web**, built on [lazy.nvim](https://github.com/folke/lazy.nvim).

> Targets **Neovim 0.12+**. nvim-treesitter runs on its `main` branch, which only
> supports 0.12.

## Requirements

| Tool | Why |
|------|-----|
| Neovim **0.12+** | config uses 0.12 APIs; treesitter `main` branch needs it |
| `git` | lazy.nvim clones plugins |
| `ripgrep` (`rg`) | Telescope live-grep / grep-string |
| C compiler + `make` | builds treesitter parsers and LuaSnip's jsregexp |
| **`tree-sitter` CLI** | nvim-treesitter `main` builds parsers with it (install via `npm i -g tree-sitter-cli`) |
| `node` + `npm` | some LSP servers; source of the tree-sitter CLI |
| `rustup` / `cargo` + `rust-analyzer` | Rust toolchain (rustaceanvim) |
| `python3` | pynvim / debugpy (Python debugging) |

## Install

```sh
./install_nvim.sh
```

The script installs the dependencies above (Homebrew on macOS), backs up any
existing `~/.config/nvim` to `~/.config/nvim.backup`, clones this repo, and runs
`lazy.nvim` to install plugins. Then, inside Neovim, run `:Mason` to install the
language servers / debug adapters (codelldb, debugpy, roslyn, …) and
`:checkhealth` to verify.

To do it manually:

```sh
git clone https://github.com/freelancelance17/nvim-config ~/.config/nvim
nvim '+Lazy! sync' +qa
```

## Layout

```
init.lua              leader keys, core requires, lazy.nvim bootstrap
lua/
  options.lua         editor settings
  keymaps.lua         global keymaps
  autocommands.lua    autosave, panel focus restore, diagnostics follow
  plugins/            one file per concern, auto-imported by lazy
```

`CLAUDE.md` documents repo conventions — most importantly: **never edit installed
lazy packages directly**; patch them via a plugin spec `build` hook instead.

## Key plugins

- **Completion / snippets** — [blink.cmp](https://github.com/saghen/blink.cmp) + LuaSnip
- **LSP** — nvim-lspconfig + Mason (pyright, ruff, jedi, ts_ls); **rustaceanvim**
  for Rust and **roslyn.nvim** for C#
- **Treesitter** — nvim-treesitter (`main` branch) for highlighting
- **Finding** — Telescope (+ DAP pickers)
- **Files / layout** — neo-tree + **edgy.nvim** (docked IDE-style panels)
- **Diagnostics / symbols** — trouble.nvim
- **UI** — noice.nvim, lualine, render-markdown, barbar (tabs),
  [snacks.nvim](https://github.com/folke/snacks.nvim) (bigfile, indent, words,
  bufdelete, gitbrowse)
- **Git** — gitsigns + diffview
- **Debugging** — nvim-dap (+ dap-ui, virtual-text); codelldb (Rust), debugpy (Python)
- **Terminal** — toggleterm (docked + floating)
- **Theme** — [nightfox.nvim](https://github.com/EdenEast/nightfox.nvim)

## Notable keymaps

Leader is `<Space>`, local-leader is `,`.

| Key | Action |
|-----|--------|
| `<C-p>` / `<leader>fs` | find files / live grep |
| `\\` | focus file tree |
| `<C-t>` / `<leader>ft` / `t` | docked terminal / floating terminal |
| `K` | LSP hover (Rust: hover actions) |
| `gd` `gr` `gi` | LSP definition / references / implementation |
| `<leader>cs` / `<leader>cl` | symbols / LSP refs (Trouble) |
| `<leader>xx` | diagnostics (Trouble) |
| `]r` / `[r` | jump between references (snacks.words) |
| `<leader>w` / `<leader>q` | save / close buffer (keeps layout) |
| `<leader>gd` / `<leader>go` | Diffview / open in browser |
| `<leader>r…` | Rust commands (runnables, expand macro, …) |
| `<leader>p…` / `<leader>d…`, `F5`/`F9`/`F10` | Python / debug controls |

## Notes / gotchas

- **tree-sitter CLI must be on PATH** for treesitter to build parsers. Installed
  via npm, it lives in your active Node version's bin dir — if you switch Node
  versions with nvm, re-run `npm i -g tree-sitter-cli` (or use
  `cargo install tree-sitter-cli` for a Node-independent binary).
- After changing plugin config, a **full Neovim restart** is the reliable way to
  pick it up (some plugins cache their merged config at `setup()` time).
- `lazy-lock.json` is gitignored, so plugin versions aren't pinned in the repo.

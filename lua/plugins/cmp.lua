return {
  {
    -- blink.cmp: modern, fast completion engine. Replaces nvim-cmp and its
    -- source plugins (cmp-buffer/path/cmdline/cmp_luasnip/cmp-nvim-lsp).
    -- `version = "*"` pulls a release tag that ships a prebuilt fuzzy-matcher
    -- binary, so there's no cargo build step.
    "saghen/blink.cmp",
    version = "*",
    event = "InsertEnter",
    dependencies = {
      -- Snippets: LuaSnip + the friendly-snippets library (includes Rust)
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
    },
    opts = {
      -- Use LuaSnip as the snippet engine so friendly-snippets work
      snippets = { preset = "luasnip" },

      keymap = {
        -- default preset: <C-n>/<C-p> select, <C-space> toggle, <C-e> hide,
        -- <C-y> accept, <C-b>/<C-f> scroll docs, <C-k> toggle signature.
        preset = "default",
        -- <CR> accepts only when an item is selected, else inserts a newline
        ["<CR>"] = { "accept", "fallback" },
        -- Tab/S-Tab: navigate menu, else jump through snippet placeholders
        ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        -- Match the old cmp doc-scroll bindings
        ["<C-f>"] = { "scroll_documentation_down", "fallback" },
        ["<C-S-f>"] = { "scroll_documentation_up", "fallback" },
      },

      completion = {
        -- Auto-show the documentation popup next to the menu
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        -- Greyed-out inline preview of the first suggestion (was cmp ghost_text)
        ghost_text = { enabled = true },
        menu = {
          draw = {
            -- kind icon | label | source label (mirrors the old [LSP]/[Snip] menu)
            columns = {
              { "kind_icon" },
              { "label", "label_description", gap = 1 },
              { "source_name" },
            },
          },
        },
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },

      -- Signature help is owned by noice (lsp.signature); don't double-render it.
      signature = { enabled = false },

      fuzzy = { implementation = "prefer_rust_with_warning" },
    },
    opts_extend = { "sources.default" },
  },
}

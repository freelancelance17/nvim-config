return {
  {
    "neovim/nvim-lspconfig",
    -- nvim 0.12: patch deprecated client.request dot-calls in bundled server configs
    build = function()
      local base = vim.fn.stdpath("data") .. "/lazy/nvim-lspconfig/lua/lspconfig/configs/"
      local files = {
        base .. "rust_analyzer.lua",
        base .. "pyright.lua",
      }
      for _, path in ipairs(files) do
        local ok, lines = pcall(vim.fn.readfile, path)
        if ok then
          local content = table.concat(lines, "\n")
          local patched = content:gsub("client%.request%(", "client:request(")
          if patched ~= content then
            vim.fn.writefile(vim.split(patched, "\n"), path)
          end
        end
      end
    end,
    dependencies = {
      "anott03/nvim-lspinstall",
      "hrsh7th/cmp-nvim-lsp",
      {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
      },
    },
    config = function()
      vim.lsp.set_log_level("off")

      require("mason").setup({
        registries = {
          "github:mason-org/mason-registry",
          "github:Crashdummyy/mason-registry",
        },
        ui = {
          icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
          },
        },
      })

      -- Exclude rust_analyzer: rustaceanvim owns that LSP client.
      -- Without this, mason-lspconfig auto-enables rust_analyzer and you get two instances.
      require("mason-lspconfig").setup({
        automatic_enable = {
          exclude = { "rust_analyzer" },
        },
      })

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- ── Pyright ────────────────────────────────────────────────────────────
      -- Primary Python LSP: type checking, completions, go-to-def, hover.
      vim.lsp.config.pyright = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          -- Enable inlay hints per-buffer (mirrors the Rust setup)
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end,
        settings = {
          python = {
            analysis = {
              -- "basic" catches most real errors without being noisy
              typeCheckingMode = "basic",
              -- Auto-search for installed packages
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
              -- Inlay hints
              inlayHints = {
                variableTypes = true,        -- `x: int` after let-style assignments
                functionReturnTypes = true,  -- `-> str` after function defs
                parameterNames = true,       -- `foo(x=1)` call-site parameter labels
                parameterTypes = false,      -- off: param types are noisy in sigs
              },
            },
          },
        },
      }

      -- ── Jedi ───────────────────────────────────────────────────────────────
      -- Optional secondary completions server. Only runs if jedi-language-server
      -- is installed (`pip install jedi-language-server` or via Mason).
      -- definitionProvider disabled to avoid competing with pyright on gd.
      vim.lsp.config.jedi_language_server = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.definitionProvider = false
        end,
      }

      -- ── Ruff ───────────────────────────────────────────────────────────────
      -- Fast linter + formatter. Only runs if ruff is installed
      -- (`pip install ruff` or `mason install ruff`).
      vim.lsp.config.ruff = {
        settings = {
          ruff = {
            format = { args = { "--config", "pyproject.toml" } },
            lint = { args = {} },
            organize_imports = true,
          },
        },
        on_attach = function(client, bufnr)
          -- Use client:supports_method (colon) — dot-call is deprecated in nvim 0.12
          if client:supports_method("textDocument/formatting") then
            -- Guard with a named group so reattach doesn't register duplicates
            local group = vim.api.nvim_create_augroup(
              "RuffFormatOnSave_" .. bufnr, { clear = true }
            )
            vim.api.nvim_create_autocmd("BufWritePre", {
              group = group,
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
        capabilities = capabilities,
      }

      -- ── TypeScript ─────────────────────────────────────────────────────────
      -- C# is handled by seblyng/roslyn.nvim in csharp.lua (parallels rustaceanvim).
      vim.lsp.config.ts_ls = {}

      -- Enable all servers; LSP simply won't start for servers that aren't installed
      vim.lsp.enable({ "pyright", "jedi_language_server", "ruff", "ts_ls" })

      -- ── Diagnostics ────────────────────────────────────────────────────────
      vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = true,
      })

      local function set_diagnostic_underline_colors()
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { underline = true, sp = "#e67e80" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn",  { underline = true, sp = "#dbbc7f" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo",  { underline = true, sp = "#7fbbb3" })
        vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint",  { underline = true, sp = "#a7c080" })
      end
      set_diagnostic_underline_colors()
      vim.api.nvim_create_autocmd("ColorScheme", { callback = set_diagnostic_underline_colors })

      -- ── Global LSP keymaps ─────────────────────────────────────────────────
      -- (Rust gets its own overrides in rust.lua on_attach, e.g. K → hover actions)
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gw", vim.lsp.buf.document_symbol, opts)
      vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
      vim.keymap.set("n", "<leader>af", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      -- ── Auto-open Trouble panels ─────────────────────────────────────────────
      -- Open the diagnostics/symbols panels when an LSP attaches, but only if a
      -- window for that mode isn't already visible. We check the actual windows
      -- (trouble tags each with vim.w[win].trouble.mode) rather than trouble's own
      -- is_open(): edgy's window management desyncs trouble's internal view tracking,
      -- so trouble thinks nothing is open and spawns a duplicate panel for every new
      -- file. Scanning the real windows is the authoritative guard.
      local function trouble_mode_visible(mode)
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local t = vim.w[win].trouble
          if t and t.mode == mode then
            return true
          end
        end
        return false
      end
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          if not trouble_mode_visible("diagnostics") then
            vim.cmd("Trouble diagnostics focus=false")
          end
          if not trouble_mode_visible("symbols") then
            vim.cmd("Trouble symbols focus=false")
          end
        end,
      })
    end,
  },
}

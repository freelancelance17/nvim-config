return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "anott03/nvim-lspinstall",
      "hrsh7th/cmp-nvim-lsp",
      {
        "williamboman/mason.nvim",
        dependencies = { "williamboman/mason-lspconfig.nvim" },
      },
    },
    config = function()
      require("mason").setup({
        ui = {
          icons = {
            package_installed = "",
            package_pending = "",
            package_uninstalled = "",
          },
        },
      })
      require("mason-lspconfig").setup()

      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      vim.lsp.config.pyright = {
        capabilities = capabilities,
      }

      vim.lsp.config.jedi_language_server = {
        capabilities = capabilities,
        on_attach = function(client, bufnr)
          client.server_capabilities.definitionProvider = false
        end,
      }

      vim.lsp.config.ruff = {
        settings = {
          ruff = {
            format = { args = { "--config", "pyproject.toml" } },
            lint = { args = {} },
            organize_imports = true,
          },
        },
        on_attach = function(client, bufnr)
          if client.supports_method("textDocument/formatting") then
            vim.api.nvim_create_autocmd("BufWritePre", {
              buffer = bufnr,
              callback = function()
                vim.lsp.buf.format({ bufnr = bufnr })
              end,
            })
          end
        end,
        capabilities = capabilities,
      }

      vim.lsp.config.ts_ls = {}

      vim.lsp.config.csharp_ls = {
        capabilities = capabilities,
        on_attach = function(client, bufnr) end,
      }

      vim.lsp.enable({ "pyright", "jedi_language_server", "ruff", "ts_ls", "csharp_ls" })

      vim.diagnostic.config({
        virtual_text = true,
        signs = true,
        underline = true,
        update_in_insert = false,
        severity_sort = false,
      })

      vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())

      -- LSP keymaps
      local opts = { noremap = true, silent = true }
      vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
      vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
      vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
      vim.keymap.set("n", "gw", vim.lsp.buf.document_symbol, opts)
      vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, opts)
      vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
      vim.keymap.set("n", "gt", vim.lsp.buf.type_definition, opts)
      vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
      vim.keymap.set("n", "<leader>af", vim.lsp.buf.code_action, opts)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

      -- Open Trouble on LSP attach
      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function()
          vim.cmd("Trouble diagnostics")
          vim.cmd("Trouble symbols win.size=.25")
        end,
      })
    end,
  },
}

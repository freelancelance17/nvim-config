return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      -- Sources
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      -- nvim 0.12: patch deprecated client.request dot-call (fires on every keystroke in fn args)
      {
        "hrsh7th/cmp-nvim-lsp-signature-help",
        build = function()
          local path = vim.fn.stdpath("data")
            .. "/lazy/cmp-nvim-lsp-signature-help/lua/cmp_nvim_lsp_signature_help/init.lua"
          local content = table.concat(vim.fn.readfile(path), "\n")
          content = content:gsub(
            "client%.request%(\'textDocument/signatureHelp\'",
            "client:request('textDocument/signatureHelp'"
          )
          vim.fn.writefile(vim.split(content, "\n"), path)
        end,
      }, -- live function signature while typing
      "hrsh7th/cmp-cmdline",

      -- Snippets: LuaSnip + a big library of pre-built snippets (includes Rust)
      {
        "L3MON4D3/LuaSnip",
        version = "v2.*",
        build = "make install_jsregexp",
        dependencies = { "rafamadriz/friendly-snippets" },
        config = function()
          -- Load VS Code style snippets from friendly-snippets
          require("luasnip.loaders.from_vscode").lazy_load()
        end,
      },
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      local luasnip = require("luasnip")

      -- Helper: are we inside a snippet and can jump forward?
      local has_words_before = function()
        unpack = unpack or table.unpack
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
          and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
      end

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },

        mapping = cmp.mapping.preset.insert({
          -- Navigate completion menu
          ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
          ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),

          -- Tab: select next OR jump through snippet placeholders
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
              luasnip.expand_or_jump()
            elseif has_words_before() then
              cmp.complete()
            else
              fallback()
            end
          end, { "i", "s" }),

          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),

          -- Scroll docs popup
          ["<C-S-f>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),

          -- Manually trigger completion
          ["<C-Space>"] = cmp.mapping.complete(),

          -- Abort
          ["<C-e>"] = cmp.mapping.abort(),

          -- Confirm
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false, -- only confirm if something is explicitly selected
          }),
        }),

        sources = cmp.config.sources({
          -- LSP completions — keyword_length=1 so you get suggestions immediately
          { name = "nvim_lsp",                keyword_length = 1, priority = 1000 },
          -- Live function signature help while typing args
          { name = "nvim_lsp_signature_help", priority = 900 },
          -- Snippets
          { name = "luasnip",                 keyword_length = 2, priority = 750 },
          -- Filesystem paths
          { name = "path",                    priority = 500 },
        }, {
          -- Fallback sources (lower priority group)
          { name = "buffer", keyword_length = 3, priority = 250 },
        }),

        window = {
          completion = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
          documentation = cmp.config.window.bordered({
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
          }),
        },

        formatting = {
          fields = { "kind", "abbr", "menu" },
          format = function(entry, item)
            -- Source label shown in the menu column
            local source_labels = {
              nvim_lsp                = "[LSP]",
              nvim_lsp_signature_help = "[Sig]",
              luasnip                 = "[Snip]",
              buffer                  = "[Buf]",
              path                    = "[Path]",
            }
            item.menu = source_labels[entry.source.name] or string.format("[%s]", entry.source.name)
            return item
          end,
        },

        -- Show completions even when there's only one candidate
        -- (lets you see its docs without pressing Enter)
        experimental = {
          ghost_text = { hl_group = "Comment" }, -- greyed-out inline preview of first suggestion
        },
      })

      -- Git commit completions
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "cmp_git" },
        }, {
          { name = "buffer" },
        }),
      })

      -- Search completions ( / and ? )
      cmp.setup.cmdline({ "/", "?" }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = "buffer" },
        },
      })

      -- Command-line completions ( : )
      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })
    end,
  },
}

return {
  -- rustaceanvim: actively maintained rust-analyzer integration
  -- replaces the archived simrat39/rust-tools.nvim
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    ft = { "rust" },
    config = function()
      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"
      local liblldb_path = mason_path .. "/packages/codelldb/extension/lldb/lib/liblldb.dylib"

      vim.g.rustaceanvim = {
        dap = {
          adapter = require("rustaceanvim.config").get_codelldb_adapter(codelldb_path, liblldb_path),
        },

        tools = {
          -- Show hover actions in a popup rather than a split
          hover_actions = { auto_focus = true },
          -- Float window for inlay hint explanations etc.
          float_win_config = {
            border = "rounded",
            max_width = math.floor(vim.o.columns * 0.8),
            max_height = math.floor(vim.o.lines * 0.8),
          },
        },

        server = {
          capabilities = require("cmp_nvim_lsp").default_capabilities(),

          on_attach = function(client, bufnr)
            -- Enable inlay hints for this buffer
            vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })

            local opts = { noremap = true, silent = true, buffer = bufnr }

            -- Override K to use rust-analyzer hover (shows rendered docs + actions)
            vim.keymap.set("n", "K", function()
              vim.cmd.RustLsp({ "hover", "actions" })
            end, opts)

            -- Runnables / Debuggables (picks targets from Cargo)
            vim.keymap.set("n", "<leader>rr", function()
              vim.cmd.RustLsp("runnables")
            end, vim.tbl_extend("force", opts, { desc = "Rust: runnables" }))

            vim.keymap.set("n", "<leader>rd", function()
              vim.cmd.RustLsp("debuggables")
            end, vim.tbl_extend("force", opts, { desc = "Rust: debuggables" }))

            -- Expand macro under cursor
            vim.keymap.set("n", "<leader>re", function()
              vim.cmd.RustLsp("expandMacro")
            end, vim.tbl_extend("force", opts, { desc = "Rust: expand macro" }))

            -- Open Cargo.toml
            vim.keymap.set("n", "<leader>rc", function()
              vim.cmd.RustLsp("openCargo")
            end, vim.tbl_extend("force", opts, { desc = "Rust: open Cargo.toml" }))

            -- Jump to parent module
            vim.keymap.set("n", "<leader>rp", function()
              vim.cmd.RustLsp("parentModule")
            end, vim.tbl_extend("force", opts, { desc = "Rust: parent module" }))

            -- Explain error under cursor
            vim.keymap.set("n", "<leader>rx", function()
              vim.cmd.RustLsp("explainError")
            end, vim.tbl_extend("force", opts, { desc = "Rust: explain error" }))

            -- Render diagnostics (rendered rustc output)
            vim.keymap.set("n", "<leader>rD", function()
              vim.cmd.RustLsp("renderDiagnostic")
            end, vim.tbl_extend("force", opts, { desc = "Rust: render diagnostic" }))

            -- Reload workspace (useful after adding deps)
            vim.keymap.set("n", "<leader>rw", function()
              vim.cmd.RustLsp("reloadWorkspace")
            end, vim.tbl_extend("force", opts, { desc = "Rust: reload workspace" }))

            -- Toggle inlay hints
            vim.keymap.set("n", "<leader>rh", function()
              vim.lsp.inlay_hint.enable(
                not vim.lsp.inlay_hint.is_enabled({ bufnr = bufnr }),
                { bufnr = bufnr }
              )
            end, vim.tbl_extend("force", opts, { desc = "Rust: toggle inlay hints" }))
          end,

          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = { enable = true },
              },

              -- Use clippy instead of cargo check for richer lints
              check = {
                command = "clippy",
                extraArgs = { "--no-deps" },
                allFeatures = true,
              },

              -- Proc macro support (needed for things like tokio::main, derive macros)
              procMacro = {
                enable = true,
                ignored = {
                  ["async-trait"] = { "async_trait" },
                  ["napi-derive"] = { "napi" },
                  ["async-recursion"] = { "async_recursion" },
                },
              },

              -- Inlay hints — the more useful ones enabled, noisier ones off
              inlayHints = {
                -- Type hints after let bindings: `let x/*: i32*/ = ...`
                typeHints = { enable = true },
                -- Function parameter name hints: `foo(/*x:*/ 1)`
                parameterHints = { enable = true },
                -- Method chain hints: shows intermediate types in chains
                chainingHints = { enable = true },
                -- Closing brace hints for long blocks/fns
                closingBraceHints = { enable = true, minLines = 20 },
                -- Closure return type hints
                closureReturnTypeHints = { enable = "with_block" },
                -- Binding mode hints (ref, mut) — off by default, noisy
                bindingModeHints = { enable = false },
                -- Lifetime elision hints — off, too noisy for daily use
                lifetimeElisionHints = { enable = "never" },
                -- Expression adjustment hints (deref coercions)
                expressionAdjustmentHints = { enable = "never" },
                -- Cap hint length so long types don't overflow
                maxLength = { enable = true, maxLength = 30 },
                renderColons = { enable = true },
              },

              -- Diagnostics
              diagnostics = {
                enable = true,
                experimental = { enable = true },
              },

              -- Better completion
              completion = {
                addCallParentheses = true,
                addCallArgumentSnippets = true,
                postfix = { enable = true },        -- .if, .match, .while, etc.
                autoimport = { enable = true },      -- auto-adds use statements
                privateEditable = { enable = true }, -- complete private items in same crate
              },

              -- Hover: show documentation and memory layout
              hover = {
                actions = {
                  enable = true,
                  run = { enable = true },
                  debug = { enable = true },
                  gotoTypeDef = { enable = true },
                  implementations = { enable = true },
                  references = { enable = true },
                },
                links = { enable = true },
                memoryLayout = { enable = true },
              },

              -- Semantic highlighting
              semanticHighlighting = {
                operator = { specialization = { enable = true } },
                punctuation = {
                  enable = true,
                  specialization = { enable = true },
                  separate = { macro = { bang = true } },
                },
                strings = { enable = true },
              },
            },
          },
        },
      }
    end,
  },

  -- nvim-nio: patch deprecated client.request/notify/supports_method dot-calls
  -- Neovim 0.12 requires colon-call (client:request) for LSP client methods.
  -- The build hook re-applies the patch after every :Lazy update.
  {
    "nvim-neotest/nvim-nio",
    build = function()
      local path = vim.fn.stdpath("data") .. "/lazy/nvim-nio/lua/nio/lsp.lua"
      local content = table.concat(vim.fn.readfile(path), "\n")
      content = content
        :gsub("client%.request%(method, params, cb, bufnr%)", "client:request(method, params, cb, bufnr)")
        :gsub("client%.supports_method%(method, opts%)", "client:supports_method(method, opts)")
        :gsub("client%.notify%(method, params%)", "client:notify(method, params)")
      vim.fn.writefile(vim.split(content, "\n"), path)
    end,
  },

  -- DAP (debugger) — kept as-is, codelldb via Mason
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "theHamsta/nvim-dap-virtual-text",
      "nvim-neotest/nvim-nio",
      "williamboman/mason.nvim",
    },
    config = function()
      local dap = require("dap")
      local ui = require("dapui")

      dap.set_log_level("DEBUG")

      -- Breakpoint signs: distinct glyphs per type so you can tell them apart at a glance
      vim.fn.sign_define("DapBreakpoint",          { text = "●", texthl = "DiagnosticError",   linehl = "", numhl = "" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "◉", texthl = "DiagnosticWarn",    linehl = "", numhl = "" })
      vim.fn.sign_define("DapLogPoint",            { text = "◆", texthl = "DiagnosticInfo",    linehl = "", numhl = "" })
      vim.fn.sign_define("DapStopped",             { text = "▶", texthl = "DiagnosticOk",      linehl = "CursorLine", numhl = "" })
      vim.fn.sign_define("DapBreakpointRejected",  { text = "✕", texthl = "DiagnosticHint",    linehl = "", numhl = "" })

      require("dapui").setup({
        layouts = {
          {
            elements = {
              { id = "scopes",      size = 0.40 },
              { id = "breakpoints", size = 0.15 },
              { id = "stacks",      size = 0.30 },
              { id = "watches",     size = 0.15 },
            },
            position = "left",
            size = 45,
          },
          {
            elements = {
              { id = "repl",    size = 0.5 },
              { id = "console", size = 0.5 },
            },
            position = "bottom",
            size = 12,
          },
        },
      })

      require("nvim-dap-virtual-text").setup({
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
            return " *****"
          end
          if #variable.value > 40 then
            return " " .. string.sub(variable.value, 1, 40) .. "…"
          end
          return " " .. variable.value
        end,
      })

      local mason_path = vim.fn.stdpath("data") .. "/mason"
      local codelldb_path = mason_path .. "/packages/codelldb/extension/adapter/codelldb"

      dap.adapters.codelldb = {
        type = "server",
        port = "${port}",
        executable = {
          command = codelldb_path,
          args = { "--port", "${port}" },
        },
      }

      dap.configurations.rust = {
        {
          name = "Launch",
          type = "codelldb",
          request = "launch",
          program = function()
            return vim.fn.input("Path to executable: ", vim.fn.getcwd() .. "/target/debug/", "file")
          end,
          cwd = "${workspaceFolder}",
          stopOnEntry = false,
        },
      }

      -- Step controls
      vim.keymap.set("n", "<F5>",      dap.continue,                            { desc = "Debug: continue" })
      vim.keymap.set("n", "<F10>",     dap.step_over,                           { desc = "Debug: step over" })
      vim.keymap.set("n", "<F11>",     dap.step_into,                           { desc = "Debug: step into" })
      vim.keymap.set("n", "<S-F11>",   dap.step_out,                            { desc = "Debug: step out" })
      vim.keymap.set("n", "<S-F5>",    dap.close,                               { desc = "Debug: stop" })
      vim.keymap.set("n", "<C-S-F5>",  dap.restart,                             { desc = "Debug: restart" })
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor,                       { desc = "Debug: run to cursor" })

      -- Breakpoints
      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint, { desc = "Debug: toggle breakpoint" })
      vim.keymap.set("n", "<S-F9>", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "Debug: conditional breakpoint" })
      vim.keymap.set("n", "<leader>dl", function()
        dap.set_breakpoint(nil, nil, vim.fn.input("Log message: "))
      end, { desc = "Debug: log point" })
      vim.keymap.set("n", "<leader>dB", dap.clear_breakpoints, { desc = "Debug: clear all breakpoints" })

      -- Inspect / UI
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end, { desc = "Debug: eval expression" })
      vim.keymap.set("v", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end, { desc = "Debug: eval selection" })
      vim.keymap.set("n", "<leader>du", ui.toggle, { desc = "Debug: toggle UI" })
      vim.keymap.set("n", "<leader>dr", dap.repl.open, { desc = "Debug: open REPL" })
      vim.keymap.set("n", "<leader>dL", function()
        vim.cmd("edit " .. vim.fn.stdpath("state") .. "/dap.log")
      end, { desc = "Debug: open log" })

      dap.listeners.before.attach.dapui_config = function() ui.open() end
      dap.listeners.before.launch.dapui_config = function() ui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
      dap.listeners.before.event_exited.dapui_config = function() ui.close() end
    end,
  },
}

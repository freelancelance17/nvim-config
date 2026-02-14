return {
  "simrat39/rust-tools.nvim",
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

      require("dapui").setup()

      require("nvim-dap-virtual-text").setup({
        display_callback = function(variable)
          local name = string.lower(variable.name)
          local value = string.lower(variable.value)
          if name:match("secret") or name:match("api") or value:match("secret") or value:match("api") then
            return "*****"
          end
          if #variable.value > 15 then
            return " " .. string.sub(variable.value, 1, 15) .. "... "
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

      vim.keymap.set("n", "<F9>", dap.toggle_breakpoint)
      vim.keymap.set("n", "<space>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<space>?", function()
        require("dapui").eval(nil, { enter = true })
      end)
      vim.keymap.set("n", "<F5>", dap.continue)
      vim.keymap.set("n", "<F11>", dap.step_into)
      vim.keymap.set("n", "<F10>", dap.step_over)
      vim.keymap.set("n", "<S-F11>", dap.step_out)
      vim.keymap.set("n", "<S-F5>", dap.close)
      vim.keymap.set("n", "<C-S-F5>", dap.restart)

      dap.listeners.before.attach.dapui_config = function() ui.open() end
      dap.listeners.before.launch.dapui_config = function() ui.open() end
      dap.listeners.before.event_terminated.dapui_config = function() ui.close() end
      dap.listeners.before.event_exited.dapui_config = function() ui.close() end
    end,
  },
}

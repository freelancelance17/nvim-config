return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap", "rcarriga/nvim-dap-ui" },
    config = function()
      local function get_python()
        -- Mason's debugpy venv is the most reliable — has debugpy guaranteed
        local mason_debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
        if vim.fn.filereadable(mason_debugpy) == 1 then return mason_debugpy end
        -- Fall back to project venv (user must have debugpy installed there)
        for _, venv in ipairs({ ".venv", "venv", ".env" }) do
          local p = vim.fn.getcwd() .. "/" .. venv .. "/bin/python"
          if vim.fn.filereadable(p) == 1 then return p end
        end
        return vim.fn.exepath("python3") or "python3"
      end

      require("dap-python").setup(get_python())

      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          local opts = { noremap = true, silent = true, buffer = true }

          vim.keymap.set("n", "<leader>pr", function()
            -- Run the current file in a throwaway floating terminal (toggleterm).
            -- close_on_exit=false keeps the output up so you can read it.
            local file = vim.fn.shellescape(vim.fn.expand("%:p"))
            require("toggleterm.terminal").Terminal
              :new({
                cmd = "python3 " .. file,
                direction = "float",
                close_on_exit = false,
                float_opts = { border = "rounded" },
              })
              :toggle()
          end, vim.tbl_extend("force", opts, { desc = "Python: run file" }))

          vim.keymap.set("n", "<leader>pd", function()
            require("dap").continue()
          end, vim.tbl_extend("force", opts, { desc = "Python: debug file" }))

          vim.keymap.set("n", "<leader>pm", function()
            require("dap-python").test_method()
          end, vim.tbl_extend("force", opts, { desc = "Python: debug nearest method" }))

          vim.keymap.set("n", "<leader>pc", function()
            require("dap-python").test_class()
          end, vim.tbl_extend("force", opts, { desc = "Python: debug nearest class" }))

          vim.keymap.set("n", "<leader>pb", function()
            require("dap").toggle_breakpoint()
          end, vim.tbl_extend("force", opts, { desc = "Python: toggle breakpoint" }))

          vim.keymap.set("v", "<leader>ps", function()
            require("dap-python").debug_selection()
          end, vim.tbl_extend("force", opts, { desc = "Python: debug selection" }))
        end,
      })
    end,
  },
}

if not require("features").plugins.python then return {} end

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

      -- mypy resolution deliberately inverts get_python()'s order: Mason's
      -- debugpy venv only ships debugpy, and mypy has to import the project's
      -- own deps/stubs to resolve types at all, so a project venv always wins.
      local function get_mypy()
        for _, venv in ipairs({ ".venv", "venv", ".env" }) do
          local p = vim.fn.getcwd() .. "/" .. venv .. "/bin/mypy"
          if vim.fn.executable(p) == 1 then return p end
        end
        local mason = vim.fn.stdpath("data") .. "/mason/bin/mypy"
        if vim.fn.executable(mason) == 1 then return mason end
        if vim.fn.executable("mypy") == 1 then return "mypy" end
        return nil
      end

      -- mypy reads mypy.ini/pyproject.toml relative to its cwd, so run it from
      -- the project root — nvim's cwd may be elsewhere, and silently ignoring
      -- the project's config gives a wall of bogus import errors.
      local function project_root(file)
        local markers = { "mypy.ini", ".mypy.ini", "pyproject.toml", "setup.cfg", ".git" }
        local found = vim.fs.find(markers, { path = vim.fs.dirname(file), upward = true })[1]
        return found and vim.fs.dirname(found) or vim.fn.getcwd()
      end

      local function type_check()
        local mypy = get_mypy()
        if not mypy then
          vim.notify("mypy not found — `pip install mypy` in your venv", vim.log.levels.ERROR)
          return
        end

        local file = vim.fn.expand("%:p")
        if file == "" then
          vim.notify("mypy: buffer has no file on disk", vim.log.levels.WARN)
          return
        end

        -- autosave defers writes by a second, so the file on disk can lag the
        -- buffer on screen — mypy would report line numbers that no longer match.
        if vim.bo.modified then vim.cmd("silent! write") end

        vim.notify("mypy: checking " .. vim.fn.fnamemodify(file, ":t") .. "…", vim.log.levels.INFO)

        vim.system({
          mypy,
          "--show-column-numbers",
          "--no-error-summary",
          "--no-color-output",
          file,
        }, { cwd = project_root(file), text = true }, function(res)
          vim.schedule(function()
            local out = (res.stdout or "") .. (res.stderr or "")

            -- --show-column-numbers is a request, not a guarantee (a project
            -- config can turn it off), so keep the column-less form as fallback.
            local items = vim.fn.getqflist({
              lines = vim.split(out, "\n", { trimempty = true }),
              efm = table.concat({
                "%f:%l:%c: %t%*[^:]: %m",
                "%f:%l: %t%*[^:]: %m",
              }, ","),
            }).items
            items = vim.tbl_filter(function(i) return i.valid == 1 end, items)

            if #items == 0 then
              vim.fn.setqflist({}, "r", { title = "mypy" })
              -- exit 2 is a crash/usage error, not a clean run — don't claim success
              if res.code >= 2 then
                vim.notify("mypy failed:\n" .. out, vim.log.levels.ERROR)
              else
                vim.notify("mypy: no issues found", vim.log.levels.INFO)
              end
              return
            end

            vim.fn.setqflist({}, "r", { title = "mypy", items = items })
            if not pcall(vim.cmd, "Trouble qflist open") then vim.cmd("copen") end
          end)
        end)
      end

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

          vim.keymap.set("n", "<leader>pt", type_check,
            vim.tbl_extend("force", opts, { desc = "Python: type check file (mypy)" }))

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

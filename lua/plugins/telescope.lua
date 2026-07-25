if not require("features").plugins.telescope then return {} end

return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope-dap.nvim",
    },
    keys = {
      { "<C-p>",      function() require("telescope.builtin").find_files() end, desc = "Find files" },
      { "<leader>fs", function() require("telescope.builtin").live_grep() end, desc = "Live grep" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end, desc = "Help tags" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end, desc = "Buffers" },
      { "<leader>fr", "<cmd>Telescope projects<CR>", desc = "Projects" },
      { "<leader>fd", "<cmd>Telescope lsp_definitions<CR>", desc = "LSP definitions" },
      { "<leader>fu", function() require("telescope.builtin").lsp_references() end, desc = "LSP references" },
      { "<leader>fw", function() require("telescope.builtin").grep_string({ search = vim.fn.expand("<cword>") }) end, desc = "Grep word under cursor" },
      -- DAP pickers
      { "<leader>db", "<cmd>Telescope dap list_breakpoints<CR>", desc = "Debug: list breakpoints" },
      { "<leader>df", "<cmd>Telescope dap frames<CR>",           desc = "Debug: frames" },
      { "<leader>dc", "<cmd>Telescope dap commands<CR>",         desc = "Debug: commands" },
    },
    config = function()
      local actions = require("telescope.actions")
      -- Opening a file from telescope can leave us in insert mode (the layout's
      -- always-open terminal / an async startinsert wins focus). Force normal mode
      -- after any select action; the deferred stopinsert beats the async insert.
      local function select_then_normal(action)
        return function(bufnr)
          action(bufnr)
          vim.schedule(function() vim.cmd("stopinsert") end)
        end
      end
      local select_maps = {
        ["<CR>"] = select_then_normal(actions.select_default),
        ["<C-x>"] = select_then_normal(actions.select_horizontal),
        ["<C-v>"] = select_then_normal(actions.select_vertical),
        ["<C-t>"] = select_then_normal(actions.select_tab),
      }
      require("telescope").setup({
        defaults = {
          vimgrep_arguments = {
            "rg", "--color=never", "--no-heading", "--with-filename",
            "--line-number", "--column", "--smart-case", "--hidden",
          },
          prompt_prefix = "> ",
          selection_caret = "> ",
          path_display = { "truncate" },
          mappings = {
            i = select_maps,
            n = select_maps,
          },
        },
      })
      require("telescope").load_extension("dap")
    end,
  },
}

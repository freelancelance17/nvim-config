return {
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VimEnter",
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        size = 8,
      })

      local Terminal = require("toggleterm.terminal").Terminal

      -- A reusable floating terminal (replaces the old vim-floaterm). `hidden`
      -- keeps it out of the buffer list; toggling re-shows the same instance.
      local float_term = Terminal:new({
        direction = "float",
        hidden = true,
        float_opts = { border = "rounded" },
        on_open = function(term)
          -- In the float, <Esc> closes it (the docked terminal uses <Esc> for
          -- normal mode — see the FileType autocmd below; this buffer-local map
          -- runs on each open and overrides that for the float only).
          vim.keymap.set("t", "<Esc>", function()
            term:toggle()
          end, { buffer = term.bufnr })
        end,
      })

      -- ── Keymaps ──────────────────────────────────────────────────────────
      -- Focus the always-docked horizontal terminal (edgy keeps it open), or
      -- open it if it isn't present. Only matches the docked (non-floating) one.
      vim.keymap.set("n", "<C-t>", function()
        for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local buf = vim.api.nvim_win_get_buf(win)
          if
            vim.bo[buf].filetype == "toggleterm"
            and vim.api.nvim_win_get_config(win).relative == ""
          then
            vim.api.nvim_set_current_win(win)
            vim.cmd("startinsert")
            return
          end
        end
        vim.cmd("ToggleTerm")
      end, { desc = "Focus docked terminal" })

      -- Floating terminal (was vim-floaterm's <leader>ft / t)
      vim.keymap.set("n", "<leader>ft", function()
        float_term:toggle()
      end, { desc = "Toggle float terminal" })
      vim.keymap.set("n", "t", function()
        float_term:toggle()
      end, { desc = "Toggle float terminal" })

      -- In the docked terminal, <Esc> drops from terminal-insert to normal mode
      -- so you can scroll up and read output (then i/a to type again).
      -- Trade-off: TUI apps run in the docked terminal won't receive Esc.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "toggleterm",
        callback = function(args)
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf })
        end,
      })
    end,
  },
}

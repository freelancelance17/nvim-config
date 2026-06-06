return {
  {
    "voldikss/vim-floaterm",
    keys = {
      { "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ", desc = "New float terminal" },
      { "t", ":FloatermToggle myfloat<CR>", desc = "Toggle float terminal" },
    },
    config = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "floaterm",
        callback = function()
          vim.keymap.set("t", "<Esc>", "<C-\\><C-n>:q<CR>", { buffer = true })
        end,
      })
    end,
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    event = "VimEnter",
    keys = {
      {
        "<C-t>",
        function()
          -- The terminal is always docked open (edgy), so just focus it rather
          -- than toggle. Fall back to opening it if it isn't present.
          for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "toggleterm" then
              vim.api.nvim_set_current_win(win)
              vim.cmd("startinsert")
              return
            end
          end
          vim.cmd("ToggleTerm")
        end,
        desc = "Focus terminal",
      },
    },
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        size = 8,
      })

      -- In the docked terminal, <Esc> drops from terminal-insert to normal mode so
      -- you can scroll up and read the output (then i/a to type again). Buffer-local
      -- to toggleterm. Trade-off: TUI apps run in this terminal won't receive Esc.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "toggleterm",
        callback = function(args)
          vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { buffer = args.buf })
        end,
      })
    end,
  },
}

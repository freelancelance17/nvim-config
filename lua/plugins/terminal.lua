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
      { "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup({
        direction = "horizontal",
        size = 8,
      })
    end,
  },
}

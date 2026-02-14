return {
  {
    "voldikss/vim-floaterm",
    keys = {
      { "<leader>ft", ":FloatermNew --name=myfloat --height=0.8 --width=0.7 --autoclose=2 fish <CR> ", desc = "New float terminal" },
      { "t", ":FloatermToggle myfloat<CR>", desc = "Toggle float terminal" },
      { "<Esc>", "<C-\\><C-n>:q<CR>", mode = "t", desc = "Exit terminal" },
    },
  },
  {
    "akinsho/toggleterm.nvim",
    version = "*",
    keys = {
      { "<C-t>", "<cmd>ToggleTerm<CR>", desc = "Toggle terminal" },
    },
    config = function()
      require("toggleterm").setup()
    end,
  },
}

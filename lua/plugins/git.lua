return {
  "f-person/git-blame.nvim",
  "Xuyuanp/nerdtree-git-plugin",
  "sindrets/diffview.nvim",
  {
    "lewis6991/gitsigns.nvim",
    lazy = false,
    opts = {
      base = "main",
      attach_to_untracked = true,
    },
  },
}

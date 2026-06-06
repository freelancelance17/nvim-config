return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    cmd = "Neotree",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    keys = {
      { "\\\\", "<cmd>Neotree focus<cr>", desc = "Focus file tree" },
    },
    opts = {
      close_if_last_window = false,
      popup_border_style = "rounded",
      enable_git_status = true,
      enable_diagnostics = true,
      filesystem = {
        -- edgy docks this window on the left; neo-tree just provides it.
        hijack_netrw_behavior = "open_default",
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          visible = true,        -- show hidden files (was NERDTreeShowHidden = 1)
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        width = 35,
        mappings = {
          ["\\"] = "close_window",
        },
      },
    },
  },
}

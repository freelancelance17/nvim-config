return {
  -- Themes
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    config = function()
      require("github-theme").setup({})
      vim.cmd("colorscheme github_dark")
    end,
  },
  "freelancelance17/ursala.nvim",

  -- Status line
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("lualine").setup({
        options = {
          icons_enabled = true,
          theme = "auto",
          component_separators = { left = "", right = "" },
          section_separators = { left = "", right = "" },
          disabled_filetypes = { statusline = {}, winbar = {} },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = true,
          refresh = { statusline = 10, tabline = 10, winbar = 10 },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "encoding", "fileformat", "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { "filename" },
          lualine_x = { "location" },
          lualine_y = {},
          lualine_z = {},
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {},
      })
    end,
  },

  -- render-markdown: syntax-highlighted code blocks, styled headings and lists
  -- inside LSP hover windows, completion docs, and any markdown buffer.
  -- Works because Noice sets filetype=markdown on hover/doc floats, and
  -- render-markdown then renders them with treesitter highlighting.
  {
    "MeanderingProgrammer/render-markdown.nvim",
    dependencies = {
      "nvim-treesitter/nvim-treesitter",
      "nvim-tree/nvim-web-devicons",
    },
    ft = { "markdown" },   -- also activates on hover/cmp nofile buffers via overrides
    opts = {
      -- Code blocks: full background highlight + language badge
      code = {
        enabled = true,
        style = "full",    -- background + left border
        border = "thin",
        language_name = true,
        language_pad = 1,
        min_width = 0,
      },
      -- Headings: icons + level-coloured background
      heading = {
        enabled = true,
        sign = false,
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },
      },
      -- Bullet lists: replace `-`/`*` with styled icons
      bullet = {
        enabled = true,
        icons = { "●", "○", "◆", "◇" },
      },
      -- Inline code: slightly highlighted
      inline_highlight = { enabled = true },
      -- Tables: draw aligned borders
      pipe_table = {
        enabled = true,
        preset = "round",
      },
      -- Horizontal rules: full-width decorative line
      dash = { enabled = true },
      -- Nofile buffers (hover windows, cmp docs, noice messages):
      -- disable signs (no gutter in floats) and use float background
      overrides = {
        buftype = {
          nofile = {
            sign = { enabled = false },
            padding = { highlight = "NormalFloat" },
          },
        },
      },
    },
  },

  -- Noice (UI for messages, cmdline, popupmenu)
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = {
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
    },
    opts = {
      cmdline = {
        view = "cmdline",
        format = {
          filter = false,
        },
      },
      lsp = {
        -- Hover and signature windows — render-markdown picks these up via
        -- filetype=markdown which Noice sets on the float buffer
        hover = {
          enabled = true,
          silent = true,   -- don't show "no information" if hover is empty
        },
        signature = { enabled = true },
        -- Progress messages (e.g. "rust-analyzer: indexing 42/100")
        progress = {
          enabled = true,
          throttle = 1000 / 30, -- max 30 updates/sec
          view = "mini",        -- small bottom-right notification, not full toast
          format = "lsp_progress",
          format_done = "lsp_progress_done",
        },
        -- Route LSP docs through Noice's markdown renderer so render-markdown
        -- can apply its treesitter-based highlighting
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
        -- Scroll the hover/signature float without leaving the code buffer
        documentation = {
          view = "hover",
          opts = {
            lang = "markdown",
            replace = true,
            render = "plain",
            format = { "{message}" },
            win_options = { concealcursor = "n", conceallevel = 3 },
          },
        },
      },
      -- Scroll keymaps for hover/signature floats
      views = {
        hover = {
          border = { style = "rounded" },
          position = { row = 2, col = 0 },
          size = { max_width = 80, max_height = 20 },
        },
      },
      keys = {
        { "<C-d>", false },
        {
          "<C-d>",
          function() require("noice.lsp").scroll(4) end,
          silent = true, expr = true,
          desc = "Scroll docs down",
          mode = { "i", "n", "s" },
          has = "hover",
        },
        {
          "<C-u>",
          function() require("noice.lsp").scroll(-4) end,
          silent = true, expr = true,
          desc = "Scroll docs up",
          mode = { "i", "n", "s" },
          has = "hover",
        },
      },
      presets = {
        bottom_search = true,
        command_palette = false,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = true,
      },
    },
  },

  -- Tabs
  {
    "romgrk/barbar.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    keys = {
      { "<C-left>", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
      { "<C-right>", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
    },
    config = function()
      require("barbar").setup({
        animation = true,
        sidebar_filetypes = { NvimTree = true },
      })
    end,
  },
}

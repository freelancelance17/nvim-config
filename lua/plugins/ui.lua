if not require("features").plugins.ui then return {} end

return {
  -- Themes
  -- nightfox.nvim is the active colorscheme. lazy=false + high priority so it
  -- loads and applies before other UI plugins render. Other styles ship in the
  -- same plugin: dayfox, dawnfox, duskfox, nordfox, terafox, carbonfox.
  {
    "EdenEast/nightfox.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("nightfox").setup({})
      vim.cmd("colorscheme nightfox")
    end,
  },
  -- ursala is your own theme, kept available but lazy (load via `:colorscheme
  -- ursala`) so it doesn't load at startup.
  { "freelancelance17/ursala.nvim", lazy = true },

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
          lualine_a = { "mode", function()
            local reg = vim.fn.reg_recording()
            return reg ~= "" and "● @" .. reg or ""
          end },
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
        -- Progress messages (e.g. "rust-analyzer: indexing 42/100"). These open a
        -- transient `mini` float, which used to bounce the editor cursor up a line —
        -- root cause was edgy relaying out on the float and not restoring the editor
        -- window's view; now fixed in plugins/layout.lua, so this can stay enabled.
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
          -- Full-width info bar instead of the default small cursor-hugging box.
          -- relative="win" (default is "cursor") so col=0 means the window's left
          -- edge and size.width can be a percentage of the window; Neovim's
          -- cursor-relative floats can't also pin the left edge to a window-relative
          -- column, so this trades "box tracks the cursor's line" for "box spans the
          -- full buffer width" — it now docks just under the top of the window.
          -- No border (style="none"): a visible border/side-padding needs a couple
          -- of columns beyond the requested width, which would get clipped at the
          -- window edges when width is 100%. Top/bottom padding only for breathing
          -- room; NormalFloat background marks the box instead of a frame.
          -- anchor pinned explicitly: Noice's default anchor="auto" only resolves
          -- to a real value when size.width/height are plain numbers (see
          -- NuiView:update_options in noice/view/nui.lua) — with a percentage
          -- width like ours it silently leaves anchor as the literal string
          -- "auto", which nvim_open_win then rejects with "Invalid anchor 'auto'".
          relative = "win",
          anchor = "NW",
          position = { row = 1, col = 0 },
          size = { width = "100%", max_height = 20 },
          border = { style = "none", padding = { 1, 0, 1, 0 } },
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
    -- Must load eagerly. barbar hooks buffer-creation events and owns the tabline;
    -- if lazy-loaded (e.g. only via `keys`) it isn't active when the first buffer
    -- opens at startup, so that buffer's name doesn't appear in the tabline until a
    -- later buffer event fires — i.e. until you switch files. lazy = false makes it
    -- load before the initial buffer, so the startup file shows immediately.
    lazy = false,
    keys = {
      { "<C-left>", "<Cmd>BufferPrevious<CR>", desc = "Previous buffer" },
      { "<C-right>", "<Cmd>BufferNext<CR>", desc = "Next buffer" },
    },
    config = function()
      require("barbar").setup({
        animation = true,
        sidebar_filetypes = { ["neo-tree"] = true },
      })
    end,
  },
}

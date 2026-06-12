-- IDE-style window layout, managed by edgy.nvim.
--
-- edgy owns the placement, sizing, ordering, and pinning of the side/bottom
-- panels. Each entry below says "a window with this filetype lives on this edge
-- at this size" — edgy docks it there automatically, keeps it fixed, and stops
-- other windows from changing its dimensions. This replaces the hand-rolled
-- enforce_layout / wincmd J / resize autocmds that used to live in autocommands.lua.
return {
  {
    "folke/edgy.nvim",
    event = "VeryLazy",
    init = function()
      -- Recommended by edgy so splits behave predictably with fixed edgebars.
      vim.opt.laststatus = 3
      vim.opt.splitkeep = "screen"
    end,
    config = function(_, opts)
      local Layout = require("edgy.layout")

      -- Preserve the MAIN editor window's view across edgy relayouts.
      --
      -- edgy runs a full Layout.update on BufWinEnter/WinClosed (see edgy/config.lua
      -- and edgy/window.lua). Its save/restore cycle (edgy/state.lua) only restores
      -- the scroll position of its OWN docked panels — `M.restore()` iterates
      -- `Editor.list_wins().edgy` and drops every other window's saved view. So when
      -- a relayout fires, the editing window is left wherever the resize scrolled it.
      --
      -- The trigger is usually a transient FLOAT opening/closing: noice rendering a
      -- message (e.g. the `:w` "...written" echo), an LSP hover/signature, completion
      -- docs, Mason — each fires BufWinEnter/WinClosed and trips a relayout, bouncing
      -- the cursor up a line. Rather than suppress every such message, we wrap
      -- Layout.update to snapshot the focused real-editor window's view and restore it
      -- after edgy is done. Must wrap BEFORE setup(): config.lua captures
      -- `callback = Layout.update` by value at setup time.
      local edgy_update = Layout.update
      Layout.update = function(...)
        local win = vim.api.nvim_get_current_win()
        local buf = vim.api.nvim_win_get_buf(win)
        -- only a real, focused file window — not floats, docks, neo-tree (nofile),
        -- the terminal, or Trouble panels (edgy already restores those itself)
        local guard = vim.api.nvim_win_get_config(win).relative == ""
          and vim.bo[buf].buftype == ""
          and not vim.w[win].trouble
        local view = guard and vim.api.nvim_win_call(win, vim.fn.winsaveview) or nil

        -- Same problem, but for the docked TERMINAL. edgy's state.restore() skips
        -- terminal buffers entirely ("never restore terminal buffers to prevent
        -- flickering", edgy/state.lua) — so a relayout fired while you navigate the
        -- MAIN buffer (noice/hover/completion floats trip Layout.update) resizes the
        -- terminal panel, scrolls it, and edgy never puts it back. The terminal is
        -- never the focused window during that nav, so the guard above can't catch
        -- it. Snapshot every docked terminal's view and restore once after the
        -- relayout completes. With animate disabled there's no intermediate resize to
        -- flicker against, so the single trailing restore is safe.
        local term_views = {}
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          local wbuf = vim.api.nvim_win_get_buf(w)
          if
            vim.bo[wbuf].buftype == "terminal"
            and vim.api.nvim_win_get_config(w).relative == ""
          then
            term_views[w] = vim.api.nvim_win_call(w, vim.fn.winsaveview)
          end
        end

        edgy_update(...)

        if view and vim.api.nvim_win_is_valid(win) then
          pcall(vim.api.nvim_win_call, win, function() vim.fn.winrestview(view) end)
        end
        for w, v in pairs(term_views) do
          if vim.api.nvim_win_is_valid(w) then
            pcall(vim.api.nvim_win_call, w, function() vim.fn.winrestview(v) end)
          end
        end
      end

      require("edgy").setup(opts)

      -- Make the bottom (and top) panels span the FULL window width, under the
      -- left/right side panels. edgy hardcodes its layout order as
      -- { bottom, top, left, right }, which positions the side bars LAST — so they
      -- claim the corners (full height) and the bottom panel only spans the middle.
      -- Both edgy layout passes route through edgy.layout.foreach, so we wrap it to
      -- always order the side bars FIRST; the bottom/top bars then get moved last
      -- (wincmd J/K) and take the corners, giving them full width.
      local sides_first = { left = 1, right = 2, top = 3, bottom = 4 }
      local orig_foreach = Layout.foreach
      Layout.foreach = function(positions, fn)
        local ordered = vim.deepcopy(positions)
        table.sort(ordered, function(a, b)
          return (sides_first[a] or 99) < (sides_first[b] or 99)
        end)
        return orig_foreach(ordered, fn)
      end
    end,
    opts = {
      animate = { enabled = false }, -- snap panels into place, no slide animation
      -- Layout edges. Bottom panels stack in array order (diagnostics above terminal).
      left = {
        {
          title = "Files",
          ft = "neo-tree",
          filter = function(buf)
            return vim.b[buf].neo_tree_source == "filesystem"
          end,
          size = { width = 35 },
        },
      },
      right = {
        {
          title = "Symbols",
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "symbols"
          end,
          size = { width = 40 },
        },
      },
      bottom = {
        {
          title = "Diagnostics",
          ft = "trouble",
          filter = function(_buf, win)
            return vim.w[win].trouble and vim.w[win].trouble.mode == "diagnostics"
          end,
          size = { height = 20 },
        },
        {
          title = "Terminal",
          ft = "toggleterm",
          filter = function(_buf, win)
            -- only the docked (non-floating) toggleterm belongs here
            return vim.api.nvim_win_get_config(win).relative == ""
          end,
          size = { height = 16 },
        },
      },
    },
  },
}

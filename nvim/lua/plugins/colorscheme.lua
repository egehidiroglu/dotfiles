-- cyberdream.nvim — explicitly cyberpunk colorscheme.
-- Vibrant magentas, eva-green, electric cyans. Matches the rest of the palette.
return {
  {
    "scottmckendry/cyberdream.nvim",
    lazy = false,
    priority = 1000,
    config = function()
      require("cyberdream").setup({
        transparent       = false,
        italic_comments   = true,
        hide_fillchars    = true,
        borderless_pickers = false,
        terminal_colors   = true,
        cache             = true,           -- compile colorscheme to bytecode
        theme = {
          variant = "default",              -- "default" | "light"
          highlights = {
            -- Override a few to push the magenta/eva-green harder
            Comment        = { fg = "#6a6a8a", italic = true },
            Function       = { fg = "#39ff14" },
            Keyword        = { fg = "#ff00ff", bold = true },
            String         = { fg = "#00ffff" },
            Number         = { fg = "#b026ff" },
            Constant       = { fg = "#b026ff" },
            Type           = { fg = "#ffea00" },
            Statement      = { fg = "#ff00ff" },
            CursorLine     = { bg = "#1a1a3a" },
            LineNr         = { fg = "#4a4a6a" },
            CursorLineNr   = { fg = "#39ff14", bold = true },
            Visual         = { bg = "#2a1a4a" },
            DiagnosticError = { fg = "#ff1744" },
            DiagnosticWarn  = { fg = "#ffea00" },
            DiagnosticInfo  = { fg = "#00ffff" },
            DiagnosticHint  = { fg = "#b026ff" },
          },
          colors = {
            -- The base cyberdream palette has these slots; we nudge a few.
            bg     = "#050510",
            fg     = "#e0e0ff",
            magenta= "#ff00ff",
            purple = "#b026ff",
            green  = "#39ff14",
            cyan   = "#00ffff",
            blue   = "#0099ff",
            yellow = "#ffea00",
            orange = "#ff6f00",
            red    = "#ff1744",
            pink   = "#ff1493",
          },
        },
      })
      vim.cmd.colorscheme("cyberdream")
    end,
  },
}

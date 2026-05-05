-- UI plugins: statusline, indent guides, which-key, dressing, notify.
return {
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      options = {
        theme = "cyberdream",
        component_separators = { left = "│", right = "│" },
        section_separators   = { left = "",  right = "" },
        globalstatus = true,
      },
      sections = {
        lualine_a = { { "mode", separator = { left = "" } } },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } },
        lualine_x = { "filetype" },
        lualine_y = { "progress" },
        lualine_z = { { "location", separator = { right = "" } } },
      },
    },
  },
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      indent = { char = "▏" },
      scope  = { enabled = true, show_start = false, show_end = false },
    },
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {},
  },
  { "stevearc/dressing.nvim", event = "VeryLazy", opts = {} },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        command_palette = true,
        long_message_to_split = true,
      },
    },
  },
}

-- File explorer (nvim-tree) + buffer management.
return {
  {
    "nvim-tree/nvim-tree.lua",
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Explorer" },
    },
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        view = { width = 32, side = "left" },
        renderer = {
          group_empty = true,
          indent_markers = { enable = true },
          icons = {
            git_placement = "after",
            glyphs = {
              folder = { arrow_closed = "", arrow_open = "" },
            },
          },
        },
        filters = { dotfiles = false, custom = { "^\\.git$", "^node_modules$" } },
        git = { enable = true, ignore = false },
        actions = { open_file = { quit_on_open = false } },
      })
    end,
  },
}

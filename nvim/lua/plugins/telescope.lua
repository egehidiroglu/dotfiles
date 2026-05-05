-- Telescope: fuzzy-find anything. Files, grep, buffers, git refs, LSP symbols.
return {
  {
    "nvim-telescope/telescope.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    },
    cmd = "Telescope",
    keys = {
      { "<leader>ff", function() require("telescope.builtin").find_files() end,  desc = "Files" },
      { "<leader>fg", function() require("telescope.builtin").live_grep() end,   desc = "Grep" },
      { "<leader>fb", function() require("telescope.builtin").buffers() end,     desc = "Buffers" },
      { "<leader>fh", function() require("telescope.builtin").help_tags() end,   desc = "Help" },
      { "<leader>fr", function() require("telescope.builtin").oldfiles() end,    desc = "Recent" },
      { "<leader>fc", function() require("telescope.builtin").commands() end,    desc = "Commands" },
      { "<leader>fk", function() require("telescope.builtin").keymaps() end,     desc = "Keymaps" },
      { "<leader>fd", function() require("telescope.builtin").diagnostics() end, desc = "Diagnostics" },
      { "<leader>gs", function() require("telescope.builtin").git_status() end,  desc = "Git status" },
      { "<leader>gb", function() require("telescope.builtin").git_branches() end, desc = "Git branches" },
    },
    config = function()
      local actions = require("telescope.actions")
      require("telescope").setup({
        defaults = {
          prompt_prefix = "  ",
          selection_caret = " ",
          path_display = { "smart" },
          mappings = {
            i = {
              ["<C-j>"] = actions.move_selection_next,
              ["<C-k>"] = actions.move_selection_previous,
              ["<Esc>"] = actions.close,
            },
          },
          sorting_strategy = "ascending",
          layout_config = { prompt_position = "top" },
          file_ignore_patterns = { "node_modules", ".git/", "target/", "dist/", "build/" },
        },
        extensions = { fzf = {} },
      })
      pcall(require("telescope").load_extension, "fzf")
    end,
  },
}

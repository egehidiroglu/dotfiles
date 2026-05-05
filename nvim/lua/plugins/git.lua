-- Git integration: gitsigns gutter, fugitive for hard tasks, lazygit launcher.
return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
        untracked    = { text = "▎" },
      },
      on_attach = function(buf)
        local gs = require("gitsigns")
        local k = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = buf, desc = desc })
        end
        k("]h", function() gs.next_hunk() end,    "Next hunk")
        k("[h", function() gs.prev_hunk() end,    "Prev hunk")
        k("<leader>gp", function() gs.preview_hunk() end, "Preview hunk")
        k("<leader>gr", function() gs.reset_hunk() end,   "Reset hunk")
        k("<leader>gB", function() gs.blame_line({ full = true }) end, "Blame line")
      end,
    },
  },
  {
    "kdheepak/lazygit.nvim",
    cmd = { "LazyGit", "LazyGitConfig", "LazyGitCurrentFile" },
    keys = { { "<leader>gg", "<cmd>LazyGit<CR>", desc = "LazyGit" } },
    dependencies = { "nvim-lua/plenary.nvim" },
  },
}

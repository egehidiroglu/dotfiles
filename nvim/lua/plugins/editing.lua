-- Editing helpers: autopairs, comment toggling, surround, conform (formatter).
return {
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },

  {
    "numToStr/Comment.nvim",
    keys = {
      { "gc", mode = { "n", "v" }, desc = "Comment" },
      { "gb", mode = { "n", "v" }, desc = "Block comment" },
    },
    opts = {},
  },

  { "kylechui/nvim-surround", event = "VeryLazy", version = "*", opts = {} },

  {
    "stevearc/conform.nvim",
    event = "BufWritePre",
    cmd = "ConformInfo",
    keys = {
      { "<leader>cf", function() require("conform").format({ async = true, lsp_fallback = true }) end, desc = "Format" },
    },
    opts = {
      formatters_by_ft = {
        lua        = { "stylua" },
        python     = { "ruff_format" },
        rust       = { "rustfmt" },
        go         = { "gofmt" },
        javascript = { "prettierd", "prettier", stop_after_first = true },
        typescript = { "prettierd", "prettier", stop_after_first = true },
        javascriptreact = { "prettierd", "prettier", stop_after_first = true },
        typescriptreact = { "prettierd", "prettier", stop_after_first = true },
        json   = { "prettierd", "prettier", stop_after_first = true },
        yaml   = { "prettierd", "prettier", stop_after_first = true },
        html   = { "prettierd", "prettier", stop_after_first = true },
        css    = { "prettierd", "prettier", stop_after_first = true },
        markdown = { "prettierd", "prettier", stop_after_first = true },
      },
      format_on_save = { timeout_ms = 500, lsp_fallback = true },
    },
  },

  -- Lightning-fast file motions ('s' to jump anywhere on screen)
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "x", "o" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
    },
  },
}

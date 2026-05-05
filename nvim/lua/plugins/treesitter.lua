-- Treesitter: real syntax-aware highlighting + folds + indents.
return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",        -- pin: 'main' branch is a v1.0 API rewrite that breaks this config
    build = ":TSUpdate",
    event = { "BufReadPost", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "bash", "c", "cpp", "css", "go", "html", "javascript", "json",
          "lua", "markdown", "markdown_inline", "python", "regex", "rust",
          "swift", "toml", "tsx", "typescript", "vim", "vimdoc", "yaml",
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<C-Space>",
            node_incremental = "<C-Space>",
            node_decremental = "<bs>",
            scope_incremental = false,
          },
        },
      })
    end,
  },
}

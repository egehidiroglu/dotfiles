-- LSP via Mason. Mason loads eagerly so `ensure_installed` fires even in headless mode.
return {
  -- Mason itself: eager-load so it's ready for ensure_installed
  { "williamboman/mason.nvim", priority = 100, build = ":MasonUpdate", opts = {} },

  -- mason-lspconfig: also eager. Its setup() is what triggers the auto-install.
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
    opts = {
      ensure_installed = {
        "ts_ls",          -- TypeScript / JavaScript
        "pyright",        -- Python
        "rust_analyzer",  -- Rust
        "gopls",          -- Go
        "lua_ls",         -- Lua
        "bashls",         -- Bash
        "jsonls",         -- JSON
        "yamlls",         -- YAML
        "html",
        "cssls",
        "tailwindcss",
        "marksman",       -- Markdown
      },
    },
  },

  -- nvim-lspconfig: stays lazy, only wires up servers when a buffer opens.
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      local lspconfig    = require("lspconfig")
      local capabilities = require("cmp_nvim_lsp").default_capabilities()

      -- Buffer-local keymaps. Only set when LSP attaches, so they're contextual.
      local on_attach = function(_, bufnr)
        local k = function(lhs, rhs, desc)
          vim.keymap.set("n", lhs, rhs, { buffer = bufnr, desc = desc })
        end
        k("gd",         vim.lsp.buf.definition,      "Go to definition")
        k("gD",         vim.lsp.buf.declaration,     "Go to declaration")
        k("gr",         vim.lsp.buf.references,      "References")
        k("gi",         vim.lsp.buf.implementation,  "Implementations")
        k("K",          vim.lsp.buf.hover,           "Hover")
        k("<leader>rn", vim.lsp.buf.rename,          "Rename")
        k("<leader>ca", vim.lsp.buf.code_action,     "Code action")
        k("<leader>cf", function() vim.lsp.buf.format({ async = true }) end, "Format")
        k("[d",         vim.diagnostic.goto_prev,    "Prev diagnostic")
        k("]d",         vim.diagnostic.goto_next,    "Next diagnostic")
      end

      -- Apply on_attach + capabilities to every server Mason has installed.
      local installed = require("mason-lspconfig").get_installed_servers()
      for _, server in ipairs(installed) do
        lspconfig[server].setup({
          on_attach = on_attach,
          capabilities = capabilities,
        })
      end

      -- Diagnostic UI tweaks
      vim.diagnostic.config({
        virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
        float = { border = "rounded" },
      })
    end,
  },
}

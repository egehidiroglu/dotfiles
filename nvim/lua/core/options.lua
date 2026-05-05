-- Editor options. Sensible defaults; opinionated tweaks.

local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true       -- relative line numbers (great for j/k jumps)
opt.cursorline = true
opt.signcolumn = "yes"          -- always show, prevents jitter when LSP/diagnostics show up
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.termguicolors = true
opt.showmode = false            -- lualine handles this
opt.laststatus = 3              -- single global statusline
opt.cmdheight = 1
opt.pumheight = 12              -- popup menu max height

-- Indentation (per-language overrides via filetype)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.smartindent = true
opt.autoindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Files
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- UX
opt.mouse = "a"
opt.clipboard = "unnamedplus"   -- system clipboard everywhere
opt.splitbelow = true
opt.splitright = true
opt.wrap = false
opt.linebreak = true            -- if wrap is on, break at words
opt.timeoutlen = 400            -- which-key shows up faster
opt.updatetime = 250            -- swap/CursorHold latency

-- Completion
opt.completeopt = { "menu", "menuone", "noselect" }

-- Folds (treesitter-driven)
opt.foldmethod = "expr"
opt.foldexpr = "nvim_treesitter#foldexpr()"
opt.foldenable = false          -- start unfolded

-- File-type tab-width overrides
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "go", "make" },
  callback = function() opt.expandtab = false; opt.shiftwidth = 4; opt.tabstop = 4 end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "python", "rust", "java", "swift" },
  callback = function() opt.shiftwidth = 4; opt.tabstop = 4 end,
})

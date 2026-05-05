-- Custom keymaps. Plugin-specific keymaps live alongside their plugin spec.

local map = vim.keymap.set

-- Quality of life
map("n", "<Esc>",      "<cmd>nohlsearch<CR>",         { desc = "Clear search highlight" })
map("n", "<leader>w",  "<cmd>w<CR>",                  { desc = "Save" })
map("n", "<leader>q",  "<cmd>qa<CR>",                 { desc = "Quit all" })
map("n", "<leader>x",  "<cmd>bd<CR>",                 { desc = "Close buffer" })

-- Window navigation (vim-style)
map("n", "<C-h>", "<C-w>h", { desc = "Window left" })
map("n", "<C-j>", "<C-w>j", { desc = "Window down" })
map("n", "<C-k>", "<C-w>k", { desc = "Window up" })
map("n", "<C-l>", "<C-w>l", { desc = "Window right" })

-- Resize windows
map("n", "<C-Up>",    "<cmd>resize +2<CR>",          { desc = "Window taller" })
map("n", "<C-Down>",  "<cmd>resize -2<CR>",          { desc = "Window shorter" })
map("n", "<C-Left>",  "<cmd>vertical resize -2<CR>", { desc = "Window narrower" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Window wider" })

-- Better up/down on wrapped lines
map({ "n", "v" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "v" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Stay in indent mode after >> / <<
map("v", "<", "<gv", { desc = "Indent left, stay" })
map("v", ">", ">gv", { desc = "Indent right, stay" })

-- Move selected lines up/down
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Buffer navigation
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Prev buffer" })
map("n", "<S-l>", "<cmd>bnext<CR>",     { desc = "Next buffer" })

-- Don't yank on paste-over
map("v", "p", '"_dP', { desc = "Paste, keep clipboard" })

-- Yank to system clipboard (already default with unnamedplus, but explicit alias)
map({ "n", "v" }, "<leader>y", '"+y', { desc = "Yank to system clipboard" })

-- Centered scroll
map("n", "<C-d>", "<C-d>zz", { desc = "Half-page down, centered" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half-page up, centered" })
map("n", "n",     "nzzzv",   { desc = "Next match, centered" })
map("n", "N",     "Nzzzv",   { desc = "Prev match, centered" })

-- Highlight on yank
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function() vim.highlight.on_yank({ timeout = 200 }) end,
})

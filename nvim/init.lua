-- ~/.config/nvim/init.lua
-- Lean, opinionated Neovim config. lazy.nvim for plugins, cyberdream for vibes.

-- Leader: space (must be set before lazy)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("core.options")
require("core.keymaps")
require("core.lazy")

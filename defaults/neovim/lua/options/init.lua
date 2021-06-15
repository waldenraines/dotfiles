require('options.spellfile')

local opt = vim.opt

opt.autochdir = true
opt.clipboard = 'unnamedplus'
opt.colorcolumn = '80'
opt.completeopt = 'menuone,noinsert'
opt.expandtab = true
opt.fillchars = 'fold: '
opt.linebreak = false
opt.list = true
opt.listchars = 'eol:¬,tab:⇥ ,space:·'
opt.hidden = true
opt.ignorecase = true
opt.iskeyword = '@,48-57,192-255'
opt.mouse = 'nv'
opt.number = true
opt.relativenumber = true
opt.scrolloff = 1
opt.shiftwidth = 2
opt.showbreak = '↪ '
opt.smartcase = true
opt.splitright = true
opt.splitbelow = true
opt.swapfile = false
opt.tabstop = 2
opt.termguicolors = true
opt.textwidth = 79
opt.undofile = true
opt.wrap = false


local opt = vim.opt
-- general options
opt.termguicolors = true -- colors
opt.number = true -- show line numbers
opt.relativenumber = true
opt.showmatch = true -- show matching brackets
opt.cursorline = true -- highlight current lint
opt.wrap = false -- don't wrap lines
opt.mouse = "a" -- full mouse support
opt.splitright = true -- creat vertical splits on the right
opt.switchbuf = opt.switchbuf + "usetab" -- open quickfix list elements in existing tabs
vim.g.tex_conceal = "" -- don't conceal chars in latex
opt.spelllang = "en_us,de_de"
opt.spell = false -- disable spelling by default
vim.g.netrw_liststyle = 3 -- use tree style
vim.g.netrw_fastbrowse = 0 -- don't reuse buffers

opt.colorcolumn = "100" -- show column at textwidth
opt.textwidth = 100
opt.signcolumn = "yes" -- fixed width for signcolumn

-- completion
opt.updatetime = 200 -- update time for cursoshold
opt.shortmess = opt.shortmess + "c" -- Avoid showing extra messages when using completion
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force user to select one from the menu
opt.completeopt = "menuone,noinsert,noselect"
opt.complete = ".,w,b,u,t,i,kspell"

-- search
opt.incsearch = true -- incremental search
opt.hlsearch = true -- highlight search
opt.ignorecase = true -- case-insensitive
opt.smartcase = true -- unlsess it contains a capital character

-- tabs vs spaces
opt.list = true -- show tabs and whitespaces
opt.listchars = "trail:␣,extends:↲,precedes:↳,nbsp:·,lead:·,conceal:·,tab:» "
opt.tabstop = 4 -- 4 spaces are one tab
opt.shiftwidth = 0 -- use tabstop for auto-indentation
opt.softtabstop= -1 -- use shiftwidth
opt.expandtab = true -- use spaces instead of tabs
opt.backspace = "indent,eol,start" -- always use backspace

-- use ripgrep
opt.grepprg = "rg --vimgrep --no-heading"
opt.grepformat = "%f:%l%c:%m"

-- commands and stuff
local cmd = vim.cmd
cmd [[ highlight CursorLine term=bold cterm=bold gui=bold ]]
cmd [[ syntax enable ]]
cmd [[ filetype plugin indent on ]]

-- UI borders
vim.o.winborder = "rounded"

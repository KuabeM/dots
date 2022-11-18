
syntax enable
filetype plugin indent on

" Load lua modules
lua <<EOF
-- load plugins with packer
require('plugins')
-- Misc options
require('options')
-- LSP
require('lsp-config')
-- Telescope
require('telescope-config')
-- Plugin Comment.nvim
require('Comment').setup{}
-- Misc keymaps
require('keymaps')
-- Configure neorg
require('neorg-nvim')

EOF

set spell spelllang=en_us   " Spell checking
set nospell

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Set type of completion and places to scan
set complete=.,w,b,u,t,i,kspell
set updatetime=800          " Set updatetime for CursorHold

set shortmess+=c            " Avoid showing extra messages when using completion

set termguicolors           " show colors
set number                  " show line numbers
set relativenumber
set showmatch               " show matching brackets.
set cursorline              " Highlight current line
set nowrap                  " Do not wrap lines

set incsearch               " Incremental search
set hlsearch                " Highlight search words
set ignorecase              " Search is case-insensitive ...
set smartcase               " ... unless it contains a capital letter

set mouse=a                 " full mouse support

set colorcolumn=100         " Show colorcolumn at 100
set textwidth=100           " auto-wrap text

set list                    " show tabs and whitespace
set listchars=tab:»\ ,trail:␣,extends:↲,precedes:↳,nbsp:·,lead:·,conceal:·

set splitright              " Create vertical splits on the right

set tabstop=4               " 2 spaces equal one tab
set shiftwidth=0            " Use tabstop for auto-indentation
set softtabstop=-1          " Use shiftwidth
set expandtab               " Use spaces instead of tabs
set backspace=indent,eol,start " Backspacing over everything

set switchbuf+=usetab ",newtab " quickfix list: open in newtab or reuse already open tab

let g:tex_conceal = ""      " dont conceal chars in latex

" have a fixed column for the diagnostics to appear in
" this removes the jitter when warnings/errors flow in
set signcolumn=yes

highlight CursorLine term=bold cterm=bold gui=bold

" Configure Git blame
let g:gitblame_enabled = 0
let g:gitblame_message_template = '		<summary> • <date> • <author> • <sha> '

if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading " use ripgrep
  set grepformat=%f:%l:%c:%m
endif

" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })

" Enable type inlay hints
"autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
" \ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" vim-maximizer
nnoremap <silent><C-f> :MaximizerToggle<CR>
vnoremap <silent><C-f> :MaximizerToggle<CR>gv
inoremap <silent><C-f> <C-o>:MaximizerToggle<CR>

" move through tabs with H L
nnoremap H gT
nnoremap L gt
nnoremap m :bn<CR>
nnoremap M :bp<CR>

" completion in pattern
"cnoremap <tab> <C-r><C-w>

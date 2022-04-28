" plugins
call plug#begin('~/.vim/plugged')

  Plug 'neovim/nvim-lspconfig'                  " Common configurations for the Nvim LSP client
  Plug 'nvim-lua/lsp_extensions.nvim'           " Extensions to built-in LSP

  Plug 'hrsh7th/nvim-cmp'                       " Autocompletion framework
  Plug 'hrsh7th/cmp-nvim-lsp'                   " cmd LSP completion
  Plug 'hrsh7th/cmp-path'                       " cmd Path completion
  Plug 'hrsh7th/cmp-buffer'                     " cmd Buffer completion
  " See hrsh7th other plugins for more great completion sources!
  Plug 'hrsh7th/cmp-vsnip'                      " cmd Snippet completion
  Plug 'hrsh7th/vim-vsnip'                      " Snippet engine

  Plug 'folke/tokyonight.nvim', { 'branch': 'main' }
  Plug 'rafamadriz/neon'
  Plug 'marko-cerovac/material.nvim'            " Material color theme

  Plug 'airblade/vim-gitgutter'                 " show git changes in gutter
  Plug 'jiangmiao/auto-pairs'                   " auto-close brackets, quotes etc
  Plug 'vim-airline/vim-airline'                " powerline-like statusbar/tabline
  Plug 'kien/rainbow_parentheses.vim'           " colorize parentheses
  Plug 'l04m33/vlime'                           " Lisp

  Plug 'wellle/targets.vim'                     " Give more target to operate on
  Plug 'kopischke/vim-fetch'                    " Handle line numbers when opening files
  Plug 'scrooloose/nerdcommenter'               " Comment lines or selections

  Plug 'nvim-lua/plenary.nvim'
  Plug 'nvim-telescope/telescope.nvim'          " Fuzzy finder for everything

  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'} " Syntax highlighting

  Plug 'chaoren/vim-wordmotion'                 " move through words in all kinds of styles
  Plug 'szw/vim-maximizer'                      " Maximize a split window
call plug#end()

" change the leader key from "\" to ";"
let mapleader=";"

syntax enable
filetype plugin indent on

let g:material_style = "oceanic"
colorscheme material

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

" Configure Git Gutter
highlight link GitGutterAdd DiffAdd
highlight link GitGutterChange DiffAdd
highlight link GitGutterDelete DiffAdd
highlight link GitGutterChangeDeleteLine DiffAdd


if executable('rg')
  set grepprg=rg\ --vimgrep\ --no-heading " use ripgrep
  set grepformat=%f:%l:%c:%m
endif

" Configure lsp
lua <<EOF

require('lsp-config')

EOF

" -------------------------
" Code navigation shortcuts
" -------------------------
" as found in :help lsp
nnoremap <silent> <F12> <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> <leader><F12> :tab split<CR><cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <F4>  <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <leader><F4>   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gh    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <F11>  <cmd>lua vim.lsp.buf.code_action()<CR>
" rust-analyzer does not yet support goto declaration
" re-mapped `gd` to definition
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.diagnostic.goto_next()<CR>

" Show diagnostic popup on cursor hover
autocmd cursorhold *.cpp lua vim.diagnostic.open_float()
autocmd CursorHold *.rs lua vim.diagnostic.open_float()
autocmd CursorHold *.c lua vim.diagnostic.open_float()
autocmd CursorHold *.h lua vim.diagnostic.open_float()
autocmd CursorHold *.hpp lua vim.diagnostic.open_float()

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
 \ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" Telescope finder for everything: https://github.com/nvim-telescope/telescope.nvim
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>sg <cmd>lua require('telescope.builtin').grep_string()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>
nnoremap <leader>fq <cmd>lua require('telescope.builtin').quickfix()<cr>
nnoremap <leader>fr <cmd>lua require('telescope.builtin').registers()<cr>
nnoremap <leader>fs <cmd>lua require('telescope.builtin').spell_suggest()<cr>

nnoremap <leader>lr <cmd>lua require('telescope.builtin').lsp_references()<cr>
nnoremap <leader>la <cmd>lua require('telescope.builtin').lsp_code_actions()<cr>
nnoremap <leader>ld <cmd>lua require('telescope.builtin').lsp_type_definitions()<cr>

nnoremap <leader>gst <cmd>lua require('telescope.builtin').git_status()<cr>
nnoremap <leader>gb <cmd>lua require('telescope.builtin').git_branches()<cr>
nnoremap <leader>gsta <cmd>lua require('telescope.builtin').git_stash()<cr>

" vim-maximizer
nnoremap <silent><C-f> :MaximizerToggle<CR>
vnoremap <silent><C-f> :MaximizerToggle<CR>gv
inoremap <silent><C-f> <C-o>:MaximizerToggle<CR>

" vim-airline
" if theres only one tab display buffers
let g:airline#extensions#tabline#enabled = 1
" get the godd symbols
let g:airline_powerline_fonts = 1
" separators for tabline
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

" move through tabs with H L
nnoremap H gT
nnoremap L gt
nnoremap m :bn<CR>
nnoremap M :bp<CR>

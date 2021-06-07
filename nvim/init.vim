" plugins
call plug#begin('~/.vim/plugged')

  Plug 'neovim/nvim-lspconfig'                  " Common configurations for the Nvim LSP client
  Plug 'nvim-lua/lsp_extensions.nvim'           " Extentions to built-in LSP
  Plug 'nvim-lua/completion-nvim'               " Autocompletion framework for built-in LSP

  Plug 'ctrlpvim/ctrlp.vim'                     " Fuzzy finder
  Plug 'kaicataldo/material.vim', { 'branch': 'main' }  " color theme
  Plug 'airblade/vim-gitgutter'                 " show git changes in gutter
  Plug 'jiangmiao/auto-pairs'                   " auto-close brackets, quotes etc
  Plug 'vim-airline/vim-airline'                " powerline-like statusbar/tabline
  Plug 'kien/rainbow_parentheses.vim'           " colorize parentheses
  Plug 'l04m33/vlime'                           " Lisp

  Plug 'junegunn/fzf'                           " Fuzzy finder with fzf
  Plug 'junegunn/fzf.vim'                       " Fzf integration
  Plug 'wellle/targets.vim'                     " Give more target to operate on
  Plug 'kopischke/vim-fetch'                    " Handle line numbers when opening files
  Plug 'scrooloose/nerdcommenter'               " Comment lines or selections
call plug#end()

" Set leader key to space
nnoremap <SPACE> <Nop>
let mapleader=" "

syntax enable
filetype plugin indent on

colorscheme material

set spelllang=en_us,de      " Spell checking

" Set completeopt to have a better completion experience
set completeopt=menuone,noinsert,noselect,preview
set complete=.,w,b,u,t,i,kspell
set updatetime=300          " Set updatetime for CursorHold

" Avoid showing extra messages when using completion
set shortmess+=c

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

set tabstop=2               " 2 spaces equal one tab
set shiftwidth=0            " Use tabstop for auto-indentation
set softtabstop=-1          " Use shiftwidth
set expandtab               " Use spaces instead of tabs
set backspace=indent,eol,start " Backspacing over everything

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
" https://github.com/neovim/nvim-lspconfig#rust_analyzer
lua <<EOF

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#dockerls for a list of LSPs
-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    capabilities=capabilities,
    on_attach=on_attach
})
-- Enable clangd
nvim_lsp.clangd.setup({
    capabilities=capabilities,
    on_attach=on_attach
})
-- Enable cmake: pip install cmake-language-server
nvim_lsp.cmake.setup({
    capabilities=capabilities,
    on_attach=on_attach
})
-- Enable docker: npm install -g dockerfile-language-server-nodejs
nvim_lsp.dockerls.setup({
    capabilities=capabilities,
    on_attach=on_attach
})

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

-- autoformatting on save
vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
EOF

" -------------------------
" Code navigation shortcuts
" -------------------------
" as found in :help lsp
nnoremap <F12> :tab split<CR><cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> <c-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
" nnoremap <silent> 1gD   <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> g0    <cmd>lua vim.lsp.buf.document_symbol()<CR>
nnoremap <silent> gW    <cmd>lua vim.lsp.buf.workspace_symbol()<CR>
nnoremap <silent> gf    <cmd>lua vim.lsp.buf.formatting()<CR>
nnoremap <silent> <F2>  <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> gT    <cmd>lua vim.lsp.buf.type_definition()<CR>
nnoremap <silent> <F11>  <cmd>lua vim.lsp.buf.code_action()<CR>
" rust-analyzer does not yet support goto declaration
" re-mapped `gd` to definition
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.declaration()<CR>

" Goto previous/next diagnostic warning/error
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

" Trigger completion with <tab>
" found in :help completion
" Use <Tab> and <S-Tab> to navigate through popup menu
"inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" use <Tab> as trigger keys
imap <Tab> <Plug>(completion_smart_tab)
imap <S-Tab> <Plug>(completion_smart_s_tab)

" Show diagnostic popup on cursor hover
autocmd CursorHold * lua vim.lsp.diagnostic.show_line_diagnostics()


" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
\ lua require'lsp_extensions'.inlay_hints{
\    prefix = ' > ',
\    highlight = "Comment",
\    enabled = {
\      "TypeHint",
\      "ChainingHint",
\      "ParameterHint"
\    }
\}

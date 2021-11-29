" plugins
call plug#begin('~/.vim/plugged')

  Plug 'neovim/nvim-lspconfig'                  " Common configurations for the Nvim LSP client
  Plug 'nvim-lua/lsp_extensions.nvim'           " Extentions to built-in LSP

  Plug 'hrsh7th/nvim-cmp'                       " Autocompletion framework
  Plug 'hrsh7th/cmp-nvim-lsp'                   " cmd LSP completion
  Plug 'hrsh7th/cmp-path'                       " cmd Path completion
  Plug 'hrsh7th/cmp-buffer'                     " cmd Buffer completion
  " See hrsh7th other plugins for more great completion sources!
  Plug 'hrsh7th/cmp-vsnip'                      " cmd Snippet completion
  Plug 'hrsh7th/vim-vsnip'                      " Snippet engine

  Plug 'kaicataldo/material.vim', { 'branch': 'main' }  " color theme
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
call plug#end()

" Set leader key to space
nnoremap <SPACE> <Nop>
let mapleader=" "

syntax enable
filetype plugin indent on

colorscheme material

set spelllang=en_us,de      " Spell checking

" Set completeopt to have a better completion experience
" :help completeopt
" menuone: popup even when there's only one match
" noinsert: Do not insert text until a selection is made
" noselect: Do not select, force user to select one from the menu
set completeopt=menuone,noinsert,noselect

" Set type of completion and places to scan
set complete=.,w,b,u,t,i,kspell
set updatetime=300          " Set updatetime for CursorHold

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

set switchbuf+=usetab,newtab " quickfix list: open in newtab or reuse already open tab

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

-- Debug log
-- vim.lsp.set_log_level('Debug')

-- nvim_lsp object
local nvim_lsp = require'lspconfig'

-- function to attach completion when setting up lsp
local on_attach = function(client)
    require'completion'.on_attach(client)
end

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- Add tab support
    ['<S-Tab>'] = cmp.mapping.select_prev_item( { behavior = cmp.SelectBehavior.Insert } ),
    ['<Tab>'] = cmp.mapping.select_next_item( { behavior = cmp.SelectBehavior.Insert } ),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping.complete(cmp.mapping.complete(), { 'i' , 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  -- Installed sources
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  }),

  -- use buffer source for '/'
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
      }
    })

  -- Use cmdline & path source for ':'.
  --cmp.setup.cmdline(':', {
  --  sources = cmp.config.sources({
  --    { name = 'path' }
  --  }, {
  --    { name = 'cmdline' }
  --  })
  --})
})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

-- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md for a list of LSPs

-- Enable rust_analyzer
nvim_lsp.rust_analyzer.setup({
    capabilities=capabilities,
    settings = {
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy diagnostics on save
        checkOnSave = {
          command = "clippy"
        },
      }
    }
})

-- Enable clangd
nvim_lsp.clangd.setup({
    capabilities=capabilities,
})

-- Enable json ls
nvim_lsp.jsonls.setup({
 commands = {
      Format = {
        function()
          vim.lsp.buf.range_formatting({},{0,0},{vim.fn.line("$"),0})
        end
      }
    }
})
-- Enable cmake: pip install cmake-language-server
nvim_lsp.cmake.setup({
    -- capabilities=capabilities,
    -- on_attach=on_attach
})

-- Enable docker: npm install -g dockerfile-language-server-nodejs
nvim_lsp.dockerls.setup{}

-- Groovy language server: https://github.com/GroovyLanguageServer/groovy-language-server
nvim_lsp.groovyls.setup{
    cmd = { "java", "-jar", "/home/korbinian/.local/bin/groovy-language-server-all.jar" },
}

-- https://github.com/latex-lsp/texlab
nvim_lsp.texlab.setup{
  settings = { texlab = { build = {
    executable = "tectonic",
      args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" }
  }}}
}

-- npm install -g vim-language-server
nvim_lsp.vimls.setup{}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
  vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
  }
)

-- autoformatting on save
--vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]
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
nnoremap <silent> g[ <cmd>lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <silent> g] <cmd>lua vim.lsp.diagnostic.goto_next()<CR>

lua <<EOF
local cmp = require'cmp'
cmp.setup({
  snippet = {
    expand = function(args)
        vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    -- ['<C-p>'] = cmp.mapping.select_prev_item(),
    -- ['<C-n>'] = cmp.mapping.select_next_item(),
    -- Add tab support
    -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
    -- ['<Tab>'] = cmp.mapping.select_next_item(),
    ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
    ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
    ['<C-Space>'] = cmp.mapping.complete(cmp.mapping.complete(), { 'i' , 'c' }),
    ['<C-e>'] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
  },

  -- Installed sources
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'vsnip' },
    { name = 'path' },
    { name = 'buffer' },
  }),
  
  -- use buffer source for '/'
  cmp.setup.cmdline('/', {
    sources = {
      { name = 'buffer' }
      }
    })
})
EOF

" Show diagnostic popup on cursor hover
autocmd CursorHold *.cpp lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold *.rs lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold *.c lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold *.h lua vim.lsp.diagnostic.show_line_diagnostics()
autocmd CursorHold *.hpp lua vim.lsp.diagnostic.show_line_diagnostics()

" Enable type inlay hints
autocmd CursorMoved,InsertLeave,BufEnter,BufWinEnter,TabEnter,BufWritePost *.rs
\ lua require'lsp_extensions'.inlay_hints{ prefix = '', highlight = "Comment", enabled = {"TypeHint", "ChainingHint", "ParameterHint"} }

" Telescope finder for everything: https://github.com/nvim-telescope/telescope.nvim
nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

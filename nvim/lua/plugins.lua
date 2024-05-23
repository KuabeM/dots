local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = ";"

require("lazy").setup({
    ui = {
        -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
        border = "rounded",
    },
    {
        'neovim/nvim-lspconfig', -- Configurations for Nvim LSP
        -- opts = {
        --     inlay_hints = { enabled = true },
        -- },
    },
    -- 'simrat39/rust-tools.nvim',            -- rust lsp tooling
    {
        'mrcjkb/rustaceanvim',
        version = '^4',
        ft = { 'rust' },
    },
    {
        'nvim-treesitter/nvim-treesitter', -- syntax highlighting
        build = ':TSUpdate'
    },
    { 'hrsh7th/nvim-cmp' },
    { 'hrsh7th/cmp-nvim-lsp' },
    { 'hrsh7th/cmp-path' },
    { 'hrsh7th/cmp-buffer' },
    { 'hrsh7th/cmp-vsnip' },
    { 'hrsh7th/vim-vsnip' },
    { 'ray-x/cmp-treesitter' },
    { 'mfussenegger/nvim-dap' }, -- Debug Adapter Protocol

    { 'marko-cerovac/material.nvim' },

    { 'nvim-lualine/lualine.nvim' },
    { 'kdheepak/tabline.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'lewis6991/gitsigns.nvim' }, -- git decorations
    {
        'f-person/git-blame.nvim', -- show git blame messages
        init = function()
            vim.g.gitblame_message_template = '	<summary> • <date> • <author> • <sha>'
            vim.g.gitblame_enabled = 1
            vim.g.gitblame_virtual_text_column = 120
            vim.g.gitblame_delay = 1000
            vim.g.gitblame_highlight_group = "CursorLine"
        end,
    },
    { 'jiangmiao/auto-pairs' },         -- auto-close brackets, quotes etc
    { 'kien/rainbow_parentheses.vim' }, -- colorize parentheses

    { 'wellle/targets.vim' },           -- Give more target to operate on
    { 'kopischke/vim-fetch' },          -- Handle line numbers when opening files

    { 'nvim-lua/plenary.nvim' },

    {
        'nvim-telescope/telescope.nvim',
        dependencies = { { 'nvim-lua/plenary.nvim' } }
    },
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        build =
        'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    },

    { 'szw/vim-maximizer' }, -- Maximize a split window

    {
        "SmiteshP/nvim-navic",
        dependencies = "neovim/nvim-lspconfig"
    },

    { 'ThePrimeagen/vim-be-good' },
    {
        'folke/which-key.nvim',
        event = "VeryLazy",
        init = function()
            vim.o.timeout = true
            vim.o.timeoutlen = 300
        end,
        opts = {}
    },
    {
        'cameron-wags/rainbow_csv.nvim',
        config = true,
        ft = {
            'csv',
            'tsv',
            'csv_semicolon',
            'csv_whitespace',
            'csv_pipe',
            'rfc_csv',
            'rfc_semicolon'
        },
        cmd = {
            'RainbowDelim',
            'RainbowDelimSimple',
            'RainbowDelimQuoted',
            'RainbowMultiDelim'
        }
    },
    {
        "ellisonleao/carbon-now.nvim",
        lazy = true,
        cmd = "CarbonNow",
    },
    {
        "kylechui/nvim-surround",
        event = "VeryLazy",
    },
    -- {
    --     "folke/flash.nvim",
    --     event = "VeryLazy",
    -- }
})

--
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use 'neovim/nvim-lspconfig' -- Configurations for Nvim LSP
    use 'simrat39/rust-tools.nvim' -- rust lsp tooling
    use {
        'nvim-treesitter/nvim-treesitter', -- syntax highlighting
        run = ':TSUpdate'
    }
    use { 'hrsh7th/nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-path' }
    use { 'hrsh7th/cmp-buffer' }
    use { 'hrsh7th/cmp-vsnip' }
    use { 'hrsh7th/vim-vsnip' }
    use { 'ray-x/cmp-treesitter' }
    use { 'mfussenegger/nvim-dap' } -- Debug Adapter Protocol

    use { 'marko-cerovac/material.nvim' }

    use { 'nvim-lualine/lualine.nvim' }
    use { 'kdheepak/tabline.nvim' }
    use { 'kyazdani42/nvim-web-devicons' }
    use { 'lewis6991/gitsigns.nvim' } -- git decorations
    use { 'f-person/git-blame.nvim' } -- show git blame messages
    use { 'jiangmiao/auto-pairs' } -- auto-close brackets, quotes etc
    use { 'kien/rainbow_parentheses.vim' } -- colorize parentheses

    use { 'wellle/targets.vim' } -- Give more target to operate on
    use { 'kopischke/vim-fetch' } -- Handle line numbers when opening files

    use { 'numToStr/Comment.nvim' } -- Comments stuff

    use { 'nvim-lua/plenary.nvim' }
    use {
        'nvim-telescope/telescope.nvim',
        requires = { { 'nvim-lua/plenary.nvim' } }
    }
    use { 'nvim-telescope/telescope-fzf-native.nvim',
        run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
    }

    use { 'szw/vim-maximizer' } -- Maximize a split window

    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        requires = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope"
        }
    }

    use {
        "SmiteshP/nvim-navic",
        requires = "neovim/nvim-lspconfig"
    }
end)

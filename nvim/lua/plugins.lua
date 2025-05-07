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
    },
    {
        'mrcjkb/rustaceanvim',
        version = '^6',
        ft = { 'rust' },
    },
    {
        'nvim-treesitter/nvim-treesitter', -- syntax highlighting
        build = ':TSUpdate'
    },
    {
        'windwp/nvim-autopairs', -- auto-close brackets, quotes etc
        event = "InsertEnter",
        config = true,
    },
    {
        'saghen/blink.cmp',
        dependencies = 'rafamadriz/friendly-snippets',
        version = '*',

        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            keymap = {
                preset = 'enter',
                -- ['<Tab>'] = { 'select_next', 'fallback' },
                ['<Tab>'] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.snipet_forward()
                        else
                            return cmp.select_next()
                        end
                    end,
                    'select_next', 'fallback'
                },
                ['<S-Tab>'] = { 'select_prev', 'fallback' },
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = 'mono'
            },
            completion = {
                -- menu = { border = 'rounded' },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = { border = 'rounded' }
                },
                accept = {
                    auto_brackets = {
                        enabled = true,
                    }
                },
                -- ghost_text = { enabled = true, },
                list = {
                    selection = {
                        preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
                        auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
                    },
                    cycle = { from_top = true, from_bottom = true }
                }
            },
            signature = { enabled = true, window = { border = 'rounded' } },
            -- Default list of enabled providers defined so that you can extend it
            -- elsewhere in your config, without redefining it, due to `opts_extend`
            sources = {
                default = { 'lsp', 'path', 'snippets', 'buffer' },
            },
        },
        opts_extend = { "sources.default" }
    },

    { 'mfussenegger/nvim-dap' }, -- Debug Adapter Protocol

    { 'marko-cerovac/material.nvim' },
    {
        'uloco/bluloco.nvim',
        lazy = false,
        priority = 1000,
        dependencies = { 'rktjmp/lush.nvim' },
        -- config = function()
        --     style = "dark",
        -- end,
    },
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

    { 'nvim-lualine/lualine.nvim' },
    { 'nvim-tree/nvim-web-devicons' },
    { 'lewis6991/gitsigns.nvim' }, -- git decorations
    {
        'f-person/git-blame.nvim', -- show git blame messages
        init = function()
            vim.g.gitblame_message_template = '	<summary> • <date> • <author> • <sha>'
            vim.g.gitblame_enabled = 0
            vim.g.gitblame_virtual_text_column = 120
            vim.g.gitblame_delay = 1000
            vim.g.gitblame_highlight_group = "CursorLine"
        end,
    },
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
        "kylechui/nvim-surround",
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({})
        end
    },
    'mei28/qfc.nvim',
    {
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
            library = {
                -- See the configuration section for more details
                -- Load luvit types when the `vim.uv` word is found
                { path = "luvit-meta/library", words = { "vim%.uv" } },
            },
        },
    },
    { "Bilal2453/luvit-meta", lazy = true }, -- optional `vim.uv` typings
    {
        "chrisgrieser/nvim-early-retirement",
        config = true,
        event = "VeryLazy",
        opts = { minimumBufferNum = 6, }
    },
    -- {
    --     "chrisgrieser/nvim-lsp-endhints",
    --     event = "LspAttach",
    --     opts = {}, -- required, even if empty
    -- },
})

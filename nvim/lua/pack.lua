vim.g.mapleader = ";"

vim.pack.add({
    { src = 'https://github.com/neovim/nvim-lspconfig', }, -- Configurations for Nvim LSP
    { src = 'https://github.com/mrcjkb/rustaceanvim',   version = vim.version.range('9.*') },
    { src = 'https://github.com/catppuccin/nvim',       name = 'catppuccin' },
    {
        src = 'https://github.com/nvim-treesitter/nvim-treesitter',
    },
    { src = 'https://github.com/windwp/nvim-autopairs' }, -- check config with blink
    { src = 'https://github.com/rafamadriz/friendly-snippets' },
    {src = 'https://github.com/saghen/blink.lib' },
    {
        src = 'https://github.com/saghen/blink.cmp',
        version = 'main',
    },
    { src = 'https://github.com/nvim-tree/nvim-web-devicons' },
    { src = 'https://github.com/nvim-lualine/lualine.nvim' },
    { src = 'https://github.com/mei28/qfc.nvim' },
    { src = 'https://github.com/lewis6991/gitsigns.nvim' }, -- git decorations
    { src = 'https://github.com/nvim-lua/plenary.nvim' },
    { src = 'https://github.com/nvim-telescope/telescope.nvim' },
    {
        src = 'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
        build = function() vim.fn.system({ 'make' }) end
    },
    { src = "https://github.com/shortcuts/no-neck-pain.nvim", },
    { src = "https://github.com/chrisgrieser/nvim-early-retirement", },
    { src = 'https://github.com/folke/which-key.nvim' },
    { src = 'https://github.com/szw/vim-maximizer' }, -- Maximize a split window
    { src = 'https://github.com/SmiteshP/nvim-navic' },
    { src = 'https://github.com/f-person/git-blame.nvim', },
    { src = 'https://github.com/kopischke/vim-fetch' }, -- Handle line numbers when opening files
    { src = 'https://github.com/cameron-wags/rainbow_csv.nvim', },
    {
        src = "https://www.github.com/olimorris/codecompanion.nvim",
        version = vim.version.range("^19.0.0")
    }
})

-- require("lazy").setup({
--     ui = {
--         -- The border to use for the UI window. Accepts same border values as |nvim_open_win()|.
--         border = "rounded",
--     },
--     {
--         'mfussenegger/nvim-dap', -- Debug Adapter Protocol
--         keys = {
--             {
--                 "<leader>db",
--                 function() require("dap").toggle_breakpoint() end,
--                 desc = "Toggle Breakpoint"
--             },
--             {
--                 "<leader>dc",
--                 function() require("dap").continue() end,
--                 desc = "Continue"
--             },
--             {
--                 "<leader>di",
--                 function() require("dap").step_into() end,
--                 desc = "Continue"
--             },
--             {
--                 "<leader>dn",
--                 function() require("dap").step_over() end,
--                 desc = "Continue"
--             },
--             {
--                 "<leader>dC",
--                 function() require("dap").run_to_cursor() end,
--                 desc = "Run to Cursor"
--             },
--             {
--                 "<leader>dT",
--                 function() require("dap").terminate() end,
--                 desc = "Terminate"
--             },
--         },
--     },
--     {
--         "igorlfs/nvim-dap-view",
--         ---@module 'dap-view'
--         ---@type dapview.Config
--         opts = {},
--     },
--     { 'wellle/targets.vim' },           -- Give more target to operate on
--     {
--         "kylechui/nvim-surround",
--         event = "VeryLazy",
--         config = function()
--             require("nvim-surround").setup({})
--         end
--     },
-- })

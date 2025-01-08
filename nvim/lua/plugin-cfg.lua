-- colorschemes
require('material').setup({
    contrast = {
        terminal = false,            -- Enable contrast for the built-in terminal
        sidebars = false,            -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false,    -- Enable contrast for floating windows
        cursor_line = false,         -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {},              -- Specify which filetypes get the contrasted (darker) background
    },
    plugins = {
        "gitsigns",
        "nvim-cmp",
        "telescope",
        "nvim-web-devicons",
        "which-key",
    },
    lualine_style = 'default',
})
vim.g.material_style = "oceanic"
vim.cmd 'colorscheme material'

-- statusline with lualine
local navic = require('nvim-navic')
local custom_auto = require 'lualine.themes.auto'
custom_auto.inactive.c.bg = custom_auto.normal.c.bg
custom_auto.inactive.c.fg = custom_auto.normal.c.fg
require('lualine').setup {
    options = { theme = custom_auto },
    sections = {
        lualine_a = { 'mode' },
        lualine_b = { 'diff',
            { 'diagnostics', sources = { 'nvim_lsp', 'nvim_diagnostic' } },
            function()
                local space = vim.fn.search([[\s\+$]], 'nwc')
                return space ~= 0 and "trailing:" .. space or ""
            end },
        lualine_c = {
            { 'filename',         path = 1, },
            { navic.get_location, cond = navic.is_available }
        },
        lualine_x = { 'branch', 'filetype' }, -- default: 'encoding', 'fileformat'
        lualine_y = { 'searchcount' },        -- default: 'progress'
        lualine_z = { 'progress', 'location', 'filesize' }
    },
    inactive_sections = {
        lualine_c = { { 'filename', path = 1, } }
    }
}
require 'tabline'.setup {}

--  git signs
require('gitsigns').setup {
    current_line_blame = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
    current_line_blame_opts = {
        virt_text = true,
        virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
        delay = 1000,
        ignore_whitespace = false,
        virt_text_priority = 10,
    },
    current_line_blame_formatter = '	<summary> • <author_time> • <author>',
    signs = {
        add          = { text = '+' },
        change       = { text = '~' },
        delete       = { text = '_' },
        topdelete    = { text = '‾' },
        changedelete = { text = '~' },
    }
}

require('qfc').setup({
    timeout = 3000,
    autoclose = true,
})

-- require("lsp-endhints").setup {
--     icons = {
--         type = "",
--         parameter = "",
--     },
--     label = {
--         padding = 1,
--         marginLeft = 0,
--         bracketedParameters = true,
--     },
--     autoEnableHints = true,
-- }

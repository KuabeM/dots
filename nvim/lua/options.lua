-- change mapleader from "\" to ";"
vim.g.mapleader = ";"

-- colorschemes
require('material').setup({
    contrast = {
        terminal = false, -- Enable contrast for the built-in terminal
        sidebars = false, -- Enable contrast for sidebar-like windows ( for example Nvim-Tree )
        floating_windows = false, -- Enable contrast for floating windows
        cursor_line = false, -- Enable darker background for the cursor line
        non_current_windows = false, -- Enable darker background for non-current windows
        filetypes = {}, -- Specify which filetypes get the contrasted (darker) background
    },
    plugins = {
        "gitsigns",
        "nvim-cmp",
        "telescope",
    },
    lualine_style = 'default'
})
vim.g.material_style = "oceanic"
vim.cmd 'colorscheme material'

-- statusline with lualine
require('lualine').setup({
})
require'tabline'.setup { }

-- use tree style
vim.g.netrw_liststyle = 3

-- git signs
require('gitsigns').setup {
    signs = {
        add          = { hl = 'GitSignsAdd', text = '+', numhl = 'GitSignsAddNr', linehl = 'GitSignsAddLn' },
        change       = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
        delete       = { hl = 'GitSignsDelete', text = '_', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        topdelete    = { hl = 'GitSignsDelete', text = '‾', numhl = 'GitSignsDeleteNr', linehl = 'GitSignsDeleteLn' },
        changedelete = { hl = 'GitSignsChange', text = '~', numhl = 'GitSignsChangeNr', linehl = 'GitSignsChangeLn' },
    }
}

-- change mapleader from "\" to ";"
vim.g.mapleader = ";"

-- colorschemes
-- require('material').setup({
--     plugins = {
--         "gitsigns",
--         "nvim-cmp",
--         "telescope",
--     }
-- })
-- vim.g.material_style = "oceanic"
-- vim.cmd 'colorscheme material'

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

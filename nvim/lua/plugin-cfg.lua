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
        -- "nvim-cmp",
        -- "blink.cmp",
        "telescope",
        "nvim-web-devicons",
        "which-key",
    },
    lualine_style = 'default',
})
require('bluloco').setup({

})
vim.g.material_style = "oceanic"
vim.opt.termguicolors = true
-- vim.cmd 'colorscheme material'
-- vim.cmd 'colorscheme bluloco-dark'
vim.cmd 'colorscheme catppuccin-macchiato'

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

-- auto-pairs
local npairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'

npairs.setup({
    enable_check_bracket_line = false,
    check_ts = true,
})

npairs.add_rule(Rule('<', '>', {
    -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
    -- so that it doesn't conflict with nvim-ts-autotag
    '-html',
    '-javascriptreact',
    '-typescriptreact',
}):with_pair(
-- regex will make it so that it will auto-pair on
-- `a<` but not `a <`
-- The `:?:?` part makes it also
-- work on Rust generics like `some_func::<T>()`
    cond.before_regex('%a+:?:?$', 3)
):with_move(function(opts)
    return opts.char == '>'
end))

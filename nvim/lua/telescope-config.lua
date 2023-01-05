-- Telescope finder for everything: https://github.com/nvim-telescope/telescope.nvim
local t = require('telescope')
t.setup {
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95 },
    },
    pickers = {
        find_files = {
            find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
        },
    }
}

t.load_extension('fzf')

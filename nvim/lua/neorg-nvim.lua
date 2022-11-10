local neorg = require('neorg')

neorg.setup {
    load = {
        ["core.defaults"] = {},
        ["core.keybinds"] = {
            config = {
                hook = function(keybinds)
                    -- todo done
                    keybinds.remap_key("norg", "n", "gtd", "<Leader>cc")
                    -- todo undone
                    keybinds.remap_key("norg", "n", "gtu", "<Leader>cu")
                end
            }
        },
        ["core.norg.dirman"] = {
            config = {
                workspaces = {
                    work = "~/notes/work",
                    home = "~/notes/home",
                }
            }
        },
        ["core.norg.completion"] = {
            config = { engine = 'nvim-cmp' }
        },
        ["core.norg.concealer"] = {}
    }
}
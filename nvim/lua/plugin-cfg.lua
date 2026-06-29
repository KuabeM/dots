-- colorscheme
require('catppuccin').setup({
    no_italic = true,
})

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
            { 'filename', path = 1, },
            -- { function() return navic.get_location() end, cond = function() return navic.is_available() end }
        },
        lualine_x = { 'branch', 'filetype' }, -- default: 'encoding', 'fileformat'
        lualine_y = { 'searchcount' },        -- default: 'progress'
        lualine_z = { 'progress', 'location', 'filesize' }
    },
    inactive_sections = {
        lualine_c = { { 'filename', path = 1, } }
    },
    tabline = {
        lualine_a = { 'buffers', },
    }
}

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

-- used for copying git sha
require('gitblame').setup {
    enabled = 0,
    -- message_template = '	<summary> • <date> • <author> • <sha>',
    -- virtual_text_column = 120,
    -- delay = 1000,
    -- highlight_group = "CursorLine",
}

require('qfc').setup({
    timeout = 3000,
    autoclose = true,
})

-- auto-pairs
local npairs = require 'nvim-autopairs'
local Rule = require 'nvim-autopairs.rule'
local cond = require 'nvim-autopairs.conds'

npairs.setup({
    enable_check_bracket_line = false,
    check_ts = true,
})
npairs.add_rule(
    Rule('<', '>', {
        -- if you use nvim-ts-autotag, you may want to exclude these filetypes from this rule
        -- so that it doesn't conflict with nvim-ts-autotag
        '-html',
        '-javascriptreact',
        '-typescriptreact',
        }
    ):with_pair(
        -- regex will make it so that it will auto-pair on
        -- `a<` but not `a <`
        -- The `:?:?` part makes it also
        -- work on Rust generics like `some_func::<T>()`
        cond.before_regex('%a+:?:?$', 3)
    ):with_move(
        function(opts)
            return opts.char == '>'
        end
))


-- nvim-treesitter auto update parsers
vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
        local name, kind = ev.data.spec.name, ev.data.kind
        if name == 'nvim-treesitter' and kind == 'update' then
            if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
            vim.cmd('TSUpdate')
        end
    end
})

require('nvim-treesitter').setup({
    ensure_installed = {
        'rust', 'python', 'lua', 'c', 'cpp',
        'bash', 'yaml', 'cmake', 'toml',
        -- always useful
        'vim', 'vimdoc', 'query',
    },
    highlight        = { enable = true },
    indent           = { enable = true },
})

require('no-neck-pain').setup {
    width = 160,
    mappings = {
        enabled = true,
        toggleRightSide = "<Leader>nr",
    }
}

local cmp = require('blink.cmp')
cmp.build():wait(60000)
cmp.setup({
    keymap = {
        preset = 'enter',
        ['<Tab>'] = { 'select_next', 'fallback' },
        ['<S-Tab>'] = { 'select_prev', 'fallback' },
        ['<C-Tab>'] = {
            function(cmp)
                if cmp.snippet_active() then return cmp.accept()
            else
                return cmp.select_and_accept() end
            end,
            'snippet_forward',
            'fallback'
        },
        ['<S-C-Tab>'] = { 'snippet_backward', 'fallback' }
    },
    appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = 'mono'
    },
    completion = {
        menu = {
            border = 'rounded',
            -- winhighlight = 'Normal:BlinkCmpMenuSelection,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenu,Search:None',
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
            window = {
                border = 'rounded',
                -- winhighlight = 'Normal:BlinkCmpMenuSelection,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenu,Search:None',
            }
        },
        keyword = { range = 'full' },
        accept = {
            auto_brackets = {
                enabled = true,
            }
        },
        ghost_text = { enabled = false, },
        list = {
            selection = {
                preselect = function(ctx) return ctx.mode ~= 'cmdline' end,
                auto_insert = function(ctx) return ctx.mode ~= 'cmdline' end
            },
            cycle = { from_top = true, from_bottom = true },
        }
    },
    signature = { enabled = true, window = { border = 'rounded' } },
    -- Default list of enabled providers defined so that you can extend it
    -- elsewhere in your config, without redefining it, due to `opts_extend`
    sources = {
        default = { 'lsp', 'path', 'snippets', 'buffer' }, --, 'copilot' },
        providers = {
            -- copilot = { name = "copilot", module = "blink-copilot", score_offset = 100, async = true }
        },
        per_filetype = {
            codecompanion = { "codecompanion" }
        }
    },
})

require('early-retirement').setup({
    minimumBufferNum = 6,
})

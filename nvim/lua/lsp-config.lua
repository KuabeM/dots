-- Debug log
-- vim.lsp.set_log_level('Debug')

-- nvim_lsp object
local nvim_lsp = require 'lspconfig'

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local has_words_before = function()
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end

local feedkey = function(key, mode)
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
end

local cmp = require 'cmp'
cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        -- Add tab support, previous mapping
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif vim.fn["vsnip#available"](1) == 1 then
                feedkey("<Plug>(vsnip-expand-or-jump)", "")
            elseif has_words_before() then
                cmp.complete()
            else
                fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function()
            if cmp.visible() then
                cmp.select_prev_item()
            elseif vim.fn["vsnip#jumpable"](-1) == 1 then
                feedkey("<Plug>(vsnip-jump-prev)", "")
            end
        end, { "i", "s" }),

        ['<Down>'] = cmp.mapping(cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),
        ['<Up>'] = cmp.mapping(cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }), { 'i' }),

        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping.complete(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },

    -- Installed sources
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'buffer' },
    }),

    -- use buffer source for '/'
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

})

local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local dap = require('dap')
dap.adapters.lldb = {
  type = 'executable',
  command = '/usr/bin/lldb-vscode', -- adjust as needed, must be absolute path
  name = 'lldb'
}
dap.configurations.cpp = {
  {
    name = 'Launch',
    type = 'lldb',
    request = 'launch',
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
    args = {},
  }
}
dap.configurations.c = dap.configurations.cpp


-- See https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md for a list of LSPs

-- rust-tools
local rust_tools = require('rust-tools')
local opts = {
    tools = {
        autoSetHints = true,
        runnables = {
            use_telescope = true
        },
        inlay_hints = {
            parameter_hints_prefix = "",
            other_hints_prefix = "",
        },
        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
                { "╭", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╮", "FloatBorder" },
                { "│", "FloatBorder" },
                { "╯", "FloatBorder" },
                { "─", "FloatBorder" },
                { "╰", "FloatBorder" },
                { "│", "FloatBorder" },
            },
            -- whether the hover action window gets automatically focused
            -- default: false
            auto_focus = false,
        },
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                -- enable clippy on save
                checkOnSave = {
                    command = "clippy"
                },
            }
        },
        on_attach = function(_, buff_nr)
            vim.keymap.set("n", "K", rust_tools.hover_actions.hover_actions, { buffer = buff_nr })
            vim.keymap.set("n", "<leader>p", rust_tools.parent_module.parent_module, { silent = true })
        end,
    },
}
rust_tools.setup(opts)

-- Enable clangd
nvim_lsp.clangd.setup({
    capabilities = capabilities,
})

-- Enable json ls
nvim_lsp.jsonls.setup({
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end
        }
    }
})
-- Enable cmake: pip install cmake-language-server
nvim_lsp.cmake.setup {}

-- Enable docker: npm install -g dockerfile-language-server-nodejs
nvim_lsp.dockerls.setup {}

-- Groovy language server: https://github.com/GroovyLanguageServer/groovy-language-server
nvim_lsp.groovyls.setup {
    cmd = { "java", "-jar", "/home/korbinian/.local/bin/groovy-language-server-all.jar" },
}

-- https://github.com/latex-lsp/texlab
nvim_lsp.texlab.setup {
    settings = { texlab = { build = {
        executable = "tectonic",
        args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" }
    } } }
}

-- npm install -g vim-language-server
nvim_lsp.vimls.setup {}

-- npm install -g vscode-langservers-extracted
nvim_lsp.html.setup {}

-- python: pip install python-lsp-server
nvim_lsp.pylsp.setup {}

-- lua: https://github.com/sumneko/lua-language-server
nvim_lsp.sumneko_lua.setup {
    settings = {
        Lua = {
            runtime = { -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT',
            },
            diagnostics = { -- Get the language server to recognize the `vim` global
                globals = { 'vim' },
            },
            workspace = { -- Make the server aware of Neovim runtime files
                library = vim.api.nvim_get_runtime_file("", true),
            },
        },
    },
}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
    virtual_text = false,
    signs = true,
    update_in_insert = true,
}
)

-- autoformatting on save
--vim.api.nvim_command[[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]

cmp.setup({
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end,
    },
    mapping = {
        -- ['<C-p>'] = cmp.mapping.select_prev_item(),
        -- ['<C-n>'] = cmp.mapping.select_next_item(),
        -- Add tab support
        -- ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        -- ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping.complete(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-e>'] = cmp.mapping({
            i = cmp.mapping.abort(),
            c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
    },

    -- Installed sources
    sources = cmp.config.sources({
        { name = 'nvim_lsp' },
        { name = 'vsnip' },
        { name = 'path' },
        { name = 'buffer' },
    }),

    -- use buffer source for '/'
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })
})

local b = vim.lsp.buf
-- Key mappings
vim.keymap.set("n", "fd", b.definition, { silent = true, desc = "vim.lsp.buf.definition" })
vim.keymap.set("n", "K", b.hover, { silent = true, desc = "vim.lsp.buf.hover" })
vim.keymap.set("n", "fi", b.implementation, { silent = true, desc = "vim.lsp.buf.implementation" })
vim.keymap.set("n", "fu", b.declaration, { silent = true, desc = "vim.lsp.buf.declaration" })
vim.keymap.set("n", "fs", b.signature_help, { silent = true, desc = "vim.lsp.buf.signature_help" })
vim.keymap.set("n", "ft", b.type_definition, { silent = true, desc = "vim.lsp.buf.type_definition" })
vim.keymap.set("n", "fr", b.references, { silent = true, desc = "vim.lsp.buf.references" })
vim.keymap.set("n", "g0", b.document_symbol, { silent = true, desc = "vim.lsp.buf.document_symbol" })
vim.keymap.set("n", "gW", b.workspace_symbol, { silent = true, desc = "vim.lsp.buf.workspace_symbol" })
vim.keymap.set("n", "gf", function() b.format({ async = true }) end, { silent = true, desc = "vim.lsp.buf.formatting" })
vim.keymap.set("n", "fn", b.rename, { silent = true, desc = "vim.lsp.buf.rename" })
vim.keymap.set("n", "fa", b.code_action, { silent = true, desc = "vim.lsp.buf.code_action" })

vim.keymap.set("n", "fj", vim.diagnostic.goto_next, { silent = true, desc = "vim.diagnostics.goto_next" })
vim.keymap.set("n", "fk", vim.diagnostic.goto_prev, { silent = true, desc = "vim.diagnostics.goto_prev" })

-- Debug log
-- vim.lsp.set_log_level('Debug')

-- nvim_lsp object
local nvim_lsp = require 'lspconfig'

-- Setup Completion
-- See https://github.com/hrsh7th/nvim-cmp#basic-configuration
local has_words_before = function()
    unpack = unpack or table.unpack
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
    window = {
        -- completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
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
        {
            name = "lazydev",
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
        }
    }),

    -- use buffer source for '/'
    cmp.setup.cmdline('/', {
        sources = {
            { name = 'buffer' }
        }
    })

})

-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())
local capabilities = require('cmp_nvim_lsp').default_capabilities()

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

local function add_document_highlight(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

-- rust-tools
local opts = {
    tools = {
        -- see https://github.com/mrcjkb/rustaceanvim/blob/master/lua/rustaceanvim/config/internal.lua#L34C6-L34C6
        -- for available options
        float_win_config = {
            border = "rounded"
        }
    },
    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
        ---@param project_root string Path to the project root
        settings = {
            -- to enable rust-analyzer settings visit:
            -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
            ["rust-analyzer"] = {
                checkOnSave = {
                    command = "clippy"
                },
                cargo = {
                    -- features = { "master" },
                    -- noDefaultFeatures = false
                    unsetTest = {
                        -- "system_master",
                        -- "ethercat_master",
                        -- "common"
                    }
                },
                procMacro = {
                    enable = true,
                },
                inlayHints = {
                    maxLength = 10,
                    parameterHints = {
                        enable = true,
                    },
                },
            }
        },
        on_attach = function(client, buff_nr)
            vim.keymap.set("n", "<leader>p", function() vim.cmd.RustLsp('parentModule') end,
                { silent = true, desc = "parentModule" })
            vim.keymap.set("n", "fa", function() vim.cmd.RustLsp('codeAction') end,
                { silent = true, desc = "codeAction" })
            vim.keymap.set("n", "<leader>rm",
                function()
                    vim.cmd.RustLsp('rebuildProcMacros'); vim.cmd.RustLsp('expandMacro')
                end, { silent = true, desc = "Rebuild and expand macro" })
            if client.server_capabilities.documentSymbolProvider then
                require('nvim-navic').attach(client, buff_nr)
            end
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { buffnr = buff_nr })
                vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })
            end
            add_document_highlight(client, buff_nr)
        end,
    },
}
vim.g.rustaceanvim = opts



local on_attach = function(client, buff_nr)
    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, buff_nr)
    end
    add_document_highlight(client, buff_nr)
end
-- Enable clangd
nvim_lsp.clangd.setup({
    capabilities = capabilities,
    on_attach = function(client, buff_nr)
        vim.keymap.set("n", "<leader>p", ":ClangdSwitchSourceHeader<CR>",
            { silent = true, desc = ":ClangdSwitchSourceHeader<CR>" })
        add_document_highlight(client, buff_nr)
    end,
    settings = {
        clangd = {
            InlayHints = {
                Designators = true,
                Enabled = true,
                ParameterNames = true,
                DeducedTypes = true,
            },
            fallbackFlags = { "-std=c++20" },
        },
    },
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
nvim_lsp.cmake.setup {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

-- Enable docker: npm install -g dockerfile-language-server-nodejs
nvim_lsp.dockerls.setup {}

-- Groovy language server: https://github.com/GroovyLanguageServer/groovy-language-server
nvim_lsp.groovyls.setup {
    cmd = { "java", "-jar", "/home/maie_ko/.local/bin/groovy-language-server-all.jar" },
}

-- https://github.com/latex-lsp/texlab
nvim_lsp.texlab.setup {
    settings = {
        texlab = {
            build = {
                executable = "tectonic",
                args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" }
            }
        }
    }
}

-- npm install -g vim-language-server
nvim_lsp.vimls.setup {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

-- npm install -g vscode-langservers-extracted
nvim_lsp.html.setup {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

-- python: pip install python-lsp-server
nvim_lsp.pylsp.setup {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

nvim_lsp.marksman.setup{}

nvim_lsp.lua_ls.setup {
    on_init = function(client)
        local path = client.workspace_folders[1].name
        if vim.loop.fs_stat(path .. '/.luarc.json') or vim.loop.fs_stat(path .. '/.luarc.jsonc') then
            return
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
            runtime = {
                -- Tell the language server which version of Lua you're using
                -- (most likely LuaJIT in the case of Neovim)
                version = 'LuaJIT'
            },
            -- Make the server aware of Neovim runtime files
            workspace = {
                checkThirdParty = false,
                library = {
                    vim.env.VIMRUNTIME
                    -- Depending on the usage, you might want to add additional paths here.
                    -- "${3rd}/luv/library"
                    -- "${3rd}/busted/library",
                }
                -- or pull in all of 'runtimepath'. NOTE: this is a lot slower
                -- library = vim.api.nvim_get_runtime_file("", true)
            }
        })
    end,
    settings = {
        Lua = {}
    },
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

-- bashls
nvim_lsp.bashls.setup {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

-- yaml https://github.com/redhat-developer/yaml-language-server
require'lspconfig'.yamlls.setup{}

-- Enable diagnostics
vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        virtual_text = false,
        signs = true,
        update_in_insert = true,
    }
)

-- autoformatting on save
vim.api.nvim_create_autocmd(
    "BufWritePre",
    {
        pattern = { "*.rs", "*.py", "*.cmake", "CMakeLists.txt" },
        callback = function() vim.lsp.buf.format() end,
    }
)

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

-- add borders to all hover windows
vim.diagnostic.config { float = { border = "rounded" } }
vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded"
})
vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(vim.lsp.handlers.signature_help, {
    border = "rounded"
})
require('lspconfig.ui.windows').default_options = {
    border = "rounded"
}

-- customize diagnostic signs
local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
-- for type, icon in pairs(signs) do
--     local hl = "DiagnosticSign" .. type
--     -- vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
--     local cfg = vim.diagnostic.config()
vim.diagnostic.config({
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = ' ',
            [vim.diagnostic.severity.WARN] = ' ',
            [vim.diagnostic.severity.HINT] = ' ',
            [vim.diagnostic.severity.INFO] = ' ',
        },
        numhl = {
            [vim.diagnostic.severity.ERROR] = 'DiagnosticSignError',
            [vim.diagnostic.severity.WARN] = 'DiagnosticSignWarn',
            [vim.diagnostic.severity.HINT] = 'DiagnosticSignHint',
            [vim.diagnostic.severity.INFO] = 'DiagnosticSignInfo',
        },
    },
})
-- end

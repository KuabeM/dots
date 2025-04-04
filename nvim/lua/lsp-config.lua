-- Debug log
-- vim.lsp.set_log_level('Debug')

-- nvim_lsp object
local nvim_lsp = require 'lspconfig'

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
local rust_opts = {
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
            vim.keymap.set("n", "K", function() vim.cmd.RustLsp { 'hover', 'actions' } end,
                { silent = false, desc = "RustHoverAction" })
            vim.keymap.set("n", "fl", function() vim.cmd.RustLsp('relatedDiagnostics') end,
                { silent = false, desc = "relatedDiagnostics" })
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
vim.g.rustaceanvim = rust_opts

local on_attach = function(client, buff_nr)
    if client.server_capabilities.documentSymbolProvider then
        require('nvim-navic').attach(client, buff_nr)
    end
    add_document_highlight(client, buff_nr)
end

-- Enable clangd
nvim_lsp.clangd.setup({
    -- capabilities = capabilities,
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
    settings = {
        pylsp = {
            plugins = {
                yapf = { enabled = true },
                pycodestyle = {
                    maxLineLength = 100,
                }
            }
        }
    },
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
}

nvim_lsp.marksman.setup {}

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
require 'lspconfig'.yamlls.setup {}

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

local orig_util_open_floating_preview = vim.lsp.util.open_floating_preview
function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
  opts = opts or {}
  opts.border = opts.border or "rounded"
  return orig_util_open_floating_preview(contents, syntax, opts, ...)
end

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

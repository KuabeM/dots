-- Debug log
-- vim.lsp.set_log_level('Debug')

-- nvim_lsp object
local nvim_lsp = require 'lspconfig'

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
        },
        enable_clippy = true,
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
                checkOnSave = true,
                check = { command = "clippy", extraArgs = { '--no-deps' } },
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
                rustfmt = { extraArgs = { '+nightly' } },
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

-- Enable clangd
vim.lsp.config('clangd', {
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
vim.lsp.enable('clangd')

-- Enable json ls
vim.lsp.config('jsonls', {
    commands = {
        Format = {
            function()
                vim.lsp.buf.range_formatting({}, { 0, 0 }, { vim.fn.line("$"), 0 })
            end
        }
    }
})
vim.lsp.enable('jsonls')

-- Enable cmake: pip install cmake-language-server
vim.lsp.config('cmake', {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
})
vim.lsp.enable('cmake')

-- Enable docker: npm install -g dockerfile-language-server-nodejs
vim.lsp.enable('dockerls')

-- https://github.com/latex-lsp/texlab
vim.lsp.config('texlab', {
    settings = {
        texlab = {
            build = {
                executable = "tectonic",
                args = { "%f", "--synctex", "--keep-logs", "--keep-intermediates" }
            }
        }
    }
})
vim.lsp.enable('texlab')

-- npm install -g vscode-langservers-extracted
vim.lsp.config('html', {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
})
vim.lsp.enable('html')

-- python
vim.lsp.enable('ruff')

vim.api.nvim_create_autocmd("LspAttach", {
    group = vim.api.nvim_create_augroup('lsp_attach_disable_ruff_format', { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client == nil then
            return
        end
        if client.name == 'ruff' then
            -- Disable format in favor of Pyright
            client.server_capabilities.formatProvider = false
        end
    end,
    desc = 'LSP: Disable format capability from Ruff',
})


-- python: pip install python-lsp-server
vim.lsp.config('pylsp', {
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
})
vim.lsp.enable('pylsp')

vim.lsp.enable('marksman')

vim.lsp.config('lua_ls', {
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
})
vim.lsp.enable('lua_ls')

-- bashls
vim.lsp.config('bashls', {
    on_attach = function(client, bufnr)
        add_document_highlight(client, bufnr)
    end
})
vim.lsp.enable('bashls')

-- yaml https://github.com/redhat-developer/yaml-language-server
-- require 'lspconfig'.yamlls.setup {}
vim.lsp.enable('yamlls')

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
        pattern = { "*.rs", "*.cmake", "CMakeLists.txt" }, -- "*.py",
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

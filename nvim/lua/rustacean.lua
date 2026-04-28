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
            if client.server_capabilities.documentSymbolProvider then
                require('nvim-navic').attach(client, buff_nr)
            end
            if client.server_capabilities.inlayHintProvider then
                vim.lsp.inlay_hint.enable(true, { buffnr = buff_nr })
                vim.api.nvim_set_hl(0, 'LspInlayHint', { link = 'Comment' })
            end
        end,
    },
}
vim.g.rustaceanvim = rust_opts

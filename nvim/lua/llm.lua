
require("codecompanion").setup({
    interactions = {
        chat = {
            adapter = "copilot",
            opts = {
                completion_provider = "blink"
            }
        },
        inline = {
            adapter = "copilot",
        },
        cmd = {
            adapter = "copilot",
        },
        cli = {
            adapter = "copilot",
            agent = "copilot_opencode",
            agents = {
                copilot_opencode = {
                    cmd = "opencode"
                }
            },
        },
        background = {
            adapter = "copilot",
        },
    },
    opts = {
        -- log_level = "DEBUG"
    }
})

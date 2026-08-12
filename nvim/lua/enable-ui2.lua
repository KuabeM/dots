-- UI2 Configuration for Neovim (Experimental next-gen UI protocol layer)
-- Documentation: https://neovim.io/doc/user/lua/#ui2

-- Set cmdheight: 0 enables a clean, distraction-free screen where the cmdline
-- floats dynamically when typing ':' or '/', and messages appear as floating toasts.
-- Set to 1 if you prefer a persistent traditional bottom bar.
vim.o.cmdheight = 0

-- Enable and configure UI2
require("vim._core.ui2").enable({
    enable = true,
    msg = {
        -- Target routing for different message kinds, triggers, and message IDs.
        -- Sinks:
        --   "cmd"    : Command-line window (bottom row / expandable).
        --   "msg"    : Ephemeral floating notification window (auto-dismisses, non-focusable).
        --   "pager"  : Interactive pager window (focusable, scrollable, press 'q' to exit).
        --   "dialog" : Interactive modal prompt window.
        targets = {
            default = "cmd",

            -- Ephemeral notifications (floating toast messages, non-blocking)
            -- Using "msg" ensures errors and notices NEVER steal cursor focus!
            emsg = "msg", -- Error messages (e.g. search pattern not found E486)
            wmsg = "msg", -- Warnings (e.g. "search hit BOTTOM")
            echoerr = "msg", -- :echoerr messages
            lua_error = "msg", -- Lua errors
            bufwrite = "msg", -- "file written" notifications
            undo = "msg", -- Undo/redo messages
            quickfix = "msg", -- Quickfix navigation messages
            echo = "msg", -- :echo
            echomsg = "msg", -- :echomsg
            lua_print = "msg", -- print() from Lua
            shell_ret = "msg", -- Shell command exit status

            -- Interactive pager: only for long, scrollable outputs the user wants to read
            list_cmd = "pager", -- :ls, :marks, :jumps, :map, :set all
            shell_cmd = "pager", -- :!cmd command executions
            shell_out = "pager", -- :!cmd stdout
            shell_err = "pager", -- :!cmd stderr
            verbose = "pager", -- :verbose output
            rpc_error = "pager", -- Remote RPC error details
            progress = "pager", -- Long progress output

            -- Command-line & completions
            empty = "cmd",
            search_cmd = "cmd",
            search_count = "cmd",
            completion = "cmd",
            wildlist = "cmd",
            typed_cmd = "cmd",
            confirm = "cmd",
        },

        -- Dimension & timeout options
        cmd = {
            height = 0.5, -- Maximum height when expanded for multiline messages (% of lines)
        },
        dialog = {
            height = 0.5,
        },
        msg = {
            height = 0.4, -- Max height of the floating notification window
            timeout = 3500, -- Ephemeral notification display time in ms
        },
        pager = {
            height = 0.85, -- Max height for pager window
        },
    },
})

-- Custom FileType autocommands to enhance UI2 window ergonomics
local ui2_augroup = vim.api.nvim_create_augroup("user.ui2", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
    group = ui2_augroup,
    pattern = "pager",
    desc = "Ergonomic settings for UI2 pager window",
    callback = function(ev)
        local win = vim.api.nvim_get_current_win()
        -- Buffer-local options
        vim.bo[ev.buf].bufhidden = "wipe"
        -- Window-local options for comfortable reading
        vim.wo[win].wrap = true
        vim.wo[win].linebreak = true
        vim.wo[win].cursorline = true
        vim.wo[win].number = false
        vim.wo[win].relativenumber = false
        vim.wo[win].signcolumn = "no"
        vim.wo[win].foldcolumn = "0"

        -- Quick close mappings in pager
        local opts = { buffer = ev.buf, silent = true, nowait = true }
        vim.keymap.set("n", "q", "<Cmd>close<CR>", opts)
        vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", opts)
        vim.keymap.set("n", "<C-c>", "<Cmd>close<CR>", opts)
    end,
})

vim.api.nvim_create_autocmd("FileType", {
    group = ui2_augroup,
    pattern = "dialog",
    desc = "Quick dismiss for UI2 dialog window",
    callback = function(ev)
        local opts = { buffer = ev.buf, silent = true, nowait = true }
        vim.keymap.set("n", "<Esc>", "<Cmd>close<CR>", opts)
        vim.keymap.set("n", "<C-c>", "<Cmd>close<CR>", opts)
    end,
})

-- Convenient UI2 Keymaps
-- Open message history in the UI2 pager
vim.keymap.set("n", "<leader>um", "<Cmd>messages<CR>", { silent = true, desc = "UI2: Open message history" })
-- Clear ephemeral floating messages immediately
vim.keymap.set("n", "<leader>uc", function()
    local ui2 = package.loaded["vim._core.ui2"]
    if ui2 and ui2.msg and ui2.msg.msg then
        ui2.msg.msg:clear()
    end
end, { silent = true, desc = "UI2: Clear message window" })

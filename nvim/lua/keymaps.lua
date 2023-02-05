-- change mapleader from "\" to ";"
vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

local key = vim.keymap

-- netrw
key.set("n", "<leader>fe", ":Explore<CR>", { silent = true, desc = ":Explore" })

-- git blame
key.set("n", "<leader>gblame", ":GitBlameToggle<CR>", { silent = true, desc = ":GitBlameToggle" })
key.set("n", "<leader>gsha", ":GitBlameCopySHA<CR>", { desc = ":GitBlameCopySHA" })

-- scrolling
key.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "<C-u>zz" })
key.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "<C-d>zz" })
key.set("n", "n", "nzzzv", { silent = true, desc = "nzz" })
key.set("n", "N", "Nzzzv", { silent = true, desc = "Nzz" })

-- vim maximizer
key.set("n", "<C-f>", ":MaximizerToggle<CR>", { silent = true, desc = "MaximizerToggle" })
key.set("v", "<C-f>", ":MaximizerToggle<CR>gv", { silent = true, desc = "MaximizerToggle" })
key.set("i", "<C-f>", ":MaximizerToggle<CR>", { silent = true, desc = "MaximizerToggle" })

-- move through tabs and windows
key.set("n", "H", "gT", { silent = true, desc = "gT" })
key.set("n", "L", "gt", { silent = true, desc = "gt" })
key.set("n", "m", ":bn<CR>", { silent = true, desc = ":bn<CR>" })
key.set("n", "M", ":bp<CR>", { silent = true, desc = ":bp<CR>" })

-- LSP
local b = vim.lsp.buf
key.set("n", "fd", b.definition, { silent = true, desc = "vim.lsp.buf.definition" })
key.set("n", "K", b.hover, { silent = true, desc = "vim.lsp.buf.hover" })
key.set("n", "fi", b.implementation, { silent = true, desc = "vim.lsp.buf.implementation" })
key.set("n", "fu", b.declaration, { silent = true, desc = "vim.lsp.buf.declaration" })
key.set("n", "fs", b.signature_help, { silent = true, desc = "vim.lsp.buf.signature_help" })
key.set("n", "ft", b.type_definition, { silent = true, desc = "vim.lsp.buf.type_definition" })
key.set("n", "fr", b.references, { silent = true, desc = "vim.lsp.buf.references" })
key.set("n", "g0", b.document_symbol, { silent = true, desc = "vim.lsp.buf.document_symbol" })
key.set("n", "gW", b.workspace_symbol, { silent = true, desc = "vim.lsp.buf.workspace_symbol" })
key.set("n", "gf", function() b.format({ async = true }) end, { silent = true, desc = "vim.lsp.buf.formatting" })
key.set("n", "fn", b.rename, { silent = true, desc = "vim.lsp.buf.rename" })
key.set("n", "fa", b.code_action, { silent = true, desc = "vim.lsp.buf.code_action" })

key.set("n", "fj", vim.diagnostic.goto_next, { silent = true, desc = "vim.diagnostics.goto_next" })
key.set("n", "fk", vim.diagnostic.goto_prev, { silent = true, desc = "vim.diagnostics.goto_prev" })
key.set("n", "J", vim.diagnostic.open_float, { silent = true, desc = "vim.diagnostics.open_float" })

-- telescope
local t = require('telescope.builtin')
key.set("n", "<leader>ff", function() t.find_files() end, { desc = "telescope.find_files()" })
key.set("n", "<leader>h", function() t.find_files({ hidden = true }) end,
    { desc = "telescope.find_files({ hidden = true })" })
key.set("n", "<leader>fg", t.live_grep, { silent = true, desc = "telescope.live_grep()" })
key.set("n", "<leader>sg", t.grep_string, { silent = true, desc = "telescope.grep_string()" })
key.set("n", "<leader>fb", t.buffers, { silent = true, desc = "telescope.buffers()" })
key.set("n", "<leader>fh", t.help_tags, { silent = true, desc = "telescope.help_tags()" })
key.set("n", "<leader>fq", t.quickfix, { silent = true, desc = "telescope.quickfix()" })
key.set("n", "<leader>rr", t.registers, { silent = true, desc = "telescope.registers()" })
key.set("n", "<leader>fs", t.spell_suggest, { silent = true, desc = "telescope.spell_suggest()" })

key.set("n", "<leader>fr", t.lsp_references, { silent = true, desc = "telescope.lsp_references()" })
key.set("n", "<leader>ld", t.lsp_type_definitions, { silent = true, desc = "telescope.lsp_type_definitions()" })

key.set("n", "<leader>gst", t.git_status, { silent = true, desc = "telescope.git_status()" })
key.set("n", "<leader>gb", t.git_branches, { silent = true, desc = "telescope.git_branches()" })
key.set("n", "<leader>gsta", t.git_stash, { silent = true, desc = "telescope.git_stash()" })

-- close current buffer but not the split
key.set("n", "<leader>d", ":b#<bar>bd#<CR>", { silent = true, desc = "close current buffer" })
-- paste without losing it
key.set("x", "<leader>p", [["_dP]], { desc = "Paste but don't loose register" })
key.set({"n", "v"}, "<leader>d", [["_d]], { desc = "Delete but not to register" })

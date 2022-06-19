-- Telescope finder for everything: https://github.com/nvim-telescope/telescope.nvim
require('telescope').setup {
  defaults = {
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--strip-cwd-prefix" }
    },
  }
}

local t = require('telescope.builtin')
vim.keymap.set("n", "<leader>ff", t.find_files, { silent = true, desc = "telescope.find_files()" })
vim.keymap.set("n", "<leader>fg", t.live_grep, { silent = true, desc = "telescope.live_grep()" })
vim.keymap.set("n", "<leader>sg", t.grep_string, { silent = true, desc = "telescope.grep_string()" })
vim.keymap.set("n", "<leader>fb", t.buffers, { silent = true, desc = "telescope.buffers()" })
vim.keymap.set("n", "<leader>fh", t.help_tags, { silent = true, desc = "telescope.help_tags()" })
vim.keymap.set("n", "<leader>fq", t.quickfix, { silent = true, desc = "telescope.quickfix()" })
vim.keymap.set("n", "<leader>fr", t.registers, { silent = true, desc = "telescope.registers()" })
vim.keymap.set("n", "<leader>fs", t.spell_suggest, { silent = true, desc = "telescope.spell_suggest()" })

vim.keymap.set("n", "<leader>lr", t.lsp_references, { silent = true, desc = "telescope.lsp_references()" })
vim.keymap.set("n", "<leader>ld", t.lsp_type_definitions, { silent = true, desc = "telescope.lsp_type_definitions()" })

vim.keymap.set("n", "<leader>gst", t.git_status, { silent = true, desc = "telescope.git_status()" })
vim.keymap.set("n", "<leader>gb", t.git_branches, { silent = true, desc = "telescope.git_branches()" })
vim.keymap.set("n", "<leader>gsta", t.git_stash, { silent = true, desc = "telescope.git_stash()" })

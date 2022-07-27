
-- netrw
vim.keymap.set("n", "<leader>fe", ":Explore<CR>", { silent = true, desc = ":Explore" })

-- git blame
vim.keymap.set("n", "<leader>gblame", ":GitBlameToggle<CR>", { silent = true, desc = ":GitBlameToggle" })
vim.keymap.set("n", "<leader>gsha", ":GitBlameCopySHA<CR>", { desc = ":GitBlameCopySHA" })


-- change mapleader from "\" to ";"
vim.g.mapleader = ";"
vim.g.maplocalleader = "\\"

-- netrw
vim.keymap.set("n", "<leader>fe", ":Explore<CR>", { silent = true, desc = ":Explore" })

-- git blame
vim.keymap.set("n", "<leader>gblame", ":GitBlameToggle<CR>", { silent = true, desc = ":GitBlameToggle" })
vim.keymap.set("n", "<leader>gsha", ":GitBlameCopySHA<CR>", { desc = ":GitBlameCopySHA" })

-- scrolling
vim.keymap.set("n", "<C-u>", "<C-u>zz", { silent = true, desc = "<C-u>zz" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { silent = true, desc = "<C-d>zz" })
vim.keymap.set("n", "n", "nzz", { silent = true, desc = "nzz" })
vim.keymap.set("n", "N", "Nzz", { silent = true, desc = "Nzz" })

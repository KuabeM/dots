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

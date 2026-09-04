-- Define syntax matches for log files
vim.cmd([[
   syntax match logTrace "\<TRCE\>"
   syntax match logDebug "\<DEBG\>"
   syntax match logInfo  "\<INFO\>"
   syntax match logWarn  "\<WARN\>"
   syntax match logError "\<ERRO\>"
   syntax match logCrit  "\<CRIT\>"
   syntax match logKey ", \<[A-Za-z\ ]*\>:"
]])

-- Highlight group links
vim.api.nvim_set_hl(0, "logTrace", { link = "@function", default = true })
vim.api.nvim_set_hl(0, "logDebug", { link = "Debug", default = true })
vim.api.nvim_set_hl(0, "logInfo",  { link = "logBlue", default = true })
vim.api.nvim_set_hl(0, "logWarn",  { link = "WarningMsg", default = true })
vim.api.nvim_set_hl(0, "logError", { link = "ErrorMsg", default = true })
vim.api.nvim_set_hl(0, "logCrit",  { link = "ErrorMsg", default = true })
vim.api.nvim_set_hl(0, "logKey",  { link = "@comment", default = true })

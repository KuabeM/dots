--
return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'

    use {
        "nvim-neorg/neorg",
        run = ":Neorg sync-parsers",
        requires = "nvim-lua/plenary.nvim"
    }
end)

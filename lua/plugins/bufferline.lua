return {
    "akinsho/bufferline.nvim",
    version = "*",
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("bufferline").setup({
            options = {
                mode = "buffers",
                separator_style = "slant",
                diagnostics = "nvim_lsp",
            },
        })
    end,
}

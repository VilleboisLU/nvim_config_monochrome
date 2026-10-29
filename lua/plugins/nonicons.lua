return {
	"yamatsum/nvim-nonicons",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	lazy = false,
	config = function()
		require("nvim-nonicons").setup({})
	end,
}

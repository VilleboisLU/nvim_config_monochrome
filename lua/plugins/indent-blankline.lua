return {
	"lukas-reineke/indent-blankline.nvim",
	main = "ibl",
  lazy = false,
	config = function()
		require("ibl").setup({
			indent = {
				char = "│",
			},
			scope = {
				enabled = true,
				show_start = false,
				show_end = false,
			},
		})
		vim.api.nvim_set_hl(0, "IblScope", {
			fg = "#7aa2f7",
			nocombine = true,
		})
	end,
}

return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",
		config = function()
      --------------------------------------
      ---            lama
      --------------------------------------
      vim.api.nvim_create_autocmd("User", {
        pattern = "TSUpdate",
        callback = function()
          require("nvim-treesitter.parsers").lama = {
            install_info = {
              path = "/home/villebois/tree-sitter-lama",
              files = { "src/parser.c" },
              branch = "master", -- ветка ВАШЕГО репозитория
              generate_requires_npm = false,
              requires_generate_from_grammar = false,
            },
            filetype = "lama",
          }
        end,
      })
      --------------------------------------

      require("nvim-treesitter").install({
				"lua",
				"javascript",
				"c",
				"cpp",
				"rust",
				"vim",
				"vimdoc",
				"cmake",
				"java",
				"javadoc",
				"html",
				"go",
				"gomod",
				"comment",
				"python",
			})
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"lua",
					"javascript",
					"typescript",
					"c",
					"cpp",
					"rust",
					"vim",
					"vimdoc",
					"cmake",
					"java",
					"html",
					"go",
					"python",
				},
				callback = function()
					vim.treesitter.start()
				end,
			})
		end,
	},
}

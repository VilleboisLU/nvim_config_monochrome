return {
	"nvimtools/none-ls.nvim",
	config = function()
		local null_ls = require("null-ls")
		null_ls.setup({
			sources = {
				--Lua
				null_ls.builtins.formatting.stylua,
        --JS
				null_ls.builtins.formatting.prettier,
				--C++
				null_ls.builtins.formatting.clang_format,
				null_ls.builtins.diagnostics.cppcheck,
				--Java
				null_ls.builtins.formatting.google_java_format,
				null_ls.builtins.diagnostics.checkstyle,
			},
		})
	end,
}

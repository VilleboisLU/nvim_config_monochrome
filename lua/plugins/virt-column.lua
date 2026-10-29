-- Тонкая вертикальная линия-ограничитель вместо блочного colorcolumn.
-- Для C/C++ ширина берётся из ColumnLimit в ближайшем .clang-format.
local style_limits = {
	llvm = 80,
	google = 80,
	chromium = 80,
	mozilla = 80,
	gnu = 79,
	microsoft = 120,
	webkit = 0,
}

local function clang_format_limit(bufname)
	local found = vim.fs.find({ ".clang-format", "_clang-format" }, {
		upward = true,
		path = vim.fs.dirname(bufname),
	})[1]
	if not found then
		return nil
	end

	local limit, style
	for line in io.lines(found) do
		limit = limit or line:match("^%s*ColumnLimit:%s*(%d+)")
		style = style or line:match("^%s*BasedOnStyle:%s*['\"]?(%a+)")
	end
	if limit then
		return tonumber(limit)
	end
	return style_limits[(style or "llvm"):lower()] or 80
end

return {
	"lukas-reineke/virt-column.nvim",
	config = function()
		require("virt-column").setup({ char = "│" })

		vim.api.nvim_create_autocmd("FileType", {
			pattern = { "c", "cpp", "objc", "objcpp", "cuda", "proto" },
			callback = function(args)
				local limit = clang_format_limit(vim.api.nvim_buf_get_name(args.buf)) or 80
				vim.opt_local.colorcolumn = limit > 0 and tostring(limit + 1) or ""
			end,
		})
	end,
}

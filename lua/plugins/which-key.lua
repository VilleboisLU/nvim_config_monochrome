return {
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = {},
		config = function()
			local wk = require("which-key")
			wk.add({
				-- Группировка по префиксам, которые вы используете в keymaps.lua
				{ "<space>d", group = "Debug (Отладка)" },
				{ "<space>e", group = "Explorer (Проводник)" },
				{ "<space>f", group = "Find/Format (Поиск/Формат)" },
				{ "<space>g", group = "Go to (Перейти)" },
        { "<space>c", group = "Code / Claude" },
			})
		end,
	},
}

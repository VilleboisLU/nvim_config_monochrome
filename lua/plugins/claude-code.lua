-- Требуется CLI `claude` в PATH: curl -fsSL https://claude.ai/install.sh | bash
return {
	"greggh/claude-code.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	cmd = { "ClaudeCode", "ClaudeCodeContinue", "ClaudeCodeResume", "ClaudeCodeVerbose" },
	opts = {
		window = {
			position = "botright", -- "botright", "topleft", "vertical", "float"
			split_ratio = 0.3,
		},
		git = {
			use_git_root = true, -- CWD = корень git-репозитория
		},
		command = "claude",
		-- Настройки навигации и скроллинга внутри окна Claude
		keymaps = {
			toggle = {
				normal = false,
				terminal = false,
				variants = { continue = false, verbose = false },
			},
			window_navigation = true,
			scrolling = true,
		},
	},
	config = function(_, opts)
		local local_bin = vim.fn.expand("~/.local/bin")
		if vim.fn.executable(opts.command) == 0 and vim.fn.executable(local_bin .. "/" .. opts.command) == 1 then
			vim.env.PATH = local_bin .. ":" .. vim.env.PATH
		end
		
		if vim.fn.executable(opts.command) == 0 then
			vim.notify(
				"claude-code: CLI `" .. opts.command .. "` не найден в PATH\n"
					.. "Установи: curl -fsSL https://claude.ai/install.sh | bash",
				vim.log.levels.WARN
			)
		end
		require("claude-code").setup(opts)
	end,
}

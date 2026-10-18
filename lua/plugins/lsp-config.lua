return {
  {
		"mason-org/mason.nvim",
		config = function()
			require("mason").setup({
				PATH = "prepend",
			})
		end,
	},
	{
		"mason-org/mason-lspconfig.nvim",
		config = function()
			require("mason-lspconfig").setup({
				ensure_installed = {
					"lua_ls",
					"ts_ls",
					"clangd",
					"cmake",
					"rust_analyzer",
					"golangci_lint_ls",
					"zuban",
				},
				automatic_installation = true,
			})
		end,
	},
	{
		"neovim/nvim-lspconfig",
		config = function()
      local capabilities = require('cmp_nvim_lsp').default_capabilities()
			--Lua
			vim.lsp.config("lua_ls", {
        capabilities = capabilities
      })
			vim.lsp.enable("lua_ls")
			--TS
			vim.lsp.config("ts_ls", {
        capabilities = capabilities
      })
			vim.lsp.enable("ts_ls")
			--C++
			vim.lsp.config("clangd", {
        capabilities = capabilities
      })
			vim.lsp.enable("clangd")
			--CMake
			vim.lsp.config("cmake", {
        capabilities = capabilities
      })
			vim.lsp.enable("cmake")
			--Rust
			vim.lsp.config("rust_analyzer", {
        capabilities = capabilities
      })
			vim.lsp.enable("rust_analyzer")
			--Go
			vim.lsp.config("golangci_lint_ls", {
        capabilities = capabilities
      })
			vim.lsp.enable("golangci_lint_ls")
			--Python
			vim.lsp.config("zuban", {
        capabilities = capabilities
      })
			vim.lsp.enable("zuban")
	 
      -- LaMa LSP
      local lama_server_path = "/home/villebois/Lama-lsp/server/out/server.js"
      
      vim.lsp.config("lama_lsp", {
        cmd = { "node", lama_server_path, "--stdio" },
        filetypes = { "lama" },
        root_markers = { ".git" },
        capabilities = capabilities,
      })
      vim.lsp.enable("lama_lsp")
    end,
    },
    {
		"WhoIsSethDaniel/mason-tool-installer.nvim",
		dependencies = {
			"mason-org/mason.nvim",
		},
		config = function()
			require("mason-tool-installer").setup({
				ensure_installed = {
					"stylua",
					"prettier",
				},
				auto_update = true,
				run_on_start = true,
			})
		end,
	},
}

-----------------------------------------------------------
--                        Telescope
-----------------------------------------------------------
local builtin = require("telescope.builtin")
vim.keymap.set("n", "<C-p>", builtin.find_files, { desc = "Поиск файлов" })
vim.keymap.set("n", "<space>fg", builtin.live_grep, { desc = "Живой grep" })

-----------------------------------------------------------
--                        Neo-tree
-----------------------------------------------------------
vim.keymap.set("n", "<space>e", ":Neotree filesystem reveal left<CR>", { desc = "Проводник (слева)" })

-----------------------------------------------------------
--                          LSP
-----------------------------------------------------------
vim.keymap.set("n", "K", vim.lsp.buf.hover, { desc = "Документация (Hover)" })
vim.keymap.set("n", "gd", vim.lsp.buf.definition, { desc = "Перейти к определению" })
vim.keymap.set({ "n" }, "<space>ca", vim.lsp.buf.code_action, { desc = "Действия с кодом" })

-----------------------------------------------------------
--                         Style
-----------------------------------------------------------
vim.keymap.set("n", "<space>gf", vim.lsp.buf.format, { desc = "Форматировать код" })

-----------------------------------------------------------
--                       Debbuging
-----------------------------------------------------------
vim.keymap.set("n", "<space>dt", function()
	require("dap").toggle_breakpoint()
end, { desc = "Точка останова (Toggle)" })

vim.keymap.set("n", "<F5>", function()
	require("dap").continue()
end, { desc = "Продолжить (Continue)" })

vim.keymap.set("n", "<F10>", function()
	require("dap").step_over()
end, { desc = "Шаг с обходом (Step Over)" })

vim.keymap.set("n", "<F11>", function()
	require("dap").step_into()
end, { desc = "Шаг с заходом (Step Into)" })

vim.keymap.set("n", "<F12>", function()
	require("dap").step_out()
end, { desc = "Шаг с выходом (Step Out)" })

-----------------------------------------------------------
--                        Terminal
-----------------------------------------------------------
vim.keymap.set("t", "<C-`>", [[<C-\><C-n><cmd>ToggleTerm<CR>]], { silent = true, desc = "Терминал (Toggle)" })

-----------------------------------------------------------
--                          Tabs
-----------------------------------------------------------
vim.keymap.set("n", "<Tab>", "<cmd>BufferLineCycleNext<CR>", { silent = true, desc = "Следующий буфер" })
vim.keymap.set("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<CR>", { silent = true, desc = "Предыдущий буфер" })
vim.keymap.set("n", "<C-w>", function()
    local current = vim.api.nvim_get_current_buf()

    vim.cmd("bnext")

    while vim.bo.filetype == "neo-tree" do
        vim.cmd("bnext")
    end

    vim.cmd("bdelete " .. current)
end, { desc = "Закрыть буфер" })

-----------------------------------------------------------
--                        Md Preview
-----------------------------------------------------------
vim.api.nvim_create_autocmd("FileType", {
  pattern = "markdown",
  callback = function()
    vim.keymap.set("n", "<C-s>", "<Plug>MarkdownPreview",       { buffer = true, desc = "Markdown: Просмотр" })
    vim.keymap.set("n", "<M-s>", "<Plug>MarkdownPreviewStop",   { buffer = true, desc = "Markdown: Остановить" })
    vim.keymap.set("n", "<C-p>", "<Plug>MarkdownPreviewToggle", { buffer = true, desc = "Markdown: Переключить" })
  end,
})

-----------------------------------------------------------
--                        Overseer
-----------------------------------------------------------
local runner = require("util.runner")

-- <F30> = Ctrl+F6, <F29> = Ctrl+F5
vim.keymap.set("n", "<F30>", function() runner.select_config() end, { desc = "Выбрать run-конфигурацию" })
vim.keymap.set("n", "<F29>", function() runner.run_selected() end, { desc = "Запустить выбранную конфигурацию" })

-----------------------------------------------------------
--                       Claude Code
-----------------------------------------------------------
vim.keymap.set({ "n", "t" }, "<C-,>", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
vim.keymap.set("n", "<space>cc", "<cmd>ClaudeCode<cr>", { desc = "Toggle Claude Code" })
vim.keymap.set("n", "<space>cC", "<cmd>ClaudeCodeContinue<cr>", { desc = "Claude Code: продолжить диалог" })
vim.keymap.set("n", "<space>cr", "<cmd>ClaudeCodeResume<cr>", { desc = "Claude Code: история диалогов" })

vim.cmd("set expandtab")
vim.cmd("set tabstop=2")
vim.cmd("set softtabstop=2")
vim.cmd("set shiftwidth=2")
vim.cmd("set number relativenumber")

vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.cmd("IBLEnable")
    end,
})

-------------------------------------------
---               lama
-------------------------------------------

vim.filetype.add({
  extension = {
    lama = "lama",
  },
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "lama",
  callback = function(args)
    if not vim.treesitter.language.add("lama") then
      vim.notify("Парсер lama не зарегистрирован в Neovim", vim.log.levels.WARN)
      return
    end
    
    vim.schedule(function()
      local ok, err = pcall(vim.treesitter.start, args.buf, "lama")
      if not ok then
        vim.notify("Ошибка запуска Tree-sitter для lama: " .. tostring(err), vim.log.levels.ERROR)
      else
        vim.notify("Tree-sitter для lama запущен для буфера " .. args.buf, vim.log.levels.INFO)
      end
    end)
  end,
})

vim.treesitter.query.add_predicate("is-not?", function(match, pattern, bufnr, predicate)
  return false
end, { force = true })

-------------------------------------------
---           diagnostics
-------------------------------------------

vim.diagnostic.config({
  virtual_text = { prefix = "●", source = "if_many" },
  signs = true,
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
})

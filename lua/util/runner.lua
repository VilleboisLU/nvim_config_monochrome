local M = {}

local MEMO_DIR = ".memo"
local STATE_FILE = "overseer.json"
local TEMPLATES_FILE = "templates.lua"

-- ---------- Пути ----------

local function project_root()
  local root = vim.fs.root(vim.fn.getcwd(), { ".git", MEMO_DIR })
  return root or vim.fn.getcwd()
end

local function memo_dir()
  return project_root() .. "/" .. MEMO_DIR
end

local function state_path()
  return memo_dir() .. "/" .. STATE_FILE
end

local function templates_path()
  return memo_dir() .. "/" .. TEMPLATES_FILE
end

local function ensure_dir(path)
  if vim.fn.isdirectory(path) == 0 then
    vim.fn.mkdir(path, "p")
  end
end

-- ---------- Состояние (на проект) ----------

local function read_state()
  local p = state_path()
  if vim.fn.filereadable(p) == 0 then
    return {}
  end
  local lines = vim.fn.readfile(p)
  if #lines == 0 then
    return {}
  end
  local ok, data = pcall(vim.json.decode, table.concat(lines, "\n"))
  if not ok or type(data) ~= "table" then
    return {}
  end
  return data
end

local function write_state(state)
  ensure_dir(memo_dir())
  local ok, encoded = pcall(vim.json.encode, state)
  if not ok then
    return
  end
  vim.fn.writefile({ encoded }, state_path())
end

-- ---------- Шаблоны ----------

local loaded = {} -- set: path -> true

-- Загружает .memo/templates.lua и принудительно добавляет каждому
-- шаблону condition.dir = project_root(), чтобы они были per-project.
local function load_templates()
  local p = templates_path()
  if vim.fn.filereadable(p) == 0 then
    return
  end
  if loaded[p] then
    return
  end

  local dir = project_root()
  local overseer = require("overseer")
  local orig_register = overseer.register_template

  overseer.register_template = function(defn)
    defn.condition = defn.condition or {}
    local d = defn.condition.dir
    if type(d) == "string" then
      defn.condition.dir = { d, dir }
    elseif type(d) == "table" then
      table.insert(d, dir)
    else
      defn.condition.dir = dir
    end
    orig_register(defn)
  end

  local ok, err = pcall(dofile, p)
  overseer.register_template = orig_register

  if ok then
    loaded[p] = true
  else
    vim.notify("Ошибка в " .. p .. ":\n" .. tostring(err), vim.log.levels.ERROR)
  end
end

function M.reload_templates()
  local p = templates_path()
  loaded[p] = nil
  load_templates()
end

local EMPTY_TEMPLATE = [[
-- Шаблоны Overseer для этого проекта.
-- Ctrl+F6 -- выбрать, Ctrl+F5 -- запустить.

local overseer = require("overseer")

local file = ""
local out  = ""

overseer.register_template({
  name = "Build",
  builder = function()
    return {
      cmd = {},
      args = {},
      components = {
        { "on_output_quickfix" },
        "default",
      },
    }
  end,
})

overseer.register_template({
  name = "Run",
  builder = function()
    return {
      cmd = { "./" .. out },
      args = {},
      components = {
        { "open_output", direction = "tab" },
        "default",
      },
    }
  end,
})

overseer.register_template({
  name = "Build & Run",
  builder = function()
    return {
      cmd = {}
      strategy = {
        "orchestrator",
        tasks = { "Build", "Run" },
      },
    }
  end,
})
]]

local function create_templates_file()
  ensure_dir(memo_dir())
  local p = templates_path()
  if vim.fn.filereadable(p) == 1 then
    return false, p
  end
  vim.fn.writefile(vim.split(EMPTY_TEMPLATE, "\n"), p)
  return true, p
end

local function available_templates()
  local cwd = vim.fn.getcwd()
  local result = {}
  local done = false

  require("overseer.template").list({ dir = cwd }, function(templates)
    for _, t in ipairs(templates or {}) do
      local cond = t.condition or {}
      local dir = cond.dir
      local ok = false

      if not dir then
        ok = true
      elseif type(dir) == "string" then
        ok = vim.startswith(cwd, dir)
      elseif type(dir) == "table" then
        for _, d in ipairs(dir) do
          if vim.startswith(cwd, d) then
            ok = true
            break
          end
        end
      end

      if ok then
        table.insert(result, t.name)
      end
    end

    table.sort(result)
    done = true
  end)

  vim.wait(1000, function()
    return done
  end, 10)
  return result
end

-- ---------- Команды ----------

function M.select_config()
  load_templates()
  local names = available_templates()

  if #names == 0 then
    local created, p = create_templates_file()
    if created then
      vim.notify(
        "Создан " .. p .. "\nОткрой, добавь шаблоны, потом <C-F6> снова.",
        vim.log.levels.WARN
      )
    else
      vim.notify(
        "Нет конфигураций. Файл "
          .. p
          .. " существует, но пуст или без валидных шаблонов.",
        vim.log.levels.ERROR
      )
    end
    return
  end

  vim.ui.select(names, { prompt = "Run configuration:" }, function(choice)
    if not choice then
      return
    end
    local state = read_state()
    state.selected = choice
    write_state(state)
    vim.notify("Активная конфигурация: " .. choice, vim.log.levels.INFO)
  end)
end

function M.run_selected()
  load_templates()
  local state = read_state()
  local name = state.selected

  if not name then
    local created, p = create_templates_file()
    if created then
      vim.notify(
        "Создан " .. p .. "\nОткрой, добавь шаблоны, потом <C-F6> снова.",
        vim.log.levels.WARN
      )
    else
      vim.notify("Нет выбранной конфигурации. Нажми <C-F6>.", vim.log.levels.WARN)
    end
    return
  end

  local available = available_templates()
  if not vim.tbl_contains(available, name) then
    vim.notify(
      ("Конфигурация '%s' недоступна. Нажми <C-F6>"):format(name),
      vim.log.levels.WARN
    )
    return
  end

  require("overseer").run_task({ name = name })
end

return M

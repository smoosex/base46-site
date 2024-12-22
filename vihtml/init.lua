local utils = require "vihtml.utils"
local state = require "vihtml.state"
local M = {}

M.save_html = function(path, str)
  local file = io.open(path, "wb")

  if file then
    file:write(str)
    file:close()
  end
end

M.base46_themes_html = function()
  require("plenary.reload").reload_module "vihtml"
  utils.save_term_w()

  -- local list = require("nvchad.utils").list_themes()
  local cwd = vim.uv.cwd()
  local html_path = cwd .. "/src/lib/vihtml/"
  local css_path = cwd .. "/src/lib/vicss/"

  local list = { "onedark", "nord", "everforest" }

  for _, v in ipairs(list) do
    require("nvconfig").base46.theme = v
    require("base46").load_all_highlights()

    local code = utils.wins_to_html(v)

    M.save_html(html_path .. v .. ".svelte", code.html)

    M.save_html(css_path .. v .. ".css", code.css)

    state.stl_w = 0
  end
end

M.base46_themes_html()

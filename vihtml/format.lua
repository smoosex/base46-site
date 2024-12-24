return function(name, tb)
  local html_tb = {}
  local css_tb = {}
  local cur_scope

  for _, v in ipairs(tb) do
    if v == "<style>" then
      cur_scope = "css"
    elseif v == "</style>" then
      cur_scope = nil
    elseif v == "</head>" then
      cur_scope = "body"
    elseif v == "</body>" then
      cur_scope = nil
    end

    if cur_scope == "css" then
      table.insert(css_tb, "." .. name .. v)
    elseif cur_scope == "body" then
      local block = string.gsub(v, 'class="', 'class="' .. name .. " ")
      table.insert(html_tb, block)
    end
  end

  table.remove(css_tb, 1)
  table.remove(css_tb, 1)
  css_tb[1] = string.gsub(css_tb[1], "body", ".boxbg")

  table.remove(html_tb, 1)
  table.remove(html_tb, 1)

  table.insert(html_tb, 1, string.format('<section class="%s boxbg pt7 pb3  rounded-2xl">', name))

  table.insert(html_tb, "</section>")

  local html = table.concat(html_tb, "\n")
  html = html:gsub("{", "&#123;"):gsub("}", "&#125;")

  local script_tag = string.format('<script> import "$lib/vicss/%s.css" </script>', name)
  html = script_tag .. "\n\n" .. html

  -- html_tb = vim.list_extend(css_tb, html_tb)
  return {
    html = html,
    css = table.concat(css_tb, "\n"),
  }
end

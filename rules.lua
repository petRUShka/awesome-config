local awful = require("awful")
local beautiful = require("beautiful")

local scount = screen.count()

--awful.rules.rules = {
--    {   rule = { },
--        properties = { border_width = beautiful.border_width,
--        border_color = beautiful.border_normal,
--        focus = awful.client.focus.filter,
--        keys = clientkeys,
--        buttons = clientbuttons } },
--    {   rule = { class = "MPlayer" },
--        properties = { floating = true } }
--}
-- {{{ Rules
awful.rules.rules = {
    { rule = { }, properties = {
      focus = true,      size_hints_honor = false,
      keys = clientkeys, buttons = clientbuttons,
      border_width = beautiful.border_width,
      border_color = beautiful.border_normal }
    },
    { rule = { class = "Firefox",  instance = "Navigator" },
      properties = { tag = tags[scount][3] } },
    { rule = { class = "gvim",    instance = "vim" },
      properties = { tag = tags[1][2] } },
--    { rule = { class = "gvim",    instance = "_Remember_" },
--      properties = { floating = true }, callback = awful.titlebar.add  },
--    { rule = { class = "Xmessage", instance = "xmessage" },
--      properties = { floating = true }, callback = awful.titlebar.add  },
    { rule = { instance = "plugin-container" },
      properties = { floating = true }, callback = awful.titlebar.add  },
--    { rule = { class = "Akregator" },   properties = { tag = tags[scount][8]}},
--    { rule = { name  = "Alpine" },      properties = { tag = tags[1][4]} },
    { rule = { class = "Pidgin" },       properties = { tag = tags[1][5]} },
    { rule = { class = "Skype" },       properties = { tag = tags[1][5]} },
    { rule = { class = "Ark" },         properties = { floating = true } },
--    { rule = { class = "Geeqie" },      properties = { floating = true } },
--    { rule = { class = "ROX-Filer" },   properties = { floating = true } },
--    { rule = { class = "Pinentry.*" },  properties = { floating = true } },
}
-- }}}

local awful = require("awful")

-- local terminal   = "urxvt"
local terminal   = "xterm"
local browser    = "firefox"
local editor     = os.getenv("EDITOR") or "vim"
local editor_cmd = terminal .. " -e " .. editor

globalkeys = awful.util.table.join(
    -- {{{ Applications
    awful.key({ modkey }, "w", function () exec(browser) end),
    awful.key({ altkey }, "F1", function () exec(terminal) end),
    -- }}}

    -- {{{ Prompt menus
    awful.key({ altkey }, "F2", function() mypromptbox[mouse.screen]:run() end),
    -- }}}

    -- {{{ Focus controls
    awful.key({ modkey }, "j", function()
        awful.client.focus.byidx( 1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey }, "k", function()
        awful.client.focus.byidx(-1)
        if client.focus then client.focus:raise() end
    end),
    awful.key({ modkey, "Shift" }, "j", function() awful.client.swap.byidx( 1) end),
    awful.key({ modkey, "Shift" }, "k", function() awful.client.swap.byidx(-1) end),
    awful.key({ modkey, }, "Tab", function()
        awful.client.focus.history.previous()
        if client.focus then client.focus:raise() end
    end),
    -- }}}

    -- {{{ Layout maniplation
    awful.key({ modkey, }, "l", function() awful.tag.incmwfact( 0.05) end),
    awful.key({ modkey, }, "h", function() awful.tag.incmwfact(-0.05) end),
    awful.key({ modkey, }, "space", function() awful.layout.inc(layouts, 1) end),
    awful.key({ modkey, "Shift" }, "space", function() awful.layout.inc(layouts, -1) end),
    awful.key({ modkey, }, "Left", awful.tag.viewprev ),
    awful.key({ modkey, }, "Right", awful.tag.viewnext ),
    -- }}}

    -- {{{ Awesome controls
    awful.key({ modkey, "Shift" }, "q", awesome.quit),
    awful.key({ modkey, "Shift" }, "r", awesome.restart),
    -- }}}

    -- all minimized clients are restored
    awful.key({ modkey, "Shift"   }, "n",
    function()
      local tag = awful.tag.selected()
      for i=1, #tag:clients() do
        tag:clients()[i].minimized=false
      end
    end),

    -- Menubar
    awful.key({ modkey }, "r", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey }, "f", function(c) c.fullscreen = not c.fullscreen end),
    awful.key({ modkey }, "c", function(c) c:kill() end)
)

keynumber = 0
for s = 1, screen.count() do
    keynumber = math.min(9, math.max(#tags[s], keynumber))
end

for i = 1, keynumber do
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9, function()
        local screen = mouse.screen
        if tags[screen][i].selected then
            awful.tag.history.restore(screen)
        elseif tags[screen][i] then
            awful.tag.viewonly(tags[screen][i])
        end
    end),
    awful.key({ modkey, "Control" }, "#" .. i + 9, function()
        local screen = mouse.screen
        if tags[screen][i] then
            awful.tag.viewtoggle(tags[screen][i])
        end
    end),
    awful.key({ modkey, "Shift" }, "#" .. i + 9, function()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.movetotag(tags[client.focus.screen][i])
        end
    end),
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9, function()
        if client.focus and tags[client.focus.screen][i] then
            awful.client.toggletag(tags[client.focus.screen][i])
        end
    end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function(c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)

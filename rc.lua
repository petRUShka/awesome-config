-- {{{ Standard Awesome Libraries
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and Layout library
local wibox = require("wibox")
-- Theme hanling library
local beautiful = require("beautiful")
beautiful.init(awful.util.getdir("config") .. "/themes/dust/theme.lua")
-- Naughty & Menubar & Vicious
local naughty = require("naughty")
local menubar = require("menubar")
local vicious = require("vicious")
-- Widgets
local wi = require("widgets")
-- }}}

-- {{{ Error handling
-- Startup
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
        title = "Oops, there were errors during startup!",
        text = awesome.startup_errors })
end

-- Runtime
do
    local in_error = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
            title = "Oops, an error happened!",
            text = err })
        in_error = false
    end)
end
-- }}}

-- {{{ Variables
local altkey     = "Mod1"
local modkey     = "Mod4"

local home       = os.getenv("HOME")
local exec       = awful.util.spawn
local sexec      = awful.util.spawn_with_shell
local scount     = screen.count()
-- }}}

-- {{{ Layouts
local layouts =
{
    awful.layout.suit.floating, -- 1
    awful.layout.suit.tile, -- 2
    awful.layout.suit.tile.left, --3
    awful.layout.suit.tile.bottom, --4
    awful.layout.suit.tile.top, --5
    awful.layout.suit.fair, --6
    awful.layout.suit.fair.horizontal, --7
    awful.layout.suit.spiral, --8
    awful.layout.suit.spiral.dwindle, --9
    awful.layout.suit.max, --10
    awful.layout.suit.max.fullscreen, --11
    awful.layout.suit.magnifier --12
}
-- }}}

-- {{{ Naughty presets
naughty.config.defaults.timeout       = 5
naughty.config.defaults.screen        = 1
naughty.config.defaults.position      = "top_right"
naughty.config.defaults.margin        = 8
naughty.config.defaults.gap           = 1
naughty.config.defaults.ontop         = true
naughty.config.defaults.font          = "Terminus 10"
naughty.config.defaults.icon          = nil
naughty.config.defaults.icon_size     = 16
naughty.config.defaults.fg            = beautiful.fg_tooltip
naughty.config.defaults.bg            = beautiful.bg_tooltip
naughty.config.defaults.border_color  = beautiful.border_tooltip
naughty.config.defaults.border_width  = 1
naughty.config.defaults.hover_timeout = nil
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, scount do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
tags = {
--  names  = { "term", "vim", "web", "mail", "im", 6, 7, "rss", "media" },
  names  = { "term", "vim", "web", "mail", "im", "rss", "media" },
  layouts = { layouts[4], layouts[2], layouts[2], layouts[10], layouts[2], layouts[12], layouts[1]}
}

for s = 1, scount do
    tags[s] = awful.tag(tags.names, s, tags.layouts)
end
-- }}}

-- Menubar
menubar.utils.terminal = terminal

-- Clock
mytextclock = awful.widget.textclock("<span color='" .. beautiful.fg_em .. "'>%a %m/%d</span> @ %I:%M %p")
mytextclock:buttons(awful.util.table.join(
  awful.button({ }, 1, function () exec("pylendar.py") end)
))

-- {{{ Wiboxes
mywibox = {}
mygraphbox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
    awful.button({ }, 1, awful.tag.viewonly),
    awful.button({ modkey }, 1, awful.client.movetotag),
    awful.button({ }, 3, awful.tag.viewtoggle),
    awful.button({ modkey }, 3, awful.client.toggletag)
)

for s = 1, scount do
    mypromptbox[s] = awful.widget.prompt()

    -- Layoutbox
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
        awful.button({ }, 1, function() awful.layout.inc(layouts, 1) end),
        awful.button({ }, 3, function() awful.layout.inc(layouts, -1) end)))

    -- Taglist
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Wibox
    mywibox[s] = awful.wibox({ position = "top", height = 16, screen = s,
        border_width = beautiful.border_width,
        border_color = beautiful.border_focus
    })

    local left_wibox = wibox.layout.fixed.horizontal()
    left_wibox:add(mytaglist[s])
    left_wibox:add(space)
    left_wibox:add(mypromptbox[s])
    left_wibox:add(mylayoutbox[s])
    left_wibox:add(space)

    local right_wibox = wibox.layout.fixed.horizontal()
    right_wibox:add(systray)
    right_wibox:add(pipe)
    right_wibox:add(mpdwidget)
    right_wibox:add(pipe)
    right_wibox:add(gpuicon)
    right_wibox:add(gpuwidget)
    right_wibox:add(pipe)
    right_wibox:add(cpuicon)
    right_wibox:add(tzswidget)
    right_wibox:add(pipe)
    right_wibox:add(cpugraph0)
    right_wibox:add(cpupct0)
    right_wibox:add(pipe)
    right_wibox:add(cpugraph1)
    right_wibox:add(cpupct1)
    right_wibox:add(pipe)
--    right_wibox:add(cpugraph2)
--    right_wibox:add(cpupct2)
--    right_wibox:add(pipe)
--    right_wibox:add(upicon)
--    right_wibox:add(netwidget)
--    right_wibox:add(dnicon)
--    right_wibox:add(pipe)
    right_wibox:add(memused)
    right_wibox:add(mempct)
    right_wibox:add(pipe)
    right_wibox:add(rootfsused)
    right_wibox:add(rootfspct)
    right_wibox:add(pipe)
    right_wibox:add(mytextclock)
    right_wibox:add(pipe)
    right_wibox:add(baticon)
    right_wibox:add(batpct)
    right_wibox:add(pipe)
    right_wibox:add(volicon)
    right_wibox:add(volpct)
    right_wibox:add(pipe)

    local wibox_layout = wibox.layout.align.horizontal()
    wibox_layout:set_left(left_wibox)
    wibox_layout:set_right(right_wibox)

    mywibox[s]:set_widget(wibox_layout)

end
-- }}}

-- {{{ Key bindings
require("keybindings")
-- }}}

-- {{{ Rules
require("rules")
-- }}}

-- {{{ Signals
client.connect_signal("manage", function(c, startup)
    c.size_hints_honor = false

    -- Sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
        and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave
        awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

-- infolder widgets
require("autorun")

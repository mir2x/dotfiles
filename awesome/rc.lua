-- Import library
pcall(require, "luarocks.loader")
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
local wibox = require("wibox")
local beautiful = require("beautiful")
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup")
local theme_assets = require("beautiful.theme_assets")
local xresources = require("beautiful.xresources")
local dpi = xresources.apply_dpi
require("awful.hotkeys_popup.keys")

-- Error handling
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = tostring(err) })
        in_error = false
    end)
end

-- Themes 
beautiful.init(gears.filesystem.get_themes_dir() .. "default/theme.lua")

beautiful.font="Lexend Deca Bold 12"

beautiful.useless_gap = 2

beautiful.border_width = 2
beautiful.border_focus = "#5a5a5a"

beautiful.bg_normal = "#323232"
beautiful.fg_normal = "#807d7d"

beautiful.taglist_bg_focus = "#5a5a5a"
beautiful.taglist_fg_focus = "#d1cdcd"

beautiful.tasklist_bg_focus = "#5a5a5a"
beautiful.tasklist_bg_normal = "#323232"
beautiful.tasklist_fg_focus = "#d1cdcd"
beautiful.tasklist_fg_normal = "#807d7d"

beautiful.bg_systray = "#323232"

beautiful.taglist_squares_sel = theme_assets.taglist_squares_sel(
    dpi(0), "#323232"
)
beautiful.taglist_squares_unsel = theme_assets.taglist_squares_sel(
    dpi(6), "#5a5a5a"
)
beautiful.menu_height = 20
beautiful.menu_width = 200


-- Default
modkey = "Mod4"
terminal = "alacritty"
editor = os.getenv("EDITOR") or "nvim"
editor_cmd = terminal .. " -e " .. editor

-- Layout table
awful.layout.layouts = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier,
    awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}


-- Menu
myawesomemenu = 
{
   { "hotkeys", function() hotkeys_popup.show_help(nil, awful.screen.focused()) end },
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function() awesome.quit() end },
}
browsermenu=
{
	{"Brave", "brave-browser-nightly"},
	{"Chrome", "google-chrome-unstable"},
	{"Edge", "microsoft-edge-beta"},
	{"Firefox", "firefox"},
	{"Firefox Dev", "firefox-developer-edition"},
	{"Qutebrowser", "qutebrowser"},
	{"Waterfox", "waterfox-g"}
}
mymainmenu = awful.menu({ 
	items = { 
		{ "awesome", myawesomemenu, beautiful.awesome_icon },
		{ "browser", browsermenu, menubar.utils.lookup_icon("web-browser")},
		{ "open terminal", terminal }
	}	
})


-- Menubar configuration
menubar.utils.terminal = terminal 

-- Wibar
-- Create a textclock widget
mytextclock = wibox.widget.textclock(" %A %B %d,%Y %r ")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
                    awful.button({ }, 1, function(t) t:view_only() end),
                    awful.button({ modkey }, 1, function(t) if client.focus then client.focus:move_to_tag(t) end end),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, function(t) if client.focus then client.focus:toggle_tag(t) end end),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(t.screen) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(t.screen) end))

local tasklist_buttons = gears.table.join(
                     awful.button({ }, 1, function (c) if c == client.focus then c.minimized = true
                                		       else c:emit_signal("request::activate","tasklist",{raise = true}) end end),
                     awful.button({ }, 3, function () awful.menu.client_list({ theme = { width = 250 } }) end),
                     awful.button({ }, 4, function () awful.client.focus.byidx(1) end),
                     awful.button({ }, 5, function () awful.client.focus.byidx(-1) end))

awful.screen.connect_for_each_screen(function(s)
    -- Tags
    awful.tag({ " 1 ", " 2 ", " 3 ", " 4 ", " 5 ", " 6 ", " 7 ", " 8 " }, s, awful.layout.layouts[1])

    -- Create a promptbox for each screen
    s.mypromptbox = awful.widget.prompt()

    s.mylayoutbox = awful.widget.layoutbox(s)
    s.mylayoutbox:buttons(gears.table.join(
                           awful.button({ }, 1, function () awful.layout.inc( 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(-1) end),
                           awful.button({ }, 4, function () awful.layout.inc( 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(-1) end)))

    -- Create a taglist widget
    s.mytaglist = awful.widget.taglist {
        screen  = s,
        filter  = awful.widget.taglist.filter.all,
        buttons = taglist_buttons
    }

    -- Create a tasklist widget
    s.mytasklist = awful.widget.tasklist {
        screen  = s,
        filter  = awful.widget.tasklist.filter.currenttags,
        buttons = tasklist_buttons
    }

    -- Create the wibox
    s.mywibox = awful.wibar({ position = "top", height = 24, screen = s })

    -- Add widgets to the wibox
    s.mywibox:setup {

        layout = wibox.layout.align.horizontal,	
	-- Left widgets
        {             
	    layout = wibox.layout.fixed.horizontal,
            s.mytaglist,
            s.mypromptbox,
        },
	
	-- Middle widget
        s.mytasklist, 
	
	-- Right widgets
        { 
            layout = wibox.layout.fixed.horizontal,
            wibox.widget.systray(),
            mytextclock,
            s.mylayoutbox,
        },
    }
end)


-- Mouse bindings
root.buttons(gears.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))


-- Key bindings
globalkeys = gears.table.join(    
    -- Awesome
    awful.key({ modkey }, "/", hotkeys_popup.show_help, {description="show help", group="awesome"}),
    awful.key({ modkey }, "w", function () mymainmenu:show() end, {description = "show main menu", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "r", awesome.restart, {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift" }, "q", awesome.quit, {description = "quit awesome", group = "awesome"}),

    -- Tags 
    awful.key({ modkey }, "Left",   awful.tag.viewprev, {description = "view previous", group = "tag"}),
    awful.key({ modkey }, "Right",  awful.tag.viewnext, {description = "view next", group = "tag"}),
    awful.key({ modkey }, "Tab", awful.tag.history.restore,{description = "go back", group = "tag"}),
    
    -- Client
    awful.key({ modkey }, "j", function () awful.client.focus.byidx(1) end, {description = "focus next by index", group = "client"}),
    awful.key({ modkey }, "k", function () awful.client.focus.byidx(-1) end, {description = "focus previous by index", group = "client"}),
    awful.key({modkey,"Shift"},"j",function()awful.client.swap.byidx(1)end,{description="swap with next client by index",group="client"}),
    awful.key({modkey,"Shift"},"k",function()awful.client.swap.byidx(-1)end,{description="swap with previous client by index",group="client"}),
    awful.key({ modkey}, "u", awful.client.urgent.jumpto, {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,}, "r",
        function () local c = awful.client.restore() if c then c:emit_signal("request::activate", "key.unminimize", {raise = true}) end end,
        {description = "restore minimized", group = "client"}),

    -- Layout
    awful.key({ modkey }, "l", function () awful.tag.incmwfact( 0.05) end, {description = "increase master width factor", group = "layout"}),
    awful.key({ modkey }, "h", function () awful.tag.incmwfact(-0.05) end, {description = "decrease master width factor", group = "layout"}),
    awful.key({ modkey }, "space", function () awful.layout.inc( 1) end, {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1) end, {description = "select previous", group = "layout"}),
 
    -- Launcher
    awful.key({ modkey }, "p", function() menubar.show() end, {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    -- Client
    awful.key({ modkey }, "f", function (c) c.fullscreen = not c.fullscreen c:raise() end,{description="toggle fullscreen", group = "client"}),
    awful.key({ modkey }, "q", function (c) c:kill() end, {description = "close", group = "client"}),
    awful.key({ modkey, "Shift" }, "f",  awful.client.floating.toggle, {description = "toggle floating", group = "client"}),
    awful.key({ modkey }, "t", function (c) c.ontop = not c.ontop end, {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey }, "n", function (c) c.minimized = true end, {description = "minimize", group = "client"}),
    awful.key({ modkey }, "m", function (c) c.maximized = not c.maximized c:raise() end, {description = "(un)maximize", group = "client"})
)

-- Bind all key numbers to tags.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),

        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ modkey }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ modkey }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)

-- Set keys
root.keys(globalkeys)

-- Rules
awful.rules.rules = { 
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     raise = true,
                     keys = clientkeys,
                     buttons = clientbuttons,
                     screen = awful.screen.preferred,
                     placement = awful.placement.no_overlap+awful.placement.no_offscreen
     		    }
    },

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  
          "copyq",  
          "pinentry"},

        class = {
          "Arandr",
          "Blueman-manager",
          "Gpick",
          "Kruler",
          "MessageWin", 
          "Sxiv",
          "Tor Browser", 
	  "xdman-Main",
          "Wpa_gui",
          "veromix",
          "xtightvncviewer"},

        name = {
	  -- xev
          "Event Tester"},
        role = {
          "AlarmWindow",  
          "ConfigManager",
          "pop-up" }
      },
      properties = { floating = true }},

    -- Titlebars
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = false }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}


-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup
      and not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            c:emit_signal("request::activate", "titlebar", {raise = true})
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

-- Enable sloppy focus, so that focus follows mouse.
client.connect_signal("mouse::enter", function(c)
    c:emit_signal("request::activate", "mouse_enter", {raise = false})
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)

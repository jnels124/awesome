-- Standard awesome library
local gears = require("gears")
local awful = require("awful")
awful.rules = require("awful.rules")
require("awful.autofocus")
-- Widget and layout library
local wibox = require("wibox")
-- Theme handling library
local beautiful = require("beautiful")
-- Notification library
local naughty = require("naughty")
local menubar = require("menubar")

-- Widget Libraries
local blingbling = require("blingbling")
local vicious = require("vicious")
--

-- Add ons
applicationsmenu = require ("applicationsmenu")
revelation = require("revelation")
--

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({ preset = naughty.config.presets.critical,
                     title = "Oops, there were errors during startup!",
                     text = awesome.startup_errors })
end

-- Handle runtime errors after startup
do
    local in_error = false
    awesome.connect_signal("debug::error", function (err)
        -- Make sure we don't go into an endless error loop
        if in_error then return end
        in_error = true

        naughty.notify({ preset = naughty.config.presets.critical,
                         title = "Oops, an error happened!",
                         text = err })
        in_error = false
    end)
end
-- }}}


-- {{{ Variable definitions
-- Themes define colours, icons, and wallpapers
--beautiful.init("/usr/share/awesome/themes/default/theme.lua")
beautiful.init(awful.util.getdir("config") .. "/themes/dolphins/theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "gnome-terminal"
editor = os.getenv("EDITOR") or "subl"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
local layouts =
{
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    awful.layout.suit.tile.left,
    awful.layout.suit.tile.bottom,
    awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    awful.layout.suit.fair.horizontal,
    awful.layout.suit.spiral,
    awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    awful.layout.suit.max.fullscreen,
    awful.layout.suit.magnifier
}
-- }}}

-- {{{ Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end
-- }}}

-- {{{ Tags
-- Define a tag table which hold all screen tags.
tags = {}
for s = 1, screen.count() do
    -- Each screen has its own tag table.
    tags[s] = awful.tag({ "|TERM|", "|ADMIN|", "|WEB|", "|EDIT|", "|FILE|", "|DOCS|", "|SYSTEM|", "|MISC|" }, s, layouts[1] )
end
-- }}}

-- {{{ Menu
-- Create a laucher widget and a main menu
myawesomemenu = {
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", awesome.quit }
}

fileManagersMenu = {
   { "FileManager", "pcmanfm" },
   { "Nautilus", "nautilus" },
   { "SU FileManager", "gksu pcmanfm" },
   { "SU Nautilus", "gksu nautilus" }
}

internetMenu = {
   { "Chromium", "chromium" }, --, "/home/jesse/Icons/Applications/chromium.png" },
   { "Firefox", "firefox-aurora" }, --, "/home/jesse/Icons/Applications/black_firefox.png"},
   { "Links",  "links" }, --, "/home/jesse/Icons/Applications/Links.png"},
   { "Luakit", "luakit" }, --, "/home/jesse/Icons/Applications/luakit.png"},
   { "Lynx", "lynx" } --, "/home/jesse/Icons/Applications/lynx.jpg" }
}

IDEMenu = {
    { "Arduino", "arduino" }, --, "/home/jesse/Icons/Applications/arduino.png" },
    { "Blue Jay", "bluej" }, --, "/home/jesse/Icons/Applications/bluej.png" },
    { "Eclipse", "eclipse" }, --, "/home/jesse/Icons/Applications/eclipse.jpg" },
    { "Processing", "processing" } --, "/home/jesse/Icons/Applications/processing.jpe" }
}

textEditorsMenu = {
   { "Emacs", "gksu emacs" }, -- "/home/jesse/Icons/Applications/emacs.png" },
   { "Gedit", "gksu gedit" }, -- "/home/jesse/Icons/Applications/gedit.png" },
   { "Gvim", "gksu gvim" }, -- "/home/jesse/Icons/Applications/vim.png" },
   { "Kate", "gksu kate" }, --"/home/jesse/Icons/Applications/kate.png" },
   { "Sublime", "gksu /opt/sublime-text/sublime_text" } -- "/home/jesse/Icons/Applications/sublime.jpg" }
   --{ "Vim", "vim" }
}

gamesMenu = {
   { "Mario", "megamario" },
   { "Doom", "zdoom" },
}

accessoriesMenu = {
  { "Calculator", "gnome-calculator"},
  { "Contacts", "gnome-contacts" },
  { "Dictionary", "gnome-dictionary" },
  { "Fonts", "gnome-font-viewer" },
  { "Key binder", "xbindkeys -k" },
  { "SkyDrive", "gnome-documents"},
  { "Search", "gnome-search-tool" },
  { "UML", "umbrello" }
}


applicationsMenu = {
   { "AdobeReader", "acroread" }, -- "/home/jesse/Icons/Applications/adobe.png" },
   { "Audacity", "audacity" }, -- "/home/jesse/Icons/Applications/audacity.png" },
   { "Cantor", "cantor" }, --"/home/jesse/Icons/Applications/cantor.jpg" },
   { "Editors", textEditorsMenu }, -- "/home/jesse/Icons/Applications/editors.png" },
   { "Email", "thunderbird" }, -- "/home/jesse/Icons/Applications/black_thunderbird.png" }, 
   { "Games", gamesMenu }, -- "/home/jesse/Icons/Applications/gamesFolder.png" },
   { "Gimp", "gimp" }, --"/home/jesse/Icons/Applications/gimp.png" },
   { "IDE'S", IDEMenu }, --"/home/jesse/Icons/Applications/IDEFolder.png" },
   { "Internet", internetMenu }, --"/home/jesse/Icons/Applications/internet.png" },                        
   { "Music", "vlc" }, --"/home/jesse/Icons/Applications/vlc.png" },
   { "Office", "libreoffice" }, --"/home/jesse/Icons/Applications/office.png" },
   { "Okular", "okular" }, --"/home/jesse/Icons/Applications/okular.png" },
   { "Ripperx", "ripperX" }, --"/home/jesse/Icons/Applications/ripperx.jpe" },
   { "Transmission", "transmission-gtk" }, -- "/home/jesse/Icons/Applications/transmission.png" },
   { "UnetBootin", "unetbootin" }, -- "/home/jesse/Icons/Applications/unetbootin.jpg" },
   { "Virutal Box", "virtualbox" } -- "/home/jesse/Icons/Applications/virtualbox.png" }
}

networkItemsMenu = {
   { "EtherApe", "gksu etherape" }, -- "/home/jesse/Icons/Applications/etherape.png" },
   { "Firewall", "gksu gufw" }, -- "/home/jesse/Icons/Applications/firewalld.jpg" },
   --{ "Gerix", "gksu gerix"},
   { "Haguichi", "haguichi"}, -- "/home/jesse/Icons/Applications/haguichi.png" },
   { "NetTool", "gnome-nettool"}, -- "/home/jesse/Icons/Applications/nettool.jpe" },
   { "Vidalia", "vidalia" }, -- "/home/jesse/Icons/Applications/vidalia.png"},
   { "Vinagre", "vinagre" }, --"/home/jesse/Icons/Applications/vinagre.png" },
   { "Wicd", "wicd-client" } --"/home/jesse/Icons/Applications/wicd.png" }
}

systemMenu = {
   { "Appearance", "lxappearance" },
   { "Backup Utility", "gksu qt4-fsarchiver" },
   { "Battery", "batti" },
   { "Conky", "gksu conky" },
   { "Disk Cleanup", "gksu baobab" },
   { "DiskUtility", "gnome-disks" },
   { "Files", fileManagersMenu },
   { "Gparted", "gksu gparted"},
   { "Key Monitor", "key-mon" },
   { "Package Management", "fslint"},
   --{ "Network", networkItemsMenu },
   { "Power", "gnome-power-statistics" },
   { "System Properties", "gnome-session-properties" },
   { "Search", "gnome-search-tool" },
   { "Settings", "gksu gnome-control-center" },
   { "Sound", "pavucontrol" }
}

mymainmenu = awful.menu({ items = { { "awesome", myawesomemenu, beautiful.awesome_icon },
                                    { "Accesories", accessoriesMenu },-- "/home/jesse/Icons/Applications/blackFinder.png" }
                                    { "Apps", applicationsMenu }, -- "/home/jesse/Icons/Applications/apps.png" },
                                    { "Apps2", applicationsmenu.applicationsmenu() },
                                    { "Network", networkItemsMenu }, --"/home/jesse/Icons/Applications/network_w.png" },
                                    { "System", systemMenu }
                                  }
                        })

mylauncher = awful.widget.launcher({ image = beautiful.awesome_icon,
                                     menu = mymainmenu })

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibox
-- Create a textclock widget
mytextclock = awful.widget.textclock()

-- Bling bling CPU widget 
cpu_graph = blingbling.line_graph({ height = 18,
                                            width = 200,
                                            show_text = true,
                                            label = "Load: $percent %",
                                            rounded_size = 0.3,
                                            graph_background_color = "#009966"
                                          })
    cpu_graph:set_height(20)
    cpu_graph:set_width(175)
    cpu_graph:set_show_text(true)
    cpu_graph:set_label("Load: $percent %")
    cpu_graph:set_rounded_size(0.3)
    cpu_graph:set_graph_background_color("#00996690")
    cpu_graph:set_graph_color("#ff330090") -->"#rrggbbaa"
    --blingbling.popups.htop(cpu_graph, { terminal =  terminal })
    --Example with custom colors:
    blingbling.popups.htop(cpu_graph, 
                          { title_color = beautiful.notify_font_color_1 , 
                                        user_color = beautiful.notify_font_color_5, 
                                        root_color = beautiful.notify_font_color_3 , 
                                        terminal =  terminal 
                          })
    vicious.register(cpu_graph, vicious.widgets.cpu,'$1',2)

-- Bling bling progress widget cores_graph_conf ={height = 18, width = 8, rounded_size = 0.3}
    cores_graphs = {}
    for i=1,4 do
      cores_graphs[i] = blingbling.progress_graph( cores_graph_conf )
      cores_graphs[i]:set_background_color("#ff330080") -->"#rrggbbaa"
      --cores_graphs:set_height(18)
      --cores_graphs:set_width(100)
      vicious.register(cores_graphs[i], vicious.widgets.cpu, "$"..(i+1).."",1)
    end

    home_fs_usage=blingbling.value_text_box({height = 18, width = 40, v_margin = 4})
    --home_fs_usage:set_height(16)
    --home_fs_usage:set_width(40)
    --home_fs_usage:set_v_margin(2)
    --home_fs_usage:set_text_background_color("#00000099")
    home_fs_usage:set_values_text_color({{"#88aa00ff",0}, --all value > 0 will be displaying using this color
                              {"#d4aa00ff", 0.75},
                              {"#d45500ff",0.77}})
    --There is no maximum number of color that users can set, just put the lower values at first. 
    home_fs_usage:set_text_color(beautiful.textbox_widget_as_label_font_color)
    home_fs_usage:set_rounded_size(0.4)
    home_fs_usage:set_font_size(8)
    home_fs_usage:set_background_color("#00000044")
    home_fs_usage:set_label("usage: $percent %")
    
    vicious.register(home_fs_usage, vicious.widgets.fs, "${/home used_p}", 120 )

    triangular = blingbling.triangular_progressgraph({height = 18, width = 40, bar = true, v_margin = 2, h_margin = 2})
    triangular:set_value(0.7)

    volume_master = blingbling.volume({height = 18, width = 40, bar =true, show_text = true, label ="$percent%"})
    volume_master:update_master()
    volume_master:set_master_control()

    netwidget = blingbling.net({interface = "enp1s0f0:", show_text = true})
    netwidget:set_ippopup()
    
    shutdown=blingbling.system.shutdownmenu(beautiful.shutdown,
                                            beautiful.accept,
                                            beautiful.cancel)

    reboot=blingbling.system.rebootmenu(beautiful.reboot,
                                        beautiful.accept,
                                        beautiful.cancel)

-- Pacman Widget
pacwidget = blingbling.value_text_box({height = 18, width = 40, v_margin = 4})
    
    --home_fs_usage:set_height(16)
    --home_fs_usage:set_width(40)
    --home_fs_usage:set_v_margin(2)
    --home_fs_usage:set_text_background_color("#00000099")
    pacwidget:set_values_text_color({{"#88aa00ff",0}, --all value > 0 will be displaying using this color
                                        {"#d4aa00ff", 0.75},
                                        {"#d45500ff",0.77}})
    -- --There is no maximum number of color that users can set, just put the lower values at first. 
    pacwidget:set_text_color(beautiful.textbox_widget_as_label_font_color)
    pacwidget:set_rounded_size(0.4)
    pacwidget:set_font_size(8)
    pacwidget:set_background_color("#00000044")
    pacwidget:set_label("$string |Updates|") 
    pacwidget_t = awful.tooltip({ objects = { pacwidget},})
    vicious.register(pacwidget, vicious.widgets.pkg,
                   function(widget,args)
                       local io = { popen = io.popen }
                       local yaourt = io.popen("yaourt -Qu") 
                       --Check the Aur as well!
                       --local yaourt = io.popen("yaourt -Qu") 
                       local str = ''

                    for line in yaourt:lines() do
                        str = str .. line .. "\n"
                    end

                    --for line in yaourt:lines() do
                      --  str = str .. line .. "\n"
                    --end
                    pacwidget_t:set_text(str)
                    yaourt:close()
                    return " |UPDATES: " .. args[1] .. "|"
                end, 1800, "Arch") --'1800' means check every 30 minutes
--End pacman Widget

-- Initialize widget
memwidget = awful.widget.progressbar()
-- Progressbar properties
memwidget:set_width(8)
memwidget:set_height(10)
memwidget:set_vertical(true)
memwidget:set_background_color("#000000")
memwidget:set_border_color(nil)
memwidget:set_color({ type = "linear", from = { 0, 0 }, to = { 10,0 }, stops = { {0, "#AECF96"}, {0.5, "#88A175"}, 
                    {1, "#FF5656"}}})
-- Register widget
vicious.register(memwidget, vicious.widgets.mem, "$1", 13)
-- Initialize widget
memwidget2 = wibox.widget.textbox()
-- Register widget
vicious.register(memwidget2, vicious.widgets.mem, "| RAM $1% ($2MB/$3MB) |", 13)
-- Create a wibox for each screen and add it

 udisks_glue=blingbling.udisks_glue.new(beautiful.dialog_ok)
 udisks_glue:set_mount_icon(beautiful.dialog_ok)
 udisks_glue:set_umount_icon(beautiful.dialog_cancel)
 udisks_glue:set_detach_icon(beautiful.dialog_cancel)
 udisks_glue:set_Usb_icon(beautiful.usb_icon)
 udisks_glue:set_Cdrom_icon(beautiful.cdrom_icon)


mywibox = {}
mypromptbox = {}
mylayoutbox = {}
mytaglist = {}
mytaglist.buttons = awful.util.table.join(
                    awful.button({ }, 1, awful.tag.viewonly),
                    awful.button({ modkey }, 1, awful.client.movetotag),
                    awful.button({ }, 3, awful.tag.viewtoggle),
                    awful.button({ modkey }, 3, awful.client.toggletag),
                    awful.button({ }, 4, function(t) awful.tag.viewnext(awful.tag.getscreen(t)) end),
                    awful.button({ }, 5, function(t) awful.tag.viewprev(awful.tag.getscreen(t)) end)
                    )
mytasklist = {}
mytasklist.buttons = awful.util.table.join(
                     awful.button({ }, 1, function (c)
                                              if c == client.focus then
                                                  c.minimized = true
                                              else
                                                  -- Without this, the following
                                                  -- :isvisible() makes no sense
                                                  c.minimized = false
                                                  if not c:isvisible() then
                                                      awful.tag.viewonly(c:tags()[1])
                                                  end
                                                  -- This will also un-minimize
                                                  -- the client, if needed
                                                  client.focus = c
                                                  c:raise()
                                              end
                                          end),
                     awful.button({ }, 3, function ()
                                              if instance then
                                                  instance:hide()
                                                  instance = nil
                                              else
                                                  instance = awful.menu.clients({ width=250 })
                                              end
                                          end),
                     awful.button({ }, 4, function ()
                                              awful.client.focus.byidx(1)
                                              if client.focus then client.focus:raise() end
                                          end),
                     awful.button({ }, 5, function ()
                                              awful.client.focus.byidx(-1)
                                              if client.focus then client.focus:raise() end
                                          end))

for s = 1, screen.count() do
    -- Create a promptbox for each screen
    mypromptbox[s] = awful.widget.prompt()
    -- Create an imagebox widget which will contains an icon indicating which layout we're using.
    -- We need one layoutbox per screen.
    mylayoutbox[s] = awful.widget.layoutbox(s)
    mylayoutbox[s]:buttons(awful.util.table.join(
                           awful.button({ }, 1, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 3, function () awful.layout.inc(layouts, -1) end),
                           awful.button({ }, 4, function () awful.layout.inc(layouts, 1) end),
                           awful.button({ }, 5, function () awful.layout.inc(layouts, -1) end)))
    -- Create a taglist widget
    mytaglist[s] = awful.widget.taglist(s, awful.widget.taglist.filter.all, mytaglist.buttons)

    -- Create a tasklist widget
    --mytasklist[s] = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, mytasklist.buttons)

    -- Create the wibox
    mywibox[s] = awful.wibox({ position = "bottom", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    left_layout:add(mylauncher)
    left_layout:add(mytaglist[s])
    left_layout:add(mypromptbox[s])
    --left_layout:add(cpu_graph)
    --for i=1,4 do
      --left_layout:add(cores_graphs[i])
    --end

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(mytextclock)
    --right_layout:add(mylayoutbox[s])
    right_layout:add(volume_master)

    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_middle(mytasklist[s])
    layout:set_right(right_layout)

    mywibox[s]:set_widget(layout)
end
-- }}}

-- Create a wibox for each screen and add it ... Top panel
mywibox2 = {}


for s = 1, screen.count() do

    -- Create the wibox
    mywibox2[s] = awful.wibox({ position = "top", screen = s })

    -- Widgets that are aligned to the left
    local left_layout = wibox.layout.fixed.horizontal()
    
    left_layout:add(cpu_graph)
    for i=1,4 do
      left_layout:add(cores_graphs[i])
    end
    left_layout:add(memwidget) 
    left_layout:add(memwidget2)
    left_layout:add(triangular)
    left_layout:add(netwidget)
    --left_layout:add(my_cal)
    --left_layout:add(diskwidget)

    -- Widgets that are aligned to the right
    local right_layout = wibox.layout.fixed.horizontal()
    if s == 1 then right_layout:add(wibox.widget.systray()) end
    right_layout:add(shutdown)


    -- Now bring it all together (with the tasklist in the middle)
    local layout = wibox.layout.align.horizontal()
    layout:set_left(left_layout)
    layout:set_right(right_layout)

    mywibox2[s]:set_widget(layout)
end
-- }}}


-- {{{ Mouse bindings
root.buttons
(awful.util.table.join(
    awful.button({ }, 3, function () mymainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
-- }}} 

-- {{{ Key bindings
globalkeys = awful.util.table.join(
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),
    -- My bindings
    awful.key({  }, "XF86LaunchA", revelation),
    awful.key({ modkey,           }, 
              "XF86AudioMute", 
              function () awful.util.spawn_with_shell("pavucontrol") 
                end),
    --awful.key({}, "XF86AudioNext", function () awful.util.spawn_with_shell("nyxmms2 next") end)
    -- end of volume widget
    awful.key({                   }, 
              "XF86Eject", 
              function () awful.util.spawn_with_shell ("eject") 
                end),

    awful.key({                   },
              "XF86MonBrightnessDown", 
              function () awful.util.spawn_with_shell("slock") 
                end),

    awful.key({ modkey,           }, 
              "i", 
              function () awful.util.spawn_with_shell("firefox-aurora") 
                end),

    awful.key({ modkey,           }, 
              "e", 
              function () awful.util.spawn_with_shell("gksu /opt/sublime-text/sublime_text" ) 
                end),

    awful.key({ modkey,           }, 
              "f", 
              function () awful.util.spawn_with_shell("pcmanfm") 
                end),

    awful.key({ modkey,  "Shift"  }, 
              "f", 
              function () awful.util.spawn_with_shell("gksu pcmanfm") 
                end),

    --awful.key({  }, "XF86AudioMute", obvious.volume_alsa.mute),
    --awful.key({  }, "XF86AudioRaiseVolume", obvious.volume_alsa.raise ),
    --awful.key({  }, "XF86AudioLowerVolume", obvious.volume_alsa.lower ),
    -- End of my bindings
    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "w", function () mymainmenu:show() end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Control" }, "r", awesome.restart),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit),

    awful.key({ modkey,           }, "l",     function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",     function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space", function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    -- Prompt
    awful.key({ modkey },            "r",     function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                  mypromptbox[mouse.screen].widget,
                  awful.util.eval, nil,
                  awful.util.getdir("cache") .. "/history_eval")
              end),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end)
)

clientkeys = awful.util.table.join(
    awful.key({ modkey,           }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen                        ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = awful.util.table.join(globalkeys,
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = mouse.screen
                        local tag = awful.tag.gettags(screen)[i]
                        if tag then
                           awful.tag.viewonly(tag)
                        end
                  end),
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = mouse.screen
                      local tag = awful.tag.gettags(screen)[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end),
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.movetotag(tag)
                     end
                  end),
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      local tag = awful.tag.gettags(client.focus.screen)[i]
                      if client.focus and tag then
                          awful.client.toggletag(tag)
                      end
                  end))
end

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
awful.rules.rules = {
    -- All clients will match this rule.
    { rule = { },
      properties = { border_width = beautiful.border_width,
                     border_color = beautiful.border_normal,
                     focus = awful.client.focus.filter,
                     keys = clientkeys,
                     buttons = clientbuttons } },
    { rule = { class = "MPlayer" },
      properties = { floating = true } },
    { rule = { class = "pinentry" },
      properties = { floating = true } },
    { rule = { class = "gimp" },
      properties = { floating = true } },
    -- Set Firefox to always map on tags number 2 of screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { tag = tags[1][2] } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c, startup)
    -- Enable sloppy focus
    c:connect_signal("mouse::enter", function(c)
        if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier
            and awful.client.focus.filter(c) then
            client.focus = c
        end
    end)

    if not startup then
        -- Set the windows at the slave,
        -- i.e. put it at the end of others instead of setting it master.
        -- awful.client.setslave(c)

        -- Put windows in a smart way, only if they does not set an initial position.
        if not c.size_hints.user_position and not c.size_hints.program_position then
            awful.placement.no_overlap(c)
            awful.placement.no_offscreen(c)
        end
    end

    local titlebars_enabled = false
    if titlebars_enabled and (c.type == "normal" or c.type == "dialog") then
        -- buttons for the titlebar
        local buttons = awful.util.table.join(
                awful.button({ }, 1, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.move(c)
                end),
                awful.button({ }, 3, function()
                    client.focus = c
                    c:raise()
                    awful.mouse.client.resize(c)
                end)
                )

        -- Widgets that are aligned to the left
        local left_layout = wibox.layout.fixed.horizontal()
        left_layout:add(awful.titlebar.widget.iconwidget(c))
        left_layout:buttons(buttons)

        -- Widgets that are aligned to the right
        local right_layout = wibox.layout.fixed.horizontal()
        right_layout:add(awful.titlebar.widget.floatingbutton(c))
        right_layout:add(awful.titlebar.widget.maximizedbutton(c))
        right_layout:add(awful.titlebar.widget.stickybutton(c))
        right_layout:add(awful.titlebar.widget.ontopbutton(c))
        right_layout:add(awful.titlebar.widget.closebutton(c))

        -- The title goes in the middle
        local middle_layout = wibox.layout.flex.horizontal()
        local title = awful.titlebar.widget.titlewidget(c)
        title:set_align("center")
        middle_layout:add(title)
        middle_layout:buttons(buttons)

        -- Now bring it all together
        local layout = wibox.layout.align.horizontal()
        layout:set_left(left_layout)
        layout:set_right(right_layout)
        layout:set_middle(middle_layout)

        awful.titlebar(c):set_widget(layout)
    end
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}

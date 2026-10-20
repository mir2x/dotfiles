-- Hyprland config ported from ~/.config/i3/config
-- Wiki: https://wiki.hypr.land/Configuring/Start/

------------------
---- MONITORS ----
------------------

hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "eDP-2",
    mode     = "preferred",
    position = "0x0",
    scale    = 1,
})

hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = "auto",
})

---------------------
---- MY PROGRAMS ----
---------------------

local terminal = "alacritty"
local menu     = "rofi -show drun"
local mainMod  = "SUPER"   -- i3 $mod (Mod4)
local alt      = "ALT"     -- i3 $alt (Mod1)
local launch   = mainMod .. " + ALT"   -- Super+Alt+<letter>: launch an app

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------
-- ~/.xinitrc only applies to the i3/X session, so these are repeated here.

hl.env("XCURSOR_THEME", "macOS-White")
hl.env("XCURSOR_SIZE", "28")
hl.env("HYPRCURSOR_SIZE", "28")
hl.env("QT_QPA_PLATFORMTHEME", "qt6ct")
hl.env("QT_QPA_PLATFORM", "wayland;xcb")   -- flameshot native Wayland
hl.env("XMODIFIERS", "@im=fcitx")
hl.env("QT_IM_MODULE", "fcitx")
hl.env("ELECTRON_OZONE_PLATFORM_HINT", "auto")
-- NVIDIA (only matters for apps rendered on the dGPU); skipped on machines without the driver
local nvidia_driver = io.open("/proc/driver/nvidia/version", "r")
if nvidia_driver then
    nvidia_driver:close()
    hl.env("LIBVA_DRIVER_NAME", "nvidia")
    hl.env("NVD_BACKEND", "direct")
end

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP XCURSOR_THEME XCURSOR_SIZE QT_QPA_PLATFORMTHEME")
    hl.exec_cmd("dex --autostart --environment Hyprland")
    hl.exec_cmd("/usr/lib/polkit-kde-authentication-agent-1")
    hl.exec_cmd("waybar")
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("pgrep -x dunst || dunst")
    hl.exec_cmd("fcitx5 -d")
    hl.exec_cmd("flameshot")   -- tray daemon, keeps clipboard alive
end)

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in     = 5,
        gaps_out    = 10,
        border_size = 0,   -- i3: border pixel 0
        col = {
            -- TokyoNight, same as i3 client.focused / unfocused
            active_border   = "rgba(7aa2f7ff)",
            inactive_border = "rgba(0c0e14ff)",
        },
        resize_on_border = false,
        allow_tearing    = false,
        layout           = "scrolling",
    },

    decoration = {
        rounding = 0,
        shadow   = { enabled = false },
        blur     = { enabled = false },
    },

    animations = { enabled = true },
})

hl.config({ dwindle = { preserve_split = true } })

-- niri-style scrolling layout
hl.config({
    scrolling = {
        column_width           = 0.5,
        focus_fit_method       = 1,
        follow_focus           = true,
        explicit_column_widths = "0.333, 0.5, 0.667, 1.0",
    },
})

-- Groups = i3 tabbed, TokyoNight colors
hl.config({
    binds = { movefocus_cycles_groupfirst = true },   -- focus left/right cycles tabs first, like i3
    group = {
        auto_group           = true,
        insert_after_current = true,
        col = {
            border_active   = "rgba(7aa2f7ff)",
            border_inactive = "rgba(0c0e14ff)",
        },
        groupbar = {
            enabled          = true,
            height           = 26,
            font_family      = "Lilex Nerd Font",
            font_size        = 12,
            render_titles    = true,
            gradients        = true,   -- gradients draw the full tab block, not just a thin indicator
            indicator_height = 0,
            gaps_in          = 3,      -- space between tabs
            gaps_out         = 0,
            rounding         = 0,
            text_color       = "rgba(1a1b26ff)",     -- dark text on the blue active tab
            text_color_inactive = "rgba(a9b1d6ff)",
            col = {
                active   = "rgba(7aa2f7ff)",
                inactive = "rgba(292e42ff)",
            },
        },
    },
})

hl.config({
    misc = {
        force_default_wallpaper = 0,
        disable_hyprland_logo   = true,
    },
})

---------------
---- INPUT ----
---------------

hl.config({
    input = {
        kb_layout    = "us",
        follow_mouse = 1,
        sensitivity  = 0,
        touchpad     = { natural_scroll = false },
    },
})

---------------------
---- KEYBINDINGS ----
---------------------

-- Apps (i3: $mod+Return etc.)
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q",      hl.dsp.window.close())

hl.bind(launch .. " + space",      hl.dsp.exec_cmd(menu))
hl.bind(launch .. " + D",          hl.dsp.exec_cmd("rofi -show run"))
hl.bind(launch .. " + W",          hl.dsp.exec_cmd("rofi -show window"))
hl.bind(launch .. " + E",          hl.dsp.exec_cmd("rofimoji --action copy --clipboarder wl-copy"))
hl.bind(launch .. " + I",          hl.dsp.exec_cmd("rofi-fcitx5"))
hl.bind(launch .. " + M",        hl.dsp.exec_cmd("fcitx5-remote -t"))
hl.bind(launch .. " + B",          hl.dsp.exec_cmd("helium-browser"))
hl.bind(launch .. " + C",          hl.dsp.exec_cmd("copyq show"))   -- clipboard history
hl.bind(launch .. " + F",          hl.dsp.exec_cmd("dolphin"))
hl.bind(launch .. " + G",        hl.dsp.exec_cmd("/home/mir/.local/bin/rofi-folders"))
hl.bind(launch .. " + Y",        hl.dsp.exec_cmd("alacritty -e yazi"))
hl.bind(launch .. " + V",          hl.dsp.exec_cmd("code"))
hl.bind(launch .. " + S",          hl.dsp.exec_cmd("slack"))
hl.bind(launch .. " + X",          hl.dsp.exec_cmd("xdman-beta"))

-- Screenshots
hl.bind("Print",                      hl.dsp.exec_cmd("/home/mir/.local/bin/flameshot-gui"))

-- Lock (i3lock does not work on Wayland, hyprlock replaces it)
hl.bind(launch .. " + L",                hl.dsp.exec_cmd("hyprlock"))
hl.bind(mainMod .. " + SHIFT + End",  hl.dsp.exec_cmd("hyprlock"))

-- Focus: j k l ; = left down up right (same as your i3 layout)
hl.bind(mainMod .. " + J",         hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + K",         hl.dsp.focus({ direction = "down" }))
hl.bind(mainMod .. " + L",         hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + semicolon", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + left",      hl.dsp.layout("focus l"))
hl.bind(mainMod .. " + down",      hl.dsp.layout("focus d"))
hl.bind(mainMod .. " + up",        hl.dsp.layout("focus u"))
hl.bind(mainMod .. " + right",     hl.dsp.layout("focus r"))

-- Move window
hl.bind(mainMod .. " + SHIFT + J",         hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + K",         hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + L",         hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + semicolon", hl.dsp.window.move({ direction = "right" }))
hl.bind(mainMod .. " + SHIFT + left",      hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + down",      hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + up",        hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + right",     hl.dsp.window.move({ direction = "right" }))

-- Split direction for the next window (i3: $mod+h / $mod+v)
hl.bind(mainMod .. " + H", hl.dsp.layout("preselect r"))
hl.bind(mainMod .. " + V", hl.dsp.layout("preselect d"))

-- Layout
hl.bind(mainMod .. " + F",           hl.dsp.exec_cmd("/home/mir/.local/bin/toggle-colwidth"))   -- toggle full / half width
hl.bind(mainMod .. " + SHIFT + F",   hl.dsp.window.fullscreen({ mode = "fullscreen" }))
hl.bind(mainMod .. " + CTRL + R",    hl.dsp.layout("colresize +conf"))   -- cycle column widths
hl.bind(mainMod .. " + W",           hl.dsp.group.toggle())   -- i3 tabbed
hl.bind(mainMod .. " + E",           hl.dsp.layout("togglesplit"))
hl.bind(mainMod .. " + Tab",         hl.dsp.group.next())hl.bind(mainMod .. " + SHIFT + space", hl.dsp.window.float({ action = "toggle" }))

-- Workspaces
for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key,         hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i, follow = false }))
end

-- Reload / exit
hl.bind(mainMod .. " + SHIFT + C", hl.dsp.exec_cmd("hyprctl reload"))
hl.bind(mainMod .. " + SHIFT + Q", hl.dsp.exec_cmd("command -v hyprshutdown >/dev/null 2>&1 && hyprshutdown || hyprctl dispatch 'hl.dsp.exit()'"))

-- Resize mode (i3: $mod+r, j/k/l/; or arrows)
hl.bind(mainMod .. " + R", hl.dsp.submap("resize"))
hl.define_submap("resize", function()
    hl.bind("J",         hl.dsp.window.resize({ x = -20, y = 0,   relative = true }), { repeating = true })
    hl.bind("K",         hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }), { repeating = true })
    hl.bind("L",         hl.dsp.window.resize({ x = 0,   y = -20, relative = true }), { repeating = true })
    hl.bind("semicolon", hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }), { repeating = true })
    hl.bind("left",      hl.dsp.window.resize({ x = -20, y = 0,   relative = true }), { repeating = true })
    hl.bind("down",      hl.dsp.window.resize({ x = 0,   y = 20,  relative = true }), { repeating = true })
    hl.bind("up",        hl.dsp.window.resize({ x = 0,   y = -20, relative = true }), { repeating = true })
    hl.bind("right",     hl.dsp.window.resize({ x = 20,  y = 0,   relative = true }), { repeating = true })
    hl.bind("Return",    hl.dsp.submap("reset"))
    hl.bind("Escape",    hl.dsp.submap("reset"))
    hl.bind(mainMod .. " + R", hl.dsp.submap("reset"))
end)

-- Mouse: $mod+drag moves, $mod+right-drag resizes (i3 floating_modifier)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(),   { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- Media / brightness keys (same commands as i3)
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +10%"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -10%"), { locked = true, repeating = true })
hl.bind("XF86AudioMute",        hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute",     hl.dsp.exec_cmd("pactl set-source-mute @DEFAULT_SOURCE@ toggle"), { locked = true })
hl.bind("XF86MonBrightnessUp",  hl.dsp.exec_cmd("brightnessctl set 10%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown",hl.dsp.exec_cmd("brightnessctl set 10%-"), { locked = true, repeating = true })
hl.bind("XF86AudioNext",  hl.dsp.exec_cmd("playerctl next"),       { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay",  hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev",  hl.dsp.exec_cmd("playerctl previous"),   { locked = true })

--------------------------------
---- WINDOWS AND WORKSPACES ----
--------------------------------

hl.window_rule({
    name  = "suppress-maximize-events",
    match = { class = ".*" },
    suppress_event = "maximize",
})

hl.window_rule({
    name  = "fix-xwayland-drags",
    match = { class = "^$", title = "^$", xwayland = true, float = true, fullscreen = false, pin = false },
    no_focus = true,
})

-- i3 for_window assignments
hl.window_rule({ name = "firefox-ws2",     match = { class = "[Ff]irefox" },     workspace = "1" })
hl.window_rule({ name = "code-oss-ws2", match = { class = "[Aa]ntigravity" }, workspace = "2" })

hl.window_rule({ name = "gradia-float", match = { class = "gradia" }, float = true, center = true })
hl.window_rule({ name = "copyq-float",  match = { class = "(?i)^com\\.github\\.hluk\\.copyq$|^copyq$" }, float = true, center = true })

-- Flameshot overlay: floating, pinned, no effects. Position is set by ~/.local/bin/flameshot-gui
-- (top-left of all monitors), so it works with one or several displays.
hl.window_rule({
    name  = "flameshot-overlay",
    match = { class = "^(flameshot)$" },
    float = true,
    pin   = true,
    no_anim = true,
    no_shadow = true,
    no_blur = true,
    rounding = 0,
    border_size = 0,
})

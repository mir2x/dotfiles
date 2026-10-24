/* Taken from https://github.com/djpohly/dwl/issues/466 */
#define COLOR(hex)    { ((hex >> 24) & 0xFF) / 255.0f, \
                        ((hex >> 16) & 0xFF) / 255.0f, \
                        ((hex >> 8) & 0xFF) / 255.0f, \
                        (hex & 0xFF) / 255.0f }
/* appearance */
static const int sloppyfocus               = 1;  /* focus follows mouse */
static const int bypass_surface_visibility = 0;  /* 1 means idle inhibitors will disable idle tracking even if it's surface isn't visible  */
static const int smartgaps                 = 0;  /* 1 means no outer gap when there is only one window */
static const int monoclegaps               = 0;  /* 1 means outer gaps in monocle layout */
static const unsigned int borderpx         = 1;  /* border pixel of windows */
static const unsigned int systrayspacing   = 2;  /* systray spacing */
static const int showsystray               = 1;  /* 0 means no systray */
static const unsigned int gappih           = 10; /* horiz inner gap between windows */
static const unsigned int gappiv           = 10; /* vert inner gap between windows */
static const unsigned int gappoh           = 10; /* horiz outer gap between windows and screen edge */
static const unsigned int gappov           = 10; /* vert outer gap between windows and screen edge */
static const int showbar                   = 1; /* 0 means no bar */
static const int topbar                    = 1; /* 0 means bottom bar */
static const char *fonts[]                 = {"Lilex Nerd Font:size=12"};
static const float rootcolor[]             = COLOR(0x1a1b26ff);
/* This conforms to the xdg-protocol. Set the alpha to zero to restore the old behavior */
static const float fullscreen_bg[]         = {0.0f, 0.0f, 0.0f, 1.0f}; /* You can also use glsl colors */
static uint32_t colors[][3]                = {
	/*               fg          bg          border    */  /* Tokyo Night */
	[SchemeNorm] = { 0xa9b1d6ff, 0x1a1b26ff, 0x292e42ff },
	[SchemeSel]  = { 0x1a1b26ff, 0x7aa2f7ff, 0x7aa2f7ff },
	[SchemeHid]  = { 0x565f89ff, 0x1a1b26ff, 0x7aa2f7ff },
	[SchemeUrg]  = { 0x1a1b26ff, 0xf7768eff, 0xf7768eff },
};
static int enableautoswallow = 1; /* enables autoswallowing newly spawned clients */
static float swallowborder = 1.0f; /* add this multiplied by borderpx to border when a client is swallowed */

#define SCRATCHPAD_COUNT 3
/* tagging */
static char *tags[] = { "1", "2", "3", "4", "5", "6", "7", "8", "9" };

/* logging */
static int log_level = WLR_ERROR;

/* Autostart */
static const char *const autostart[] = {
        "dbus-update-activation-environment", "--systemd", "WAYLAND_DISPLAY", "XDG_CURRENT_DESKTOP",
                "XCURSOR_THEME", "XCURSOR_SIZE", NULL, /* not QT_QPA_PLATFORMTHEME: it makes the KDE portal deadlock on FileChooser */
        "dex", "--autostart", "--environment", "dwl", NULL,
        "/usr/lib/polkit-kde-authentication-agent-1", NULL,
        "sh", "-c", "pgrep -x dunst || exec dunst", NULL,
        "sh", "-c", "exec swaybg -i \"$HOME/Pictures/wallpaper.jpg\" -m fill", NULL,
        "fcitx5", NULL,
        "flameshot", NULL,
        "copyq", NULL,
        NULL /* terminate */
};

/* Max amount of dynamically added rules */
#define RULES_MAX 100

static const Rule rules[] = {
	/* app_id             title       tags mask     isfloating   isterm   noswallow   monitor */
	{ "foot",             NULL,       0,            0,           1,       1,          -1 },
	{ "flameshot",        NULL,       0,            1,           0,       0,          -1 },
	{ "copyq",            NULL,       0,            1,           0,       0,          -1 },
	{ "blueman",          NULL,       0,            1,           0,       0,          -1 }, 
};

/* layout(s) */
static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[T]",      tile },
	{ "[FL]",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* monitors */
/* (x=-1, y=-1) is reserved as an "autoconfigure" monitor position indicator
 * WARNING: negative values other than (-1, -1) cause problems with Xwayland clients due to
 * https://gitlab.freedesktop.org/xorg/xserver/-/issues/899 */
static const MonitorRule monrules[] = {
   /* name        mfact  nmaster scale layout       rotate/reflect                x    y
    * example of a HiDPI laptop monitor:
    { "eDP-1",    0.5f,  1,      2,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 }, */
	{ NULL,       0.55f, 1,      1,    &layouts[0], WL_OUTPUT_TRANSFORM_NORMAL,   -1,  -1 },
	/* default monitor rule: can be changed but cannot be eliminated; at least one monitor rule must exist */
};

/* keyboard */
static const struct xkb_rule_names xkb_rules = {
	/* can specify fields: rules, model, layout, variant, options */
	/* example:
	.options = "ctrl:nocaps",
	*/
	.options = NULL,
};

static const int repeat_rate = 25;
static const int repeat_delay = 600;

/* Trackpad */
static const int tap_to_click = 1;
static const int tap_and_drag = 1;
static const int drag_lock = 1;
static const int natural_scrolling = 0;
static const int disable_while_typing = 1;
static const int left_handed = 0;
static const int middle_button_emulation = 0;
/* You can choose between:
LIBINPUT_CONFIG_SCROLL_NO_SCROLL
LIBINPUT_CONFIG_SCROLL_2FG
LIBINPUT_CONFIG_SCROLL_EDGE
LIBINPUT_CONFIG_SCROLL_ON_BUTTON_DOWN
*/
static const enum libinput_config_scroll_method scroll_method = LIBINPUT_CONFIG_SCROLL_2FG;

/* You can choose between:
LIBINPUT_CONFIG_CLICK_METHOD_NONE
LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS
LIBINPUT_CONFIG_CLICK_METHOD_CLICKFINGER
*/
static const enum libinput_config_click_method click_method = LIBINPUT_CONFIG_CLICK_METHOD_BUTTON_AREAS;

/* You can choose between:
LIBINPUT_CONFIG_SEND_EVENTS_ENABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED
LIBINPUT_CONFIG_SEND_EVENTS_DISABLED_ON_EXTERNAL_MOUSE
*/
static const uint32_t send_events_mode = LIBINPUT_CONFIG_SEND_EVENTS_ENABLED;

/* You can choose between:
LIBINPUT_CONFIG_ACCEL_PROFILE_FLAT
LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE
*/
static const enum libinput_config_accel_profile accel_profile = LIBINPUT_CONFIG_ACCEL_PROFILE_ADAPTIVE;
static const double accel_speed = 0.0;

/* You can choose between:
LIBINPUT_CONFIG_TAP_MAP_LRM -- 1/2/3 finger tap maps to left/right/middle
LIBINPUT_CONFIG_TAP_MAP_LMR -- 1/2/3 finger tap maps to left/middle/right
*/
static const enum libinput_config_tap_button_map button_map = LIBINPUT_CONFIG_TAP_MAP_LRM;

/* If you want to use the windows key for MODKEY, use WLR_MODIFIER_LOGO */
#define MODKEY WLR_MODIFIER_LOGO

#define TAGKEYS(KEY,SKEY,TAG) \
	{ MODKEY,                    KEY,            view,            {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL,  KEY,            toggleview,      {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_SHIFT, SKEY,           tag,             {.ui = 1 << TAG} }, \
	{ MODKEY|WLR_MODIFIER_CTRL|WLR_MODIFIER_SHIFT,SKEY,toggletag, {.ui = 1 << TAG} }

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
static const char *termcmd[] = { "foot", NULL };
/* ported from hyprland.lua; launch = Super+Alt+<key> */
#define SH(cmd) { "sh", "-c", cmd, NULL }
static const char *dmenucmd[]    = { "rofi", "-dmenu", "-p", "tray", NULL }; /* tray right-click menus */
static const char *rofidrun[]    = SH("rofi -show drun");
static const char *rofirun[]     = SH("rofi -show run");
static const char *rofiwin[]     = SH("rofi -show window");
static const char *rofimojicmd[] = SH("rofimoji --action copy --clipboarder wl-copy");
static const char *rofifcitx[]   = SH("rofi-fcitx5");
static const char *fcitxtoggle[] = SH("fcitx5-remote -t");
static const char *browsercmd[]  = SH("helium-browser");
static const char *firefoxcmd[]  = SH("firefox");
static const char *bluemancmd[]  = SH("blueman-manager");
static const char *copyqcmd[]    = SH("copyq show");
static const char *filescmd[]    = SH("dolphin");
static const char *rofifolders[] = SH("/home/mir/.local/bin/rofi-folders");
static const char *yazicmd[]     = SH("alacritty -e yazi");
static const char *codecmd[]     = SH("code");
static const char *slackcmd[]    = SH("slack");
static const char *xdmancmd[]    = SH("xdman-beta");
static const char *shotcmd[]     = SH("/home/mir/.local/bin/flameshot-gui");
static const char *lockcmd[]     = SH("hyprlock");
static const char *volupcmd[]    = SH("pactl set-sink-volume @DEFAULT_SINK@ +10%");
static const char *voldowncmd[]  = SH("pactl set-sink-volume @DEFAULT_SINK@ -10%");
static const char *volmutecmd[]  = SH("pactl set-sink-mute @DEFAULT_SINK@ toggle");
static const char *micmutecmd[]  = SH("pactl set-source-mute @DEFAULT_SOURCE@ toggle");
static const char *brupcmd[]     = SH("brightnessctl set 10%+");
static const char *brdowncmd[]   = SH("brightnessctl set 10%-");
static const char *nextcmd[]     = SH("playerctl next");
static const char *playcmd[]     = SH("playerctl play-pause");
static const char *prevcmd[]     = SH("playerctl previous");

static const Key keys[] = {
	/* Note that Shift changes certain key codes: 2 -> at, etc. */
	/* modifier                  key                  function          argument */
	{ MODKEY,                    XKB_KEY_Return,      spawn,            {.v = termcmd} },
	{ MODKEY,                    XKB_KEY_space,       spawn,            {.v = rofidrun} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_h,    spawn, {.v = browsercmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_f,    spawn, {.v = firefoxcmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_r,    spawn, {.v = rofirun} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_b,    spawn, {.v = bluemancmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_d,    spawn, {.v = filescmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_w,     spawn, {.v = rofiwin} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_e,     spawn, {.v = rofimojicmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_i,     spawn, {.v = rofifcitx} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_m,     spawn, {.v = fcitxtoggle} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_c,     spawn, {.v = copyqcmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_g,     spawn, {.v = rofifolders} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_y,     spawn, {.v = yazicmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_v,     spawn, {.v = codecmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_s,     spawn, {.v = slackcmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_x,     spawn, {.v = xdmancmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_ALT, XKB_KEY_l,     spawn, {.v = lockcmd} },
	{ WLR_MODIFIER_LOGO|WLR_MODIFIER_SHIFT, XKB_KEY_End, spawn, {.v = lockcmd} },
	{ 0, XKB_KEY_Print,                  spawn, {.v = shotcmd} },
	{ 0, XKB_KEY_XF86AudioRaiseVolume,   spawn, {.v = volupcmd} },
	{ 0, XKB_KEY_XF86AudioLowerVolume,   spawn, {.v = voldowncmd} },
	{ 0, XKB_KEY_XF86AudioMute,          spawn, {.v = volmutecmd} },
	{ 0, XKB_KEY_XF86AudioMicMute,       spawn, {.v = micmutecmd} },
	{ 0, XKB_KEY_XF86MonBrightnessUp,    spawn, {.v = brupcmd} },
	{ 0, XKB_KEY_XF86MonBrightnessDown,  spawn, {.v = brdowncmd} },
	{ 0, XKB_KEY_XF86AudioNext,          spawn, {.v = nextcmd} },
	{ 0, XKB_KEY_XF86AudioPause,         spawn, {.v = playcmd} },
	{ 0, XKB_KEY_XF86AudioPlay,          spawn, {.v = playcmd} },
	{ 0, XKB_KEY_XF86AudioPrev,          spawn, {.v = prevcmd} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Return,      zoom,             {0} },
	{ MODKEY,                    XKB_KEY_b,           togglebar,        {0} },
	{ MODKEY,                    XKB_KEY_Down,        focusstackvis,    {.i = +1} },
	{ MODKEY,                    XKB_KEY_Up,          focusstackvis,    {.i = -1} },
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Down,        focusstackhid,    {.i = +1} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_Up,          focusstackhid,    {.i = -1} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_h,           hide,             {0} },
	{ MODKEY,                    XKB_KEY_s,           show,             {0} },
    { MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_s,           showall,          {0} },
	{ MODKEY|WLR_MODIFIER_CTRL,  XKB_KEY_Down,        movestack,        {.i = +1} },
	{ MODKEY|WLR_MODIFIER_CTRL,  XKB_KEY_Up,          movestack,        {.i = -1} },
	{ MODKEY,                    XKB_KEY_i,           incnmaster,       {.i = +1} },
	{ MODKEY,                    XKB_KEY_d,           incnmaster,       {.i = -1} },
	{ MODKEY,                    XKB_KEY_Left,        setmfact,         {.f = -0.05f} },
	{ MODKEY,                    XKB_KEY_Right,       setmfact,         {.f = +0.05f} },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_Up,         incgaps,       {.i = +1 } },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_Down,       incgaps,       {.i = -1 } },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_0,          togglegaps,     {0} },
	{ MODKEY|WLR_MODIFIER_ALT|WLR_MODIFIER_SHIFT,   XKB_KEY_parenright,defaultgaps,    {0} },
	{ MODKEY,                    XKB_KEY_Tab,         view,             {0} },
	{ MODKEY,                    XKB_KEY_q,           killclient,       {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_z,           addscratchpad,    {0} },
	{ MODKEY|WLR_MODIFIER_CTRL,  XKB_KEY_z,           togglescratchpad, {0} },
	{ MODKEY,                    XKB_KEY_z,           removescratchpad, {0} },
	{ MODKEY,                    XKB_KEY_t,           setlayout,        {.v = &layouts[0]} },
	{ MODKEY,                    XKB_KEY_m,           setlayout,        {.v = &layouts[2]} },
	/* { MODKEY,                    XKB_KEY_space,       setlayout,        {0} }, */
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_F,           setlayout,        {.v = &layouts[1]} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_space,       togglefloating,   {0} },
	{ MODKEY,                    XKB_KEY_f,           togglefullscreen, {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_R,           setruleisfloating,{0} },
	{ MODKEY,                    XKB_KEY_a,           toggleswallow,    {0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_A,           toggleautoswallow,{0} },
	{ MODKEY,                    XKB_KEY_0,           view,             {.ui = ~0} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_parenright,  tag,              {.ui = ~0} },
	{ MODKEY,                    XKB_KEY_comma,       focusmon,         {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY,                    XKB_KEY_period,      focusmon,         {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_less,        tagmon,           {.i = WLR_DIRECTION_LEFT} },
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_greater,     tagmon,           {.i = WLR_DIRECTION_RIGHT} },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_1,           setscratchpad,    {.i = 0} },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_2,           setscratchpad,    {.i = 1} },
	{ MODKEY|WLR_MODIFIER_ALT,  XKB_KEY_3,           setscratchpad,    {.i = 2} },
	TAGKEYS(          XKB_KEY_1, XKB_KEY_exclam,                        0),
	TAGKEYS(          XKB_KEY_2, XKB_KEY_at,                            1),
	TAGKEYS(          XKB_KEY_3, XKB_KEY_numbersign,                    2),
	TAGKEYS(          XKB_KEY_4, XKB_KEY_dollar,                        3),
	TAGKEYS(          XKB_KEY_5, XKB_KEY_percent,                       4),
	TAGKEYS(          XKB_KEY_6, XKB_KEY_asciicircum,                   5),
	TAGKEYS(          XKB_KEY_7, XKB_KEY_ampersand,                     6),
	TAGKEYS(          XKB_KEY_8, XKB_KEY_asterisk,                      7),
	TAGKEYS(          XKB_KEY_9, XKB_KEY_parenleft,                     8),
	{ MODKEY|WLR_MODIFIER_SHIFT, XKB_KEY_q,           quit,             {0} },

	/* Ctrl-Alt-Backspace and Ctrl-Alt-Fx used to be handled by X server */
	{ WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_Terminate_Server, quit, {0} },
	/* Ctrl-Alt-Fx is used to switch to another VT, if you don't know what a VT is
	 * do not remove them.
	 */
#define CHVT(n) { WLR_MODIFIER_CTRL|WLR_MODIFIER_ALT,XKB_KEY_XF86Switch_VT_##n, chvt, {.ui = (n)} }
	CHVT(1), CHVT(2), CHVT(3), CHVT(4), CHVT(5), CHVT(6),
	CHVT(7), CHVT(8), CHVT(9), CHVT(10), CHVT(11), CHVT(12),
};

static const Button buttons[] = {
	{ ClkLtSymbol, 0,      BTN_LEFT,   setlayout,      {.v = &layouts[0]} },
	{ ClkLtSymbol, 0,      BTN_RIGHT,  setlayout,      {.v = &layouts[2]} },
	{ ClkTitle,    0,      BTN_LEFT,   togglewin,      {0} },
	{ ClkStatus,   0,      BTN_MIDDLE, spawn,          {.v = termcmd} },
	{ ClkClient,   MODKEY, BTN_LEFT,   moveresize,     {.ui = CurMove} },
	{ ClkClient,   MODKEY, BTN_MIDDLE, togglefloating, {0} },
	{ ClkClient,   MODKEY, BTN_RIGHT,  moveresize,     {.ui = CurResize} },
	{ ClkTagBar,   0,      BTN_LEFT,   view,           {0} },
	{ ClkTagBar,   0,      BTN_RIGHT,  toggleview,     {0} },
	{ ClkTagBar,   MODKEY, BTN_LEFT,   tag,            {0} },
	{ ClkTagBar,   MODKEY, BTN_RIGHT,  toggletag,      {0} },
	{ ClkTray,     0,      BTN_LEFT,   trayactivate,   {0} },
	{ ClkTray,     0,      BTN_RIGHT,  traymenu,       {0} },
};

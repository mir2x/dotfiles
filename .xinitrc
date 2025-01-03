sxhkd &
copyq &
xrandr --output eDP-1 --scale 1x1 &
ibus-daemon &
picom &

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

exec i3

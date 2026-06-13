#!/usr/bin/env bash

CONFIG="$HOME/.config/polybar/config.ini"
color=$(awk '
  $0 ~ /^\[module\/playerctl\]/ { in_section=1 }
  in_section && $0 ~ /^label-foreground/ {
    gsub(/[ \t]+/, "", $0); split($0, a, "="); print a[2]; exit
  }
' "$CONFIG")

color=${color:-#ffffff} # fallback

icon_color="%{F$color}"
reset_color="%{F-}"

playerctlstatus=$(playerctl status 2>/dev/null)
song=$(playerctl metadata title 2>/dev/null)
artist=$(playerctl metadata artist 2>/dev/null)

if [[ -z "$playerctlstatus" ]]; then
    echo ""
elif [[ "$playerctlstatus" =~ "Playing" ]]; then
    if [[ -z "$artist" ]]; then
        echo "%{A1:playerctl pause:}$icon_color$reset_color $song%{A}"
    else
        echo "%{A1:playerctl pause:}$icon_color$reset_color $artist - $song%{A}"
    fi
else
    echo "%{A1:playerctl play:}$icon_color$reset_color $artist - $song%{A}"
fi

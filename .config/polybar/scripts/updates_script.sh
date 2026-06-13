#!/bin/bash

APT=$(apt -o "Apt::Cmd::Disable-Script-Warning=true" --quiet --quiet list --upgradeable | \
  wc --lines)

good_color=#55aa55
bad_color=#aa5555

if [[ $APT == 0 ]]; then
  icon_color="%{F$good_color}"
  echo "$icon_color󰬬 up to date!%{F-}"
else
  icon_color="%{F$bad_color}"
  echo "$icon_color󰬬 $APT updates available%{F-}"
fi

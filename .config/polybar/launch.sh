polybar-msg cmd quit
killall -q polybar

echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log

if type "xrandr"; then
  for m in $(xrandr --query | grep " connected p" | cut -d" " -f1); do
    MONITOR=$m polybar --reload dabar &
  done

  for m in $(xrandr --query | grep " connected [^p]" | cut -d" " -f1); do
    MONITOR=$m polybar --reload others &
  done
else
  polybar --reload example &
fi

echo "Bars launched..."

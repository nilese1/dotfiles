#!/bin/bash

PIC_FILE="/tmp/screenshot.png"
NOTIFICATION_BODY="Screenshot saved to $PIC_FILE and copied to clipboard. Middle-click to open in feh"

# please don't make fun of me
if [[ ! -f "$PIC_FILE" ]]; then
	touch "$PIC_FILE"
fi
rm -f $PIC_FILE &

scrot -s $PIC_FILE

cat $PIC_FILE | xclip -selection clipboard -target image/png -i
ACTION=$(dunstify --icon=$PIC_FILE --action="default,Open" "Screenshot Taken" "$NOTIFICATION_BODY")

case "$ACTION" in
	"default")
		feh -d $PIC_FILE
esac


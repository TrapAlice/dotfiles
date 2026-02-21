#!/bin/sh

datetime="$(date +'%Y-%m-%d %H:%M:%S')"
calender=$(LC_TIME=C cal)
calender=${calender//$'\n'/$'\r'}
printf '{"text":"%s", "tooltip":"<tt>%s</tt>"}' "$datetime" "$calender"

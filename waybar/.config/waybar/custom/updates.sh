#|/usr/bin/env bash

MAX=10

updates=$(checkupdates 2>/dev/null)
count=$(printf "%s\n" "$updates" | sed '/^$/d' | wc -l)

if [[ "$1" == "update" ]]; then
	if [ "$count" -gt 0 ]; then
		$(ghostty -e sudo pacman -Syyu)
		exit
	fi
fi

if [ "$count" -eq 0 ]; then
	output="󰕥"
	colour="green"
	tooltip="No packages to be updated"
else
	list=$(printf "%s\n" "$updates" \
		| head -n "$MAX" \
		| awk '{print $1}')
	output=$(printf "%s %d" "" "$count")

	if [ "$count" -gt "$MAX" ]; then
		list="$list\n.. and $((count - MAX)) more"
	fi
	if [ "$count" -gt 25 ]; then
		colour="red"
	else
		colour="yellow"
	fi
	list=${list//$'\n'/$'\r'}
	tooltip=$(printf "%s" "$list")
fi

printf '{"text":"%s", "tooltip":"%s", "class":"%s"}' \
	"$output" "$tooltip" "$colour"

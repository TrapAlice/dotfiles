#!/usr/bin/env bash
tick=0

GLOBAL_STYLE='"separator_block_width": 20'

for f in "$HOME/.config/sway/swaybar-scripts/"*.sh; do
    . "$f"
done

declare -A values

printf '{ "version": 1}\n'
printf '[\n'

block() {
	local name="$1"
	local refresh="$2"

	if (( refresh == 0 )); then
		"$name"
		values["$name"]=$module_output
	fi
	printf '{"name": "%s", %s, %s},' \
		"$name" \
		"$GLOBAL_STYLE" \
		"${values[$name]}"
}

while true
do
	printf "["

	block net_speed
	block gpu_load $((tick % 5))
	block mem $((tick % 5))
	block cpu_usage $((tick % 2))
	block cpu_temp $((tick % 5))
	block weather
	block datetime

	printf "],\n"
	tick=$((tick+1))
    sleep 1
done

#!/bin/sh

cpu_temp() {
	module_output=$(printf '"full_text": "%s"' \
		" $(awk '{x += $1} END{ printf "%.2f", x / NR / 1000}' /sys/class/thermal/thermal_zone*/temp)°C")
}

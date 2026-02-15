#!/bin/sh

mem() {
	[ $((tick % 5)) -eq 0 ] && mem=$(awk '
    /^MemTotal:/ {t=$2}
    /^MemAvailable:/ {a=$2}
    END {
        used=(t-a)/1024
        total=t/1024
        pct=(a/t)*100
        printf "%d/%d (%.0f%%)", used, total, pct
	}' /proc/meminfo)
	module_output=$(printf '"full_text":"%s",' " $mem")
}

#!/bin/sh

mem=$(awk '
/^MemTotal:/     { t=$2 }
/^MemAvailable:/ { a=$2 }
END {
    used = t - a
    pct = (used / t) * 100
    printf "%d %d %.0f%%", used/1024, t/1024, pct
}' /proc/meminfo)

read -r used total pct <<< "$mem"

printf '{"text":" %s", "tooltip":"Total: %s MB\rUsed: %s MB"}' \
       "$pct" "$total" "$used"

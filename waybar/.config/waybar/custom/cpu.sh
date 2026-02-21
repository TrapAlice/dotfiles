cpu_usage() {
    read cpu user nice system idle iowait irq softirq steal _ < /proc/stat

    total=$((user + nice + system + idle + iowait + irq + softirq + steal))
    idle_total=$((idle + iowait))

    if [ -n "$prev_total" ]; then
        diff_total=$((total - prev_total))
        diff_idle=$((idle_total - prev_idle))

        usage=$(( (100 * (diff_total - diff_idle)) / diff_total ))
    else
        usage=0
    fi

    prev_total=$total
    prev_idle=$idle_total
	usage=$(printf '%s' "󰻠 $usage%")
}

cpu_temp() {
	temp=$(printf '%s' \
		" $(awk '{x += $1} END{ printf "%.2f", x / NR / 1000}' /sys/class/thermal/thermal_zone*/temp)°C")
}

while true
do
	cpu_usage
	cpu_temp
	printf '{"text": "%s %s"}\n' "$usage" "$temp"
	sleep 5
done

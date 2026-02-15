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
	module_output=$(printf '"full_text":"%s",' "󰻠 $usage%")
}


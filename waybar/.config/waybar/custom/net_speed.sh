#!/bin/sh

human_rate() {
    local bytes=$1
    if (( bytes > 1048576 )); then
        awk -v b="$bytes" 'BEGIN { printf "%.1fMB/s", b/1048576 }'
    else
        printf "%dKB/s" $(( bytes / 1024 ))
    fi
}

net_speed() {
    iface=$(ip route get 1.1.1.1 2>/dev/null | awk '{print $5; exit}')
    [ -z "$iface" ] && module_json='"full_text":"No Net"' && return

    rx=$(< /sys/class/net/$iface/statistics/rx_bytes)
    tx=$(< /sys/class/net/$iface/statistics/tx_bytes)

    if [[ -n $prev_rx ]]; then
        down=$(( (rx - prev_rx) ))
        up=$(( (tx - prev_tx) ))
    else
        down=0
        up=0
    fi

    prev_rx=$rx
    prev_tx=$tx

    # Convert to KB/s
	down_rate=$(human_rate $down)
	up_rate=$(human_rate $up)

    icon_down=$'\uf019'  # download icon
    icon_up=$'\uf093'    # upload icon

}

while true
do
	net_speed
	printf '{"text":"%s %s %s %s"}\n' \
        "$icon_down" "$down_rate" "$icon_up" "$up_rate"
	sleep 1
done


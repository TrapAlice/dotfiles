#!/bin/sh

read -r gpu mem mem_used mem_total < <(
	nvidia-smi \
		--query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total \
		--format=csv,noheader,nounits
	)
icon=$'󰢮'

mem=${mem//[^0-9]/}
mem_used=${mem_used//[^0-9]/}
mem_total=${mem_total//[^0-9]/}
mem_percent=$((mem_used * 100 / mem_total))

printf '{"text": "%s %d%% VRAM %d%%", "tooltip":"VRAM: %dMB/%dMB"}' "$icon" "$mem" "$mem_percent" "$mem_used" "$mem_total"


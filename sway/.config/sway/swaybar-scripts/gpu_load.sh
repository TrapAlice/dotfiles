#!/bin/sh

gpu_load() {
	read -r gpu mem mem_used mem_total < <(
		nvidia-smi \
            --query-gpu=utilization.gpu,utilization.memory,memory.used,memory.total \
            --format=csv,noheader,nounits
	)
	icon=$'󰢮'

	mem=${mem//[^0-9]/}
	mem_used=${mem_used//[^0-9]/}
	mem_total=${mem_total//[^0-9]/}

	module_output=$(printf '"full_text": "%s %d%% | VRAM %d/%d MiB"' "$icon" "$gpu" "$mem_used" "$mem_total")
}

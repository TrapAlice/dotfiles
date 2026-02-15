#!/usr/bin/env bash

weather() {
	cache=/tmp/weather.cache
	max_age=900
	if [[ ! -f $cache ]] || (( $(date +%s) - $(stat -c %Y "$cache") > max_age )); then
		(
			curl -s 'https://wttr.in/?format="%c+%t(%f)"' > "$cache"
		)&
	fi

	if [ -s "$cache" ]; then
		read -r weather < "$cache"
	else
		weather='"Loading.."'
	fi
	module_output=$(printf '"full_text":%s,' "$weather")
}

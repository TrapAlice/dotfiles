#!/usr/bin/env bash

declare -A weather_icon=(
[0]=""  #    Clear
[1]=""  #    Mostly Clear
[2]=""  #    Partly Cloudy
[3]=""  #    Cloudy
[45]="" #  Fog
[48]="" #  Freezing Fog
[51]="" #  Light Drizzle
[53]="" #  Drizzle
[55]="" #  Heavy Drizzle
[56]="" #  Light Freezing Drizzle
[57]="" #  Freezing Drizzle
[61]="" #  Light Rain
[63]="" #  Rain
[65]="" #  Heavy Rain
[66]="" #  Light Freezing Rain
[67]="" #  Freezing Rain
[71]="" #  Light Snow
[73]="" #  Snow
[75]="" #  Heavy Snow
[77]="" #  Snow Grains
[80]="" #  Light Rain Shower
[81]="" #  Rain Shower
[82]="" #  Heavy Rain Shower
[85]="" #  Snow Shower
[86]="" #  Heavy Snow Shower
[95]="" #  Thunderstorm
[96]="" #  Hailstorm
[99]="" #  Heavy Hailstorm
)

cache=/tmp/weather.cache
max_age=3600
if [[ ! -f $cache ]] || (( $(date +%s) - $(stat -c %Y "$cache") > max_age )); then
	(
		curl -s 'https://api.open-meteo.com/v1/forecast?latitude=35.6764&longitude=139.65&hourly=temperature_2m,precipitation_probability,apparent_temperature,weather_code&timezone=Asia%2FTokyo&forecast_days=3' > "$cache"
		)&
fi

if [ -s "$cache" ]; then
	index=$(date +"%H")
	results=$(jq -r -j --arg index $index '
	.hourly as $h
	| $index | tonumber as $index
	| range($index; $index+13; 6)
	| "\($h.temperature_2m[.]) \($h.apparent_temperature[.]) \($h.precipitation_probability[.]) \($h.weather_code[.]) "
	' "$cache")
	entries=()
	read -r temp feels_like rain_chance code \
		temp6h feels_like6h rain_chance6h code6h \
		temp12h feels_like12h rain_chance12h code12h \
		<<< "$results"
	(( rain_chance > 20 )) && rain="(${rain_chance}%) " || rain=""
	(( rain_chance6h > 20 )) && rain6h="(${rain_chance6h}%) " || rain6h=""
	(( rain_chance12h > 20 )) && rain12h="(${rain_chance12h}%) " || rain12h=""
	weather="$(printf " %s %s°C (%s°C) %s" \
		"${weather_icon[$code]}" "$temp" "$feels_like" "$rain" \
		)"
	tooltip="$(printf "%s %s°C %s \r%s %s°C %s" \
		"${weather_icon[$code6h]}" "$temp6h" "$rain6h" \
		"${weather_icon[$code12h]}" "$temp12h" "$rain12h" \
		)"
else
	weather='"Loading.."'
	tooltip='"Loading.."'
fi
printf '{"text":"%s", "tooltip" : "%s"}' "$weather" "$tooltip"

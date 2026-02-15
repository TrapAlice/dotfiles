#!/bin/sh

datetime() {
	datetime="$(date +'%Y-%m-%d %H:%M:%S')"
	module_output=$(printf '"full_text":"%s",' "$datetime")
}

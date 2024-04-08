#!/bin/sh

tool_exists () {
	which "$1" >/dev/null 2>/dev/null
}

if tool_exists curl; then
	curl -o "$path" "$url"
elif tool_exists wget; then
	wget -O "$path" "$url"
elif tool_exists ftp; then
	# TODO: test this code path on GNU/Linux. Do ftp client on GNU/Linux
	# work like we expect?
	ftp -o "$path" "$url"
else
	echo 'No download tool found' >&2
	exit 1
fi

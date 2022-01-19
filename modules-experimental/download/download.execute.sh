#!/bin/sh
if which wget >/dev/null; then
	wget -O "$path" "$url"
elif which ftp >/dev/null; then
	ftp -o "$path" "$url"
else
	echo 'No download tool found' >&2
	exit 1
fi

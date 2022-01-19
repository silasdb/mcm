#!/bin/sh

/bin/mkdir -p "$path"

if [ -n "${owner+x}" ]; then
	# TODO: -R -> recursive?
	/sbin/chown -R "$owner" "$path"
fi

if [ -f "${mode+x}" ]; then
	# TODO: -R -> recursive?
	/bin/chmod -h "$mode" "$path"
fi

#!/bin/sh
test -h "$target" || exit 1
if [ "$(stat -f %Y "$target")" != "$source" ]; then
	exit 1
fi

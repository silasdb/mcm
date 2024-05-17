#!/bin/sh
test -h "$target" || exit 1
if [ "$(readlink "$target")" != "$source" ]; then
	exit 1
fi

#!/bin/sh
test -h "$target" || exit 1
# TODO: should we canonize both $target and $source before comparing them?
if [ "$(readlink "$target")" != "$source" ]; then
	exit 1
fi

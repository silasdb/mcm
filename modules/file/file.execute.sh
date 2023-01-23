#!/bin/sh

: ${force:='yes'}

# TODO: What if $path is a symlink?
if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	echo "$content" > "$path"
fi

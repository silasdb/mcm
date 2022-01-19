#!/bin/sh

: ${force:='yes'}

if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	echo "$content" > "$path"
fi

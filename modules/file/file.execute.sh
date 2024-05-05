#!/bin/sh

: ${force:='yes'}

# TODO: What if $path is a symlink?
if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	# TODO: test echo vs printf for cases where both origin and target have
	# the same content, except if the last character in the file is "\n".
	echo "$content" > "$path"
fi

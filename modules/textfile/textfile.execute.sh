#!/bin/sh

: ${force:='yes'}
: ${eofchar='\n'}

# TODO: What if $path is a symlink?
if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	printf "%s$eofchar" "$content" > "$path"
fi

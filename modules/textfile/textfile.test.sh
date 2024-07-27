#!/bin/sh

: ${force:='yes'}
: ${eofchar:='\n'}

# content is optional (one may want to set file permissions only).  If content
# is set, we check if the file does not exist OR if $force flag is set.
if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	printf "%s$eofchar" "$content" | cmp -s - "$path"
fi


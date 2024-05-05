#!/bin/sh

: ${force:='yes'}

# content is optional (one may want to set file permissions only).  If content
# is set, we check if the file does not exist OR if $force flag is set.
if [ -n "${content+x}" -a \( ! -f "$path" -o "$force" = 'yes' \) ]; then
	# TODO: test echo vs printf for cases where both origin and target have
	# the same content, except if the last character in the file is "\n".
	echo "$content" | cmp -s - "$path"
fi


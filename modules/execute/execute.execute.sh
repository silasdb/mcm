#!/bin/sh

: ${shell:='no'}

test -n "${execute+x}" || exit 1

if [ "$shell" = 'yes' ]; then
	eval "$execute"
else
	eval exec "$execute"
fi

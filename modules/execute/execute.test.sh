#!/bin/sh

: ${shell:='no'}

test -n "${test+x}" || exit 1

if [ "$shell" = 'yes' ]; then
	eval "$test"
else
	eval exec "$test"
fi

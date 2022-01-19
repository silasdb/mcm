#!/bin/sh

: ${creates:=''}

if [ -n "$creates" -a -d "$creates" ]; then
	exit 0
fi

exit 1

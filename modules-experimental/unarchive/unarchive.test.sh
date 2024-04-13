#!/bin/sh

: ${creates:=''}

if [ -e "$creates" ]; then
	exit 0
fi

exit 1

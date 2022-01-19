#!/bin/sh
if [ "$status" = 'started' ]; then
	service "$name" status | grep -q 'is running'
fi

if [ "$status" = 'stopped' ]; then
	service "$name" status | grep -q 'is not running'
fi

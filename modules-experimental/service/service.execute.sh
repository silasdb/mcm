#!/bin/sh
if [ "$status" = 'started' ]; then
	service "$name" start
fi

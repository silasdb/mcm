#!/bin/sh
# TODO: -A is not POSIX

uflag=
if [ -n "${user+x}" ]; then
	uflag="-u ${user}"
fi

crontab $uflag -l \
	| grep -x -F -A 2 "# MCM: $name" \
	| head -n 2 \
	| tail -n 1 \
	| grep -x -F -q "$time_spec $job"

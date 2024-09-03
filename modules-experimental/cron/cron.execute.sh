#!/bin/sh

# TODO: don't use $PWD here. Create a temporary directory instead.
# TODO: check if time_spec is set?

uflag=
if [ -n "${user+x}" ]; then
	uflag="-u ${user}"
fi

{
	# Remove current entry, if it exists.
	crontab -l | sed -n "
		:begin
			# TODO: what if $name has a slash?
			/^# MCM: $name\$/ b found
			p
			n
			b begin
		:found
			n
	"
	echo "# MCM: $name"
	echo "$time_spec $job"
} | crontab -

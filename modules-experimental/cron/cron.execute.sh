#!/bin/sh

# TODO: don't use $PWD here. Create a temporary directory instead.
# TODO: check if time_spec is set?

uflag=
if [ -n "${user+x}" ]; then
	uflag="-u ${user}"
fi

# If such entry doesn't exist in crontab, just append it.
if ! crontab $uflag -l | grep -q -x -F "# MCM: $name"; then
	# If the register is not added, just appends it at the end of the
	# crontab.
	{
		crontab -l
		echo "# MCM: $name"
		echo "$time_spec $job"
	} | crontab -
	exit
fi

# If entry exists in crontab, replace it.
{
	# TODO: what if $name has a slash?
	crontab -l | sed -n "
		:begin
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

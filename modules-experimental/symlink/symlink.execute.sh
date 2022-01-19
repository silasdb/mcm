#!/bin/sh

# TODO: what if mcm pass the -source parameter as path relative to the current
# mcm file, and not relative to the -target parameter?

: ${force:=no}

if [ "$force" = 'no' ]; then
	f_flag=''
else
	f_flag='-f'
fi

test ! -e "$target" -o -h "$target" || {
	echo "$target exists and is not a symlink"
	exit 1
}


# Remove symlink in advance.  If we don't do this and it points to a directory,
# the new symlink will be created inside this directory!  Some implementations
# of ln(1) implement the -h flag for that, but it is not POSIX as of POSIX 2018.
#
# TODO: update: use -h anyway?
rm -f "$target"

/bin/ln -s $f_flag "$source" "$target"

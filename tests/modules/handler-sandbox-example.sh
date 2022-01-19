#!/bin/sh
case "$1" in
create)
	# do nothing
	;;
destroy)
	# do nothing
	;;
sh)
	PATH="$testdir/mocks:$PATH" MCM_OPTIONS='-x -v' sh -eu
	;;
esac

#!/bin/sh

: ${dest:=.}
cd "$dest"

ext="${src#*.}"

case "$ext" in
# TODO: zip
gz|bz2)
	tar zxvf "$src" -C "$dest"
	;;
xz)
	unxz --decompress --stdout "$src" | tar xf - -C "$dest"
	;;
*)
	echo >&2 "unarchive module cannot handle \"$ext\" extension."
	exit 1
	;;
esac

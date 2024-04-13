#!/bin/sh

: ${dest:=.}
cd "$dest"

case "$src" in
# TODO: zip
*.tar.gz|*.tar.bz2)
	tar zxvf "$src" -C "$dest"
	;;
*.tar.xz)
	unxz --decompress --stdout "$src" | tar xf - -C "$dest"
	;;
*)
	echo >&2 "unarchive module cannot discover \"$src\" file format."
	exit 1
	;;
esac

: ${make:=make}
: ${target:=''}
if [ -n "${path+x}" ]; then
	cd "$path"
fi
if [ -z "${makefile+x}" ]; then
	makefile="$(cat Makefile)"
fi
echo "$makefile" | "$make" -f - -q $target

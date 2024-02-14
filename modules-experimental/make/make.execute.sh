: ${make:=make}
: ${target:=''}
if [ -n "${path+x}" ]; then
	cd "$path"
fi
echo "$makefile" | "$make" -f - $target

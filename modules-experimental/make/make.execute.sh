: ${make:=make}
: ${target:=''}
if [ -n "${path+x}" ]; then
	cd "$path"
fi
echo "$content" | "$make" -f - $target

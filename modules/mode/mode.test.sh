test -e "$path" || exit 1

case "$(uname)" in
Linux)
	p="$(stat -c %a "$path")"
	if [ ${#p} -eq 3 ]; then
		p="0$p"
	fi
	;;
*)
	p="$(stat -f %p "$path")"
	if [ ${#p} -eq 6 ]; then
		p="${p#??}"
	elif [ ${#p} -eq 5 ]; then
		p="${p#?}"
	fi
	;;
esac

# If the user specify a mode with three numbers, prepend 0 (zero) to it
# to make it compatible with stat_perms function output.
# So, a file or directory with permissions 755 is just 0755.
if [ "${#mode}" -eq 3 ]; then
	mode="0$mode"
fi
test x"$p" = x"$mode"


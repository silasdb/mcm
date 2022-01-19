#!/bin/sh

test -d "$path"

#if [ -n "${owner+x}" ]; then
#	test "$(stat -f %Su "$path")" = "$owner"
#fi
#
#if [ -n "${owner+x}" ]; then
#	test "$(stat -f %Su "$path")" = "$owner"
#fi
#
#stat_perms () {
#	local p
#	case "$(uname)" in
#	Linux)
#		p=$(stat -c %a "$@")
#		if [ ${#p} -eq 3 ]; then
#			p="0$p"
#		fi
#		;;
#	*)
#		p="$(stat -f %p "$@")"
#		if [ ${#p} -eq 6 ]; then
#			p="${p#??}"
#		elif [ ${#p} -eq 5 ]; then
#			p="${p#?}"
#		fi
#		;;
#	esac
#	echo "$p"
#}
#
#if [ -n "${mode+x}" ]; then
#	# If the user specify a mode with three numbers, prepend 0 (zero) to it
#	# to make it compatible with stat_perms function output.
#	# So, a file or directory with permissions 755 is just 0755.
#	if [ "${#mode}" -eq 3 ]; then
#		mode="0$mode"
#	fi
#	test "$(stat_perms "$path")" = "$mode"
#fi

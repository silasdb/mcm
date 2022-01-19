#!/bin/sh

# crontab(1) calls your favorite editor (by reading the contents of environment
# variable $EDITOR).  After the user quits the editor, crontab(1) verifies if
# any change was made (the NetBSD version of crontab checks for time update
# only, not contents update) and, if there are changes, the new crontab is
# installed.
#
# Therefore this script fakes an editor, creating a non interactive script that
# can change a crontab and setting the EDITOR variable to it.

# TODO: check if time_spec is set?

uflag=
if [ -n "${user+x}" ]; then
	uflag="-u ${user}"
fi

quote ()
{
	local q="$*"
	q="$(printf "%s" "$*" | sed "s/'/'\\\''/g")"
	printf "'%s'" "$q"
}

# We first look fo the job existance by looking for its name.
if ! crontab $uflag -l | grep -q -x -F "# MCM: $name"; then
	# If the register is not added, just appends it at the end of the
	# crontab.
	cat >fakeeditor <<-EOF
		#!/bin/sh
		echo '# MCM: $name' >> "\$1"
		echo $(quote "$time_spec") $(quote "$job") >> "\$1"
	EOF
else
	n="$(crontab $uflag -l | grep -n -x -F "# MCM: $name" | head -n 1 | cut -f1 -d:)"
	n="$((n+1))"

	# If the register already exists (we discovered because we looked for
	# its name) but the job part is different from the desired, we need to
	# change only that line.  This can be easily achieved by an AWK script.
	#
	# Before this AWK script, we used to use sed -i but it wasn't work.
	# This is because sed -i (at least the NetBSD implementation) actually creates
	# another file and rename it back to the original name, i.e., it is a
	# *new* file.  The crontab(1) program (at least the NetBSD
	# implementation) trusts that the program will not change the file (it
	# probably keeps the file descriptor opened).
	#
	# We then decided to write it to a temporary file ($PWD/crontab.tmp) and
	# cat it into the crontab file (\$1).  It seems the shell redirection
	# does use the same file to put/append contents.  Later, we replaced the
	# sed program to an AWK program for readability.
	#
	# The behaviour of crontab(1) and sed -i may change for other UNIX
	# systems, but we believe we have a portable solution now.
	#
	# awk process backslashes passed via -v, because of that
	# we pass time_spec and job via environment variables.
	# See
	# https://unix.stackexchange.com/questions/542560/prevent-awk-from-removing-backslashes-in-variable
	# as example.
	cat >fakeeditor <<-EOF
		#!/bin/sh
		export time_spec=$(quote "$time_spec")
		export job=$(quote "$job")
		awk -v n=$n '
		NR == n {
			print ENVIRON["time_spec"] " " ENVIRON["job"]
		}
		NR != n {
			print \$0
		}
		' "\$1" > "$PWD/crontab.tmp"
		cat "$PWD/crontab.tmp" > "\$1"
		rm "$PWD/crontab.tmp"
	EOF
fi

# We set EDITOR variable to our fakeeditor script so crontab thinks we are using
# a real interactive editor.
#
# A note on "| head -n 10 > fakeeditor.out" and the grep block just after it: on
# NetBSD, if there is any error on the crontab, crontab tells the user there is
# an error (it outputs 'errors in crontab file') and asks the user if she wants
# to retry the same edit, but it waits for input on the terminal:
#
#	Do you want to retry the same edit? Enter Y or N
#
# Since we are not interactive (and we can't handle terminal -- this is one of
# the mcm goeals), it prints it again asking the user to Enter either Y or N.
# It gets stuck in a loop and prints this message infinitely.  So we just filter
# the first 10 lines (to finish the endless messages) and check (with grep) if
# there is any message indicating there was an error.  If yes, show the errors
# to the user and exit.
#
# TODO: verify this behaviour under GNU/Linux
chmod 755 fakeeditor
EDITOR="$PWD/fakeeditor" crontab $uflag -e 2>&1 \
	| head -n 10 > fakeeditor.out
grep -q 'errors in crontab file' fakeeditor.out && {
	cat fakeeditor.out >&2
	rm fakeeditor
	rm fakeeditor.out
	exit 1
}

rm fakeeditor
rm fakeeditor.out

#!/bin/sh

# TODO: Current problems with this module:
#
# * markers are not customized
#
# * when modifying the block, it deletes the original one and add it to the end
#   of the file

sponge () {
	x=$(cat)
	echo "$x" > "$1"
}

sed -n '
:start
/^# MCM BLOCK BEGIN$/b inblock
p
n
b start

:inblock
/^# MCM BLOCK END$/b afterblock
n
b inblock

:afterblock
n

:loop
p
n
b loop
' < "${path}" | {
	cat
	echo '# MCM BLOCK BEGIN'
	echo "$block"
	echo '# MCM BLOCK END'
} | sponge "${path}"

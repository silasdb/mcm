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

remove_block_from_file () {
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
	' "$1"
}

append_block_to_stdin () {
	cat
	echo '# MCM BLOCK BEGIN'
	echo "$block"
	echo '# MCM BLOCK END'
}

remove_block_from_file "${path}" | append_block_to_stdin | sponge "${path}"

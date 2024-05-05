#!/bin/sh
set -eu

trap cleanup 0 HUP INT QUIT TERM
cleanup ()
{
	test -f "$tmp" && rm "$tmp"
}

tmp="$(mktemp /tmp/.mcm.test-module-help.XXXXXX)"
../../mcm -M modules/ -h dummy_module > "$tmp" 2>/dev/null
diff "$tmp" modules/dummy_module/dummy_module.rst

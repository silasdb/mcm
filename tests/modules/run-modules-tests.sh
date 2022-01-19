#!/bin/sh

set -eu

# TODO: difference between both
testdir=
tmpdir=

MCMHOME="$(readlink -f "$(dirname "$0")/../..")"

passed=0
failed=0

usage () {
	echo "usage: $0 tests..." >&2
	echo "       $0 [-s sandbox_handler.sh] tests..." >&2
	exit 1
}

run_sh_local ()
{
	PATH="$testdir/mocks:$PATH" MCM_OPTIONS='-x -v' sh -eu
}

# $1 -> prefix (the test directory - e.g.: module/tests/a_test)
# $2 -> whether or not we should run the code in a sandbox ('yes' or 'no')
do_test ()
{
	local prefix="$1"
	local sandbox="$2"

	run_sh=run_sh_local
	if [ "$sandbox" = 'yes' ]; then
		run_sh="sh $sandbox_handler sh"
	fi

	cd "$prefix"

	test "$sandbox" = 'yes' && sh "$sandbox_handler" create

	test="$(basename "$prefix")"
	testdir="$(echo 'mktemp -d /tmp/.mcm.testdir.XXXX' | $run_sh)"
	test -n "$testdir" # Because last command can fail if ssh fails
	tmpout="$(mktemp /tmp/.mcm.test.out.XXXX)"
	t="$(basename "$prefix")"
	mcm_in="${test}.mcm.in"
	sh_in="${test}.sh.in"

	ret=0

	if [ "$sandbox" = 'no' ]; then
		if [ -f "$t.pre-local.sh.in" ]; then
			sed "s|@testdir@|$testdir|g" "$t.pre-local.sh.in" \
			    | $run_sh
		fi
	else
		if [ -f "$t.pre-sandbox.sh" ]; then
			cat "$t.pre-sandbox.sh" | $run_sh
		fi
	fi

	sed "s|@testdir@|$testdir|g" "$mcm_in" \
	    | "$MCMHOME/mcm" | $run_sh > "${tmpout}" 2>&1 || ret=$?
	if [ $ret -eq 0 -a -f "$sh_in" ]; then
		sed "s|@testdir@|$testdir|g" "$sh_in" \
		    | $run_sh || ret=$?
	fi

	if ! cmp -s "${test}.out" "${tmpout}"; then
		! diff -u "${test}.out" "${tmpout}"
		ret=1
	fi
	echo "rm -rf \"$testdir\"" | $run_sh
	rm "$tmpout"
	test "$sandbox" = 'yes' && sh "$sandbox_handler" destroy
	cd -
	return $ret
}

if [ "$#" -eq 0 ]; then
	usage
fi

sandbox=no
if [ "${1}" = '-s' ]; then
	if [ "$#" -lt 3 ]; then
		usage
	fi
	sandbox_handler="$(readlink -f "$2")"
	shift 2
	sandbox=yes
fi

if [ "$#" -eq 0 ]; then
	usage
fi

for prefix in "$@"; do
	test="$(basename "$prefix")"
	module="$(basename "$(dirname "$(dirname "$prefix")")")"
	do_test "$prefix" "$sandbox" && {
		passed=$((passed+1))
		echo ":-) "$module/tests/$test" passed"
	} || {
		failed=$((failed+1))
		echo ":-( "$module/tests/$test" failed"
	}
done

echo "Failed: $failed	Passed: $passed"

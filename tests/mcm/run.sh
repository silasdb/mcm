#!/bin/sh

set -eu

export LANG=en_US

# This variable cannot be SHELL because some shells (like zsh) set it to the
# user shell.
: ${SH:=/bin/sh}

tmpdir="$(mktemp -d /tmp/.mcm.test.XXXX)"
trap "rm -rf $tmpdir" 0 HUP INT QUIT TERM

MCMHOME="$(readlink -f "$(dirname "$0")/../..")"
MCM="${MCMHOME}/mcm"

cd "${MCMHOME}/tests/mcm"

passed=0
failed=0

if [ $# -eq 0 ]; then
	files=$(echo *.mcm test*.sh)
else
	files="$@"
fi

for t in $files; do
case "$t" in
*.mcm)
	t="${t%.mcm}"
	${SH} "$MCM" -M modules "$t.mcm" 2> "$tmpdir/mcm_test_err" \
		| MCM_OPTIONS='-v' ${SH} \
		> "$tmpdir/test_out" 2>"$tmpdir/test_err" \
		&& test_ret=$? || test_ret=$?
	${SH} "$MCM" -M modules "$t.mcm" 2> "$tmpdir/mcm_execute_err" \
		| MCM_OPTIONS='-x -v' ${SH} \
		> "$tmpdir/execute_out" 2>"$tmpdir/execute_err" \
		&& execute_ret=$? || execute_ret=$?

	# Set default values
	: ${expected_mcm_test_err:=''}
	: ${expected_mcm_execute_err:=''}
	: ${expected_test_out:=''}
	: ${expected_test_err:=''}
	: ${expected_test_ret:=0}
	: ${expected_execute_out:=''}
	: ${expected_execute_err:=''}
	: ${expected_execute_ret:=0}

	. "./$t.results"

	# We write expected_out and expected_err to files, but before that we
	# discard first and last lines, which are empty lines, because, on
	# *.results file, we use the following syntax to make things easier when
	# for using multi lines:
	#
	# 	expected_out='
	# 	foo
	# 	'

	echo "$expected_mcm_execute_err" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_mcm_execute_err"
	echo "$expected_mcm_test_err" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_mcm_test_err"
	echo "$expected_test_out" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_test_out"
	echo "$expected_test_err" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_test_err"
	echo "$expected_execute_out" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_execute_out"
	echo "$expected_execute_err" | sed -n -e '$d' -e '2,$p' \
		> "$tmpdir/expected_execute_err"

	this_failed=0
	diff -u "$tmpdir/expected_mcm_test_err" "$tmpdir/mcm_test_err" || this_failed=1
	diff -u "$tmpdir/expected_mcm_execute_err" "$tmpdir/mcm_execute_err" || this_failed=1
	diff -u "$tmpdir/expected_test_out" "$tmpdir/test_out" || this_failed=1
	diff -u "$tmpdir/expected_test_err" "$tmpdir/test_err" || this_failed=1
	test "$test_ret" -eq "$expected_test_ret" || {
		this_failed=1
		echo "Return value for test ($test_ret) different than expected ($expected_test_ret)"
	}
	diff -u "$tmpdir/expected_execute_out" "$tmpdir/execute_out" || this_failed=1
	diff -u "$tmpdir/expected_execute_err" "$tmpdir/execute_err" || this_failed=1
	test "$execute_ret" -eq "$expected_execute_ret" || {
		this_failed=1
		echo "Return value for execute ($execute_ret) different than expected ($expected_execute_ret)"
	}

	if [ $this_failed -eq 0 ]; then
		passed=$((passed+1))
		echo ":-) $t passed"
	else
		failed=$((failed+1))
		echo ":-( $t failed"
	fi

	unset expected_mcm_test_err
	unset expected_mcm_execute_err
	unset expected_test_out
	unset expected_test_err
	unset expected_test_ret
	unset expected_execute_out
	unset expected_execute_err
	unset expected_execute_ret
	;;
*.sh)
	ret=0
	sh "$t" || ret=$?
	t="${t%.sh}"
	if [ "$ret" -eq 0 ]; then
		passed="$((passed+1))"
		echo ":-) $t passed"
	else
		failed="$((failed+1))"
		echo ":-( $t failed"
	fi
	;;
esac
done

echo "Failed: $failed	Passed: $passed"

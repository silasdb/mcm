#!/bin/sh

set -eu

trap cleanup 0 HUP INT QUIT TERM
cleanup ()
{
	test -f "$mcm" && rm "$mcm"
	test -f "$out" && rm "$out"
	test -f "$err" && rm "$err"
	test -f "$tmp" && rm "$tmp"
	test -d "$tmpdir" && rmdir "$tmpdir"
}

xdiff_counter=1 # for better identify what test failed
xdiff ()
{
	echo "$1" > "$tmpdir/tmp"
	diff -u "$tmpdir/tmp" "$2" || {
		echo "the test that failed is: $xdiff_counter"
		exit 1
	}
	xdiff_counter=$((xdiff_counter+1))
}

tmpdir="$(mktemp -d /tmp/.mcm.test.XXXXXX)"
mcm="$tmpdir/mcm"
out="$tmpdir/out"
err="$tmpdir/err"
tmp="$tmpdir/tmp"

#
# Testing a module if the execute phase is [changed]
#

cat > "$mcm" <<EOF
name dummy_module \
task dummy_module \
	-test_out test_out \
	-test_err test_err \
	-test_ret 1 \
	-execute_out execute_out \
	-execute_err execute_err \
	-execute_ret 0
EOF

# verbose: 0
# stderr is always shown.  stdout is not.
../../mcm -M modules "$mcm" | MCM_OPTIONS='-x' sh > "$out" 2>"$err"
# test 1
xdiff 'dummy_module => [changed]
ok: 0	changed: 1' "$out"
test -s "$err"

# verbose: 1
# Always show both stderr and stdout.
../../mcm -M modules "$mcm" | MCM_OPTIONS='-x -v' sh >"$out" 2>"$err"
# test 2
xdiff 'dummy_module test_out
execute_out
=> [changed]
ok: 0	changed: 1' "$out"
# test 3
xdiff 'test_err
execute_err' "$err"

# verbose: 2
# Show stderr and stdout of both test and execute phases and shell tracing.
../../mcm -M modules "$mcm" | MCM_OPTIONS='-x -vv' sh >"$out" 2>"$err"
# test 4
xdiff 'dummy_module test_out
execute_out
=> [changed]
ok: 0	changed: 1' "$out"
# test 5
xdiff "+ '[' 2 -eq 0 ']'
+ test -n x
+ printf '%s\n' test_out
+ test -n x
+ printf '%s\n' test_err >&2
test_err
+ exit 1
+ '[' 2 -eq 0 ']'
+ ':' 0
+ test -n x
+ printf '%s\n' execute_out
+ test -n x
+ printf '%s\n' execute_err >&2
execute_err
+ exit 0" "$err"

cat > "$mcm" <<EOF
name dummy_module \
task dummy_module \
	-test_out test_out \
	-test_err test_err \
	-test_ret 1 \
	-execute_out execute_out \
	-execute_err execute_err \
	-execute_ret 1
EOF

#
# Testing a module if the execute phase is [error]
#

# verbose: 0
# Always show stderr.
! ../../mcm -M modules "$mcm" | MCM_OPTIONS='-x' sh > "$out" 2>"$err"
# test 6
xdiff 'dummy_module => [error]' "$out"
# test 7
xdiff 'test_err
execute_err' "$err"

# verbose: 1
# Always show stderr and stdout.
! ../../mcm -M modules "$mcm" | MCM_OPTIONS='-x -v' sh >"$out" 2>"$err"
# test 8
xdiff 'dummy_module test_out
execute_out
=> [error]' "$out"
# test 9
xdiff 'test_err
execute_err' "$err"

# verbose: 2
# Show stdout and stderr of both test and execute phases and shell tracing.
! ../../mcm -M modules "$mcm" | MCM_OPTIONS='-x -vv' sh >"$out" 2>"$err"
# test 10
xdiff 'dummy_module test_out
execute_out
=> [error]' "$out"
# test 11
xdiff "+ '[' 2 -eq 0 ']'
+ test -n x
+ printf '%s\n' test_out
+ test -n x
+ printf '%s\n' test_err >&2
test_err
+ exit 1
+ '[' 2 -eq 0 ']'
+ ':' 1
+ test -n x
+ printf '%s\n' execute_out
+ test -n x
+ printf '%s\n' execute_err >&2
execute_err
+ exit 1" "$err"

#!/bin/sh

test -n "${test_out+x}" && echo "$test_out"
test -n "${test_err+x}" && echo "$test_err" >&2

# A comment with string "\n" can break mcm, as mcm will expand modules content
# to "<a new line>", so a newline that starts with character >"< is appended,
# which is a syntax error. We add this comment here to reproduce this error and
# fix it in mcm. Note that it comes before exit, because nothing after exit is
# executed, right or wrong. This happens in some shells, like OpenBSD /bin/sh,
# because `echo` expands escaping characters. The solution is to use printf
# whenever consistency is expected.

exit "$test_ret"

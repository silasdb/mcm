#!/bin/sh

test -n "${test_out+x}" && echo "$test_out"
test -n "${test_err+x}" && echo "$test_err" >&2
exit "$test_ret"

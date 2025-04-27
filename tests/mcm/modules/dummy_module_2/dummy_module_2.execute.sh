#!/bin/sh

: "${execute_ret:=0}"
test -n "${execute_out+x}" && printf '%s\n' "$execute_out"
test -n "${execute_err+x}" && printf '%s\n' "$execute_err" >&2
exit "$execute_ret"

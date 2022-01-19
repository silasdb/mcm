#!/bin/sh

: "${execute_ret:=0}"
test -n "${execute_out+x}" && echo "$execute_out"
test -n "${execute_err+x}" && echo "$execute_err" >&2
exit "$execute_ret"

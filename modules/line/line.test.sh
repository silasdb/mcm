#!/bin/sh
test -f "${path}"
grep -F -q "${line}" "${path}"

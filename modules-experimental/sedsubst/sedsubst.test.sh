#!/bin/sh
# TODO: check if file exists
! grep -E -q "$regexp" "$path"

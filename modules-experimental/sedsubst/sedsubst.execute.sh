#!/bin/sh
: "${char:=/}"
: "${sedoptions:=}"
sed -E -i "s$char$regexp$char$replacement$char$sedoptions" "$path"

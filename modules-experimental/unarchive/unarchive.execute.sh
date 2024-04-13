#!/bin/sh

# TODO: check for other suffix other than .tar.gz

: ${dest:=.}
cd "$dest"
tar zxvf "$src"

#!/bin/sh

: ${pkg_path:="http://cdn.NetBSD.org/pub/pkgsrc/packages/$(uname -s)/$(uname -m)/$(uname -r|cut -f '1 2' -d.)/All/"}

PKG_PATH="${pkg_path}" pkg_add "$name"

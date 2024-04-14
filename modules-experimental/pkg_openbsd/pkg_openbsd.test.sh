#!/bin/sh
# TODO: not the best way to check for the existence of a package, since it is
# ambiguous. E.g.: both foo and foo-bar are matched.
test -d "/var/db/pkg/$name"*

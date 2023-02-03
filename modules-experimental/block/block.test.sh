#!/bin/sh

sed_extract_block=''

test x"$(sed -n '
:start
/^# MCM BLOCK BEGIN$/b startblock
n
b start

:startblock
n

:inblock
/^# MCM BLOCK END$/b end
p
n
b inblock
:end
q
' < "${path}")" = x"${block}"

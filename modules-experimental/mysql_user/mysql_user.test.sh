#!/bin/sh
: ${login_user:=root}
: ${login_port:=3306}
: ${login_host:=localhost}
: ${host:=localhost}

connect_timeout=30

n="$(mysql -N -B -h "$login_host" \
	-P "$login_port" \
	-u "$login_user" \
	-p"$login_password" \
	--connect_timeout=30 \
	-e "SELECT count(*) FROM mysql.user WHERE user = '$name'";)"

test "$n" -eq 1

#!/bin/sh
: ${login_user:=root}
: ${login_port:=3306}
: ${login_host:=localhost}
: ${host:=localhost}

connect_timeout=30

mysql_execute ()
{
	mysql -N -B -h "$login_host" \
		-P "$login_port" \
		-u "$login_user" \
		-p"$login_password" \
		--connect_timeout=30 \
		-e "$*"
}

mysql_execute "CREATE USER '$name'@'$host' IDENTIFIED BY '$password'"

if [ -n "$priv" ]; then
	# TODO: parse "$priv" correctly like Ansible does
	mysql_execute "GRANT ALL PRIVILEGES ON $priv TO '$name'@'$host'"
	mysql_execute "FLUSH PRIVILEGES"
fi


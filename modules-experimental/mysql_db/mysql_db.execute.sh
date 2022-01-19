#!/bin/sh

: ${login_user:=root}
: ${login_port:=3306}
: ${login_host:=localhost}

connect_timeout=30

# TODO: what other parameters like ansible?
# https://docs.ansible.com/ansible/latest/modules/mysql_db_module.html

mysql -N -B -h "$login_host" \
	-P "$login_port" \
	-u "$login_user" \
	-p"$login_password" \
	--connect_timeout=30 \
	-e "CREATE DATABASE $name";

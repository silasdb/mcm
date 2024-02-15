# TODO: handle case where $HOME is not necessary
# TODO: what about passing a password?

which useradd && {
	if [ -n "${home+x}" ]; then
		useradd -m -d "$home" "$username"
	else
		useradd -m "$username"
	fi
	exit
}

which adduser && {
	# -D: don't assign a password
	if [ -n "${home+x}" ]; then
		adduser -D -h "$home" "$username"
	else
		adduser -D "$username"
	fi
	exit
}

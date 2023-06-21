#!/bin/sh

# create runtime directory
if [ -d "/run/mysqld" ]; then
	echo "[i] mysqld already present, skipping creation"
	chown -R mysql:mysql /run/mysqld
else
	echo "[i] mysqld not found, creating...."
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

# create mysql directory
if [ -d /var/lib/mysql/mysql ]; then
	echo "[i] MySQL directory already present, skipping creation"
	chown -R mysql:mysql /var/lib/mysql
else
	echo "[i] MySQL data directory not found, creating initial DBs"
	chown -R mysql:mysql /var/lib/mysql

	# init db
	mysql_install_db --user=mysql --ldata=/var/lib/mysql > /dev/null

	# set user info
	MYSQL_ROOT_PASSWORD=${MYSQL_ROOT_PASSWORD:-""}
	MYSQL_DATABASE=${MYSQL_DATABASE:-""}
	MYSQL_USER=${MYSQL_USER:-""}
	MYSQL_PASSWORD=${MYSQL_PASSWORD:-""}

	# create file to store sql
	tfile=`mktemp`
	if [ ! -f "$tfile" ]; then
	    return 1
	fi

	# put sql into file
	cat << EOF > $tfile
USE mysql;
FLUSH PRIVILEGES ;
GRANT ALL ON *.* TO 'root'@'%' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
GRANT ALL ON *.* TO 'root'@'localhost' identified by '$MYSQL_ROOT_PASSWORD' WITH GRANT OPTION ;
SET PASSWORD FOR 'root'@'localhost'=PASSWORD('${MYSQL_ROOT_PASSWORD}') ;
DROP DATABASE IF EXISTS test ;
FLUSH PRIVILEGES ;
EOF

	# create wordpress database
	if [ "$MYSQL_DATABASE" != "" ]; then
	    echo "[i] Creating database: $MYSQL_DATABASE"
		echo "[i] with character set: 'utf8' and collation: 'utf8_general_ci'"
		echo "CREATE DATABASE IF NOT EXISTS \`$MYSQL_DATABASE\` CHARACTER SET utf8 COLLATE utf8_general_ci;" >> $tfile
		
		# create wordpress user
		if [ "$MYSQL_USER" != "" ]; then
			
			# create user and grant
			echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;" >> $tfile
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;" >> $tfile
			echo "SET PASSWORD FOR '$MYSQL_USER'@'localhost'=PASSWORD('${MYSQL_PASSWORD}') ;" >> $tfile

			# refresh
			echo "FLUSH PRIVILEGES ;" >> $tfile
		fi
	fi

	# execute sql in file
	/usr/bin/mysqld --user=mysql --bootstrap < $tfile
	rm -f $tfile

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo

fi

# execute mysql and accept requests
echo "exec /usr/bin/mysqld --user=mysql --console --skip-networking=0" "$@"
exec /usr/bin/mysqld --user=mysql --console --skip-networking=0 $@

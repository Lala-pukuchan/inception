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
			echo "[i] Creating user: $MYSQL_USER with password $MYSQL_PASSWORD"
			
			# for wordpress db only?
			#echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* to '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_PASSWORD';" >> $tfile

			# user can login from local, too.
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'%' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;" >> $tfile
			echo "GRANT ALL ON \`$MYSQL_DATABASE\`.* TO '$MYSQL_USER'@'localhost' identified by '$MYSQL_PASSWORD' WITH GRANT OPTION ;" >> $tfile
			echo "SET PASSWORD FOR '$MYSQL_USER'@'localhost'=PASSWORD('${MYSQL_PASSWORD}') ;" >> $tfile

			# refresh
			echo "FLUSH PRIVILEGES ;" >> $tfile
		fi
	fi

	# execute sql in file
	/usr/bin/mysqld --user=mysql --bootstrap --verbose=0 --skip-name-resolve --skip-networking=0 < $tfile
	rm -f $tfile

#    # only run if we have a starting MYSQL_DATABASE env variable AND
#    # the /docker-entrypoint-initdb.d/ file is not empty
#	if [ "$MYSQL_DATABASE" != "" ] && [ "$(ls -A /docker-entrypoint-initdb.d 2>/dev/null)" ]; then

#		# start the server temporarily so that we can import seed files
#        echo
#        echo "Preparing to process the contents of /docker-entrypoint-initdb.d/"
#        echo
#		TEMP_OUTPUT_LOG=/tmp/mysqld_output
#		/usr/bin/mysqld --user=mysql --skip-name-resolve --skip-networking=0 --silent-startup > "${TEMP_OUTPUT_LOG}" 2>&1 &
#		PID="$!"
	
#		# watch the output log until the server is running
#		until tail "${TEMP_OUTPUT_LOG}" | grep -q "Version:"; do
#			sleep 0.2
#		done

#		# use mysql client to import seed files while temp db is running
#		# use the starting MYSQL_DATABASE so mysql knows where to import
#		MYSQL_CLIENT="/usr/bin/mysql -u root -p$MYSQL_ROOT_PASSWORD"
		
#        # loop through all the files in the seed directory
#        # redirect input (<) from .sql files into the mysql client command line
#        # pipe (|) the output of using `gunzip -c` on .sql.gz files
#		for f in /docker-entrypoint-initdb.d/*; do
#			case "$f" in
#				*.sql)    echo "  $0: running $f"; eval "${MYSQL_CLIENT} ${MYSQL_DATABASE} < $f"; echo ;;
#				*.sql.gz) echo "  $0: running $f"; gunzip -c "$f" | eval "${MYSQL_CLIENT} ${MYSQL_DATABASE}"; echo ;;
#			esac
#		done

#    	# send the temporary mysqld server a shutdown signal
#        # and wait till it's done before completeing the init process
#    	kill -s TERM "${PID}"
#    	wait "${PID}"
#        rm -f TEMP_OUTPUT_LOG
#    	echo "Completed processing seed files."
#	fi;

	echo
	echo 'MySQL init process done. Ready for start up.'
	echo

	echo "exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0" "$@"
fi

# set network
exec /usr/bin/mysqld --user=mysql --console --skip-name-resolve --skip-networking=0 $@

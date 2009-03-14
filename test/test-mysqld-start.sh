#!/bin/sh

[ -e "$UNITTEST_MYSQL_DIR" ] || { echo "UNITTEST_MYSQL_DIR variable must point to MySQL temp data directory"; exit 1; }

MYSQLD_PIDFILE="$UNITTEST_MYSQL_DIR/mysql-test.pid"
[ -e "$HOME/.my.cnf" ] && echo "******** .my.cnf file found in $HOME, this might affect the tests. Move it aside if MySQL based tests fail"

for i in /usr /usr/local/mysql; do
	[ -e "$i/bin/mysql" ] && MYSQLDIR=$i
done
[ -e "$MYSQLDIR" ] || { echo "MYSQLDIR variable must point to MySQL installation directory"; exit 1; }

for i in "$MYSQLDIR/scripts/mysql_install_db" "$MYSQLDIR/bin/mysql_install_db"; do
	[ -e "$i" ] && INSTALLDB=$i
done
[ $INSTALLDB ] || { echo unable to find mysql_install_db; exit 1; } 

"$INSTALLDB" --basedir="$MYSQLDIR" --datadir="$UNITTEST_MYSQL_DIR" --lower_case_table_names=1

for i in "$MYSQLDIR/libexec/mysqld" "$MYSQLDIR/bin/mysqld"; do
	[ -e "$i" ] && MYSQLD=$i
done
[ $MYSQLD ] || { echo unable to find mysqld; exit 1; }

[ -e "$MYSQLD_PIDFILE" ] && { echo "pid file $MYSQLD_PIDFILE exists (PID $(cat "$MYSQLD_PIDFILE")), stop the DB first."; exit 1; }

#--skip-networking \
"$MYSQLD" \
--port=12346 \
--socket=mysql-test.sock \
--pid-file=mysql-test.pid \
--log-error=mysql-test.err \
--log=mysql-test.log \
--log-queries-not-using-indexes \
--log-slow-queries=mysql-test.slowqueries.log \
--lower_case_table_names=1 \
--basedir="$MYSQLDIR" \
--datadir="$UNITTEST_MYSQL_DIR" &

sleep 2

"$MYSQLDIR/bin/mysql" \
--protocol=SOCKET \
-u root \
--socket="$UNITTEST_MYSQL_DIR/mysql-test.sock" \
-e "GRANT ALL ON *.* TO unittest_dbuser@'localhost' IDENTIFIED BY '123456'" || exit 1

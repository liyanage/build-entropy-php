#!/bin/sh

[ -e "$UNITTEST_MYSQL_DIR" ] || { echo "UNITTEST_MYSQL_DIR variable must point to MySQL temp data directory"; exit 1; }

"$MYSQLDIR/bin/mysqladmin" \
--user=root \
--protocol=SOCKET \
--socket="$UNITTEST_MYSQL_DIR/mysql-test.sock" shutdown

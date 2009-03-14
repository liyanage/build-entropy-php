#!/bin/sh

set -e

TESTDIR=/tmp/entropy-php-test
rm -rf $TESTDIR
mkdir $TESTDIR

# launch mysql

UNITTEST_MYSQL_DIR=$TESTDIR/mysql
mkdir $UNITTEST_MYSQL_DIR
. test-mysqld-start.sh

set +e
# run the tests
mkdir -p httpd/serverroot/logs
for arch in i386 ppc x86_64; do
	echo Testing arch $arch
	arch -arch $arch httpd -X -k start -d "$PWD/httpd/serverroot" -f "$PWD/httpd/conf/httpd.conf" &
	sleep 1
	perl -I"$PWD/perl5lib" run-test.pl base_url http://127.0.0.1:12345/  mysql_dir "$UNITTEST_MYSQL_DIR" current_test_arch $arch
	arch -arch $arch httpd -k stop -d "$PWD/httpd/serverroot" -f "$PWD/httpd/conf/httpd.conf"
	sleep 1
	rm -f httpd/serverroot/logs/*.{pid,lock}*
	echo
done



# shut down mysql
. test-mysqld-stop.sh

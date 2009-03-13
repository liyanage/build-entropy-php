#!/bin/sh

mkdir -p httpd/serverroot/logs

for arch in i386 ppc x86_64; do
	echo Testing arch $arch
	arch -arch $arch httpd -X -k start -d "$PWD/httpd/serverroot" -f "$PWD/httpd/conf/httpd.conf" &
	sleep 1
	perl -I"$PWD/perl5lib" run-test.pl base_url http://127.0.0.1:12345/ current_test_arch $arch
	arch -arch $arch httpd -k stop -d "$PWD/httpd/serverroot" -f "$PWD/httpd/conf/httpd.conf"
	sleep 1
	rm -f httpd/serverroot/logs/*.{pid,lock}*
	echo
done




#!/bin/sh

sudo rm -rf /tmp/build-entropy-php-pkg/php5/ /tmp/build-entropy-php-pkgdst/entropy-php.pkg src/php-5.*/ /usr/local/php5/libphp5.so
sudo nice -n 19 perl -Ilib build-php.pl

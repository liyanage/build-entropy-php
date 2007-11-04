#!/bin/sh

sudo rm -rf /tmp/universalbuild/php5/ src/php-5.*/ /usr/local/php5/libphp5.so
sudo perl -Ilib build-php.pl

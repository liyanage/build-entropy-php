#!/bin/sh
# 
# Figure out if a different, non-Entropy PHP module is already active before
# attempting to install the Entropy PHP distribution.
#
# Exits with exit code
# - 0 (true) if another module is active
# - 1 (false) otherwise
#

if sw_vers -productName | grep -qi server; then
	SYMLINK=/etc/apache2/sites/+entropy-php.conf
else
	SYMLINK=/etc/apache2/other/+entropy-php.conf
fi

# If our conf symlink already exists, we assume that
# this was sorted out during the initial installation
[ -e "$SYMLINK" ] && exit 1

/usr/sbin/httpd -M 2>&1 | grep -q php5_module
RESULT=$?
echo $RESULT > /tmp/entropy-check_for_activated_php_result
exit $RESULT

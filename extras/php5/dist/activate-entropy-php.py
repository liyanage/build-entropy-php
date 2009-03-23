#!/usr/bin/env python

import os
import sys

prefix = '{prefix}'

# Create symlink to Apache conf file snippet which loads the PHP module.
# Different places for the symlink in Mac OS X Client / Server
#
httpd_conf_path = prefix + '/entropy-php.conf'

# os.system test results are reversed (shell exit status codes)
if os.system("sw_vers -productName | grep -qi server"):
	httpd_conf_symlink = '/etc/apache2/other/+entropy-php.conf'
	mysql_socket = '/tmp/mysql.sock'
	product = 'Client'
else:
	httpd_conf_symlink = '/etc/apache2/sites/+entropy-php.conf'
	mysql_socket = '/var/mysql/mysql.sock'
	product = 'Server'

sys.stderr.write("Detected OS X %s, Entropy PHP httpd conf symlink goes to '%s', mysql socket set to at '%s'\n" % (product, httpd_conf_symlink, mysql_socket))

if os.system("test -h " + httpd_conf_symlink):
	sys.stderr.write("Entropy PHP httpd conf symlink not present, creating it...\n")
	os.symlink(httpd_conf_path, httpd_conf_symlink)
else:
	sys.stderr.write("Entropy PHP httpd conf symlink already present\n")

# Activate default php.ini and pear.conf files if they don't exist.
# This prevents upgrade installs of the packge from clobbering local modifications
os.chdir(prefix + "/lib")
if not os.path.exists("php.ini"):
	sys.stderr.write("Entropy PHP %s/lib/php.ini not present, copying from php.ini-recommended\n" % prefix)
	os.system("sed -e 's#mysql.default_socket =.*#mysql.default_socket = " + mysql_socket + "#' < php.ini-recommended > php.ini")
else:
	sys.stderr.write("Entropy PHP %s/lib/php.ini already present\n" % prefix)

os.chdir(prefix + "/etc")
if not os.path.exists("pear.conf"):
	os.system("cp pear.conf.default pear.conf")
	sys.stderr.write("Entropy PHP %s/etc/pear.conf not present, copying from pear.conf.default\n" % prefix)
else:
	sys.stderr.write("Entropy PHP %s/etc/pear.conf already present\n" % prefix)

result = os.system("apachectl restart") >> 8
sys.stderr.write("apachectl restart exit status: %d\n" % result)
sys.exit(result)

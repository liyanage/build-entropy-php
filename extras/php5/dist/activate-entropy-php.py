#!/usr/bin/env python

import os

prefix = '{prefix}'


# Create symlink to Apache conf file snippet which loads the PHP module.
# Different places for the symlink in Mac OS X Client / Server
#
httpd_conf_path = prefix + '/entropy-php.conf'

# test is reversed, shell exit code true/false values
if os.system("sw_vers | grep -q Server"):
	httpd_conf_symlink = '/etc/httpd/users/+entropy-php.conf'
else:
	httpd_conf_symlink = '/etc/httpd/sites/+entropy-php.conf'

if os.system("test -h " + httpd_conf_symlink):
	os.symlink(httpd_conf_path, httpd_conf_symlink)
	

# Activate default php.ini and pear.conf files if they don't exist.
# This prevents upgrade installs of the packge from clobbering local modifications
os.system("cd " + prefix + "/lib && test -e php.ini || cp php.ini-recommended php.ini")
os.system("cd " + prefix + "/etc && test -e pear.conf || cp pear.conf.default pear.conf")

os.system("apachectl restart")


#extensions_path = prefix + '/lib/php/extensions/no-debug-non-zts-20050922'

# for item in os.listdir(extensions_path):
# 	cmd = "lipo -info " + extensions_path + "/" + item + "|grep -q `arch` > /dev/null"
# 	comment = ['#', ''][os.system(cmd) == 0]
# 	cmd = "echo '%sextension=%s' > %s/php.d/extension-%s.ini " % (comment, item, prefix, item)
# 	print cmd
# 	os.system(cmd)
	
	
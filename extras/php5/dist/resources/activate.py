#!/usr/bin/env python

import os

prefix = '/usr/local/php5'
extensions_path = prefix + '/lib/php/extensions/no-debug-non-zts-20050922'
httpd_conf_symlink = '/etc/httpd/users/+entropy-php.conf'
httpd_conf_path = prefix + '/entropy-php.conf'

if os.system("test -h " + httpd_conf_symlink):
	os.symlink(httpd_conf_path, httpd_conf_symlink)

for item in os.listdir(extensions_path):
	cmd = "lipo -info " + extensions_path + "/" + item + "|grep -q `arch` > /dev/null"
	comment = ['#', ''][os.system(cmd) == 0]
	cmd = "echo '%sextension=%s' > %s/php.d/extension-%s.ini " % (comment, item, prefix, item)
	print cmd
	os.system(cmd)
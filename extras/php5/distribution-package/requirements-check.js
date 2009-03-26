
function checkExistingPhp() {
	var isOsXServer = system.version['ProductName'].match(/server/i);
	system.log("Is OS X Server: " + isOsXServer);
	var entropyHttpdConfSymlink = isOsXServer ? '/etc/apache2/sites/+entropy-php.conf' : '/etc/apache2/other/+entropy-php.conf';
	system.log("Entropy PHP httpd conf symlink path: " + entropyHttpdConfSymlink);
	var symlinkExists = system.files.fileExistsAtPath(entropyHttpdConfSymlink);
	system.log("Symlink exists: " + symlinkExists);

	// If our conf symlink already exists, we assume that
	// this was sorted out during the initial installation
	if (symlinkExists) return false;
	
	// The shell returns 0 if the grep matched, i.e. another PHP is active
//	var otherPhpActive = !system.run("/usr/sbin/httpd -M 2>&1 | grep -q php5_module");
	var otherPhpActive = !system.run("/bin/sh", "-c", "/usr/sbin/httpd -M 2>&1 | grep -q php5_module");
	system.log("Other PHP active: " + otherPhpActive);
	return otherPhpActive;
}


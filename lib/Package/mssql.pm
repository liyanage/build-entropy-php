package Package::mssql;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '0.63';



sub base_url {
	return "http://ibiblio.org/pub/Linux/ALPHA/freetds/stable";
}


sub packagename {
	return "freetds-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libtds.dylib";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-mssql=shared," . $self->config()->prefix();

}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {

	my $self = shift @_;

	# the .so files as built by the FreeTDS build might be broken. might need to investigate.
	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/mssql
		etc/freetds.conf etc/locales.conf etc/pool.conf
		lib/libtds*.dylib lib/libct*.dylib lib/libsybdb*.dylib lib/libtdsodbc*.so lib/libtdssrv*.dylib
		php.d/50-extension-mssql.ini
	);
	
}





1;
package Package::mcrypt;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '2.5.7';




sub base_url {
	return "http://switch.dl.sourceforge.net/sourceforge/mcrypt";
}


sub packagename {
	return "libmcrypt-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libmcrypt.dylib";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-mcrypt=shared," . $self->config()->prefix();

}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {

	my $self = shift @_;

	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/mcrypt.so
		lib/libmcrypt*.dylib
		php.d/50-extension-mcrypt.ini
	);
	
}





1;
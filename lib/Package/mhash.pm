package Package::mhash;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '0.9.6';



sub base_url {
	return "http://switch.dl.sourceforge.net/sourceforge/mhash";
}


sub packagename {
	return "mhash-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libmhash.dylib";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-mhash=shared," . $self->config()->prefix();

}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {

	my $self = shift @_;

	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/mhash.so
		lib/libmhash*.dylib
		php.d/50-extension-mhash.ini
	);
	
}





1;
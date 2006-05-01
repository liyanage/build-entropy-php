package Package::libxml2;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '2.6.23';





sub base_url {
	return "ftp://fr.rpmfind.net/pub/libxml";
}


sub packagename {
	return "libxml2-" . $VERSION;
}


sub configure_flags {
	my $self = shift @_;
	
	return $self->SUPER::configure_flags() . " --without-python";

}


sub subpath_for_check {
	return "lib/libxml2.dylib";
}


sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-libxml-dir=shared," . $self->config()->prefix();

}



1;
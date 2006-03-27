package Package::libxslt;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '1.1.15';



sub dependency_names {
	return qw(libxml2);
}


sub base_url {
	return "ftp://fr.rpmfind.net/pub/libxml";
}


sub packagename {
	return "libxslt-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libxslt.dylib";
}



sub configure_flags {
	my $self = shift @_;
	
	return $self->SUPER::configure_flags() . " --with-python --with-libxml-prefix=" . $self->install_prefix();

}



1;
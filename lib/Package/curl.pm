package Package::curl;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '7.15.1';





sub base_url {
	return "http://curl.haxx.se/download";
}


sub packagename {
	return "curl-" . $VERSION;
}




sub do_build {

	my $self = shift @_;

	$self->build_splice();

}




1;
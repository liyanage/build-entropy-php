package Package::libfreetype;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '2.1.10';



sub base_url {
	return "http://switch.dl.sourceforge.net/sourceforge/freetype";
}


sub packagename {
	return "freetype-$VERSION";
}


sub subpath_for_check {
	return "lib/libfreetype.dylib";
}


# sub configure_flags {
# 	my $self = shift @_;
# 	return $self->SUPER::configure_flags(@_) . " --without-x";
# }


1;
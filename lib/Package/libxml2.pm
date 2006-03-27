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



sub subpath_for_check {
	return "lib/libxml2.dylib";
}




1;
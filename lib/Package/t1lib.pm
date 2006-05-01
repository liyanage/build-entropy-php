package Package::t1lib;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '5.1.0';



sub base_url {
	return "ftp://sunsite.cnlab-switch.ch/mirror/linux/sunsite/libs/graphics";
}


sub packagename {
	return "t1lib-$VERSION";
}


sub subpath_for_check {
	return "lib/libt1.dylib";
}


sub configure_flags {
	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --without-x --without-athena";
}



sub build_arch_make {

	my $self = shift @_;
	my (%args) = @_;

	$self->shell("make" . $self->make_flags() . " without_doc");

}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-t1lib=" . $self->config()->prefix();

}





1;
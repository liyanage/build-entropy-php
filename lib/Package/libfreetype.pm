package Package::libfreetype;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.3.5';



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


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--enable-gd-native-ttf --with-freetype-dir=" . $self->config()->prefix();
}



1;
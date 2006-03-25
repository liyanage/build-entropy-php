package Package::php5;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '5.1.2';





sub base_url {
	return "http://us2.php.net/distributions";
}


sub packagename {
	return "php-$VERSION";
}


sub dependency_names {
	return qw(curl);
}


sub subpath_for_check {
	return "libphp5.so";
}

sub configure_flags {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	return $self->SUPER::configure_flags() . " --with-curl=$prefix --with-apxs";
}


1;
package Package;

use strict;
use warnings;
use base qw(PackageBase);

use UBSplicer;


our $VERSION = '1.0';



sub build {

	my $self = shift @_;

	return unless ($self->SUPER::build(@_));
	
	die;
	
	return 1;

}



sub install {
	
	my $self = shift @_;

	return undef unless ($self->SUPER::install(@_));
	
	die;
	
	return 1;

}

1;

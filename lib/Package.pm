package Package;

use strict;
use warnings;
use base qw(PackageBase);

use UBSplicer;


our $VERSION = '1.0';



sub build {

	my $self = shift @_;

	$self->SUPER::build(@_);
	
	die;

}

sub install {
	
	my $self = shift @_;

	$self->SUPER::install(@_);
	
	die;

}

1;

package Config;

use base qw(Obj);

use strict;
use warnings;

our $VERSION = '1.0';


sub init {

	my $self = shift @_;
	
	$self->{$_} ||= undef foreach qw(basedir downloaddir);
	$self->makedirs();
	
}


sub downloaddir {
	my $self = shift @_;
	return $self->basedir() . '/download';
}

sub srcdir {
	my $self = shift @_;
	return $self->basedir() . '/src';
}





sub makedirs {

	my $self = shift @_;

	my @dirs = (
		$self->downloaddir(),
		$self->prefix(),
		$self->srcdir(),
	);

	foreach my $dir (@dirs) {
		die "Unable to mkdir() '$dir'" unless (-d $dir or mkdir($dir));
	}
		
	return undef;

}



1;


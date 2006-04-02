package Package::libjpeg;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '6b';



sub base_url {
	return "http://www.ijg.org/files";
}


sub packagename {
	return "jpeg-$VERSION";
}


sub filename {
	return "jpegsrc.v$VERSION.tar.gz";
}

#http://www.ijg.org/files/jpegsrc.v6b.tar.gz


sub build {

	my $self = shift @_;
	return undef unless ($self->SUPER::build(@_));
	my $prefix = $self->config()->prefix();
	$self->cd_packagesrcdir();
	$self->shell(qq!CFLAGS="-arch ppc -arch i386" ./configure ! . $self->configure_flags());
	$self->shell($self->make_command());
	
}



sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/libjpeg.a";
}


sub subpath_for_check {
	my $self = shift @_;
	return "lib/libjpeg.a";
}



sub install {

	my $self = shift @_;
	return undef unless ($self->SUPER::install(@_));
	
	$self->cd_packagesrcdir();
	$self->shell("make install-lib");
	$self->shell("make install-headers");

}



1;
package Package::imapcclient;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2007';
#our $VERSION = '2004g';
#our $VERSION = '2006a';



sub base_url {
	return "ftp://ftp.cac.washington.edu/imap";
}


sub packagename {
	return "imap-$VERSION";
}


sub filename {
	return "c-client.tar.Z";
}


sub build {

	my $self = shift @_;
#	return undef unless ($self->SUPER::build(@_));
	
	$self->cd_packagesrcdir();
	my $cflags = $self->cflags();
	$self->shell(qq(MACOSX_DEPLOYMENT_TARGET=10.5 EXTRACFLAGS="$cflags" make -e oxp));
#-Dcheckpw=php_imap_checkpw	
}


sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/c-client/c-client.a";
}


sub install {
	my $self = shift @_;
	# this package is never installed
#	return $self->SUPER::install(@_);
}

sub is_installed {
	return undef;
}


sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;
	my $packagename = $self->packagename();
	return "--with-imap=../$packagename --with-kerberos=/usr --with-imap-ssl=/usr";

}





1;

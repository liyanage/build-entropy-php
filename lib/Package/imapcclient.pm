package Package::imapcclient;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2004g';



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
	return undef unless ($self->SUPER::build(@_));
	
	$self->cd_packagesrcdir();
	$self->shell(qq!EXTRACFLAGS="-arch ppc -arch i386 -Dcheckpw=php_imap_checkpw" make -e osx!);
	
}


sub is_built {
	my $self = shift @_;
	return -e $self->packagesrcdir() . "/c-client/c-client.a";
}


sub install {
	my $self = shift @_;
	# this package is never installed
	return $self->SUPER::install(@_);
}

sub is_installed {
	return undef;
}


sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-imap=../imap-2004g --with-kerberos=/usr --with-imap-ssl=/usr";

}





1;
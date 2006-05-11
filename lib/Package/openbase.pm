package Package::openbase;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '0.0.0';



sub is_downloaded {
	return 1;
}


sub is_unpacked {
	return 1;
}


sub is_installed {
	return 1;
}


sub php_build_arch_pre {

	my $self = shift @_;
	my (%args) = @_;


	# unpack openbase distribution
	$self->shell("rm -rf openbase_module");
	my $tarball = $self->extras_path('openbase_module.tar.gz');
	$self->shell("tar -xzvf $tarball");

}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--enable-openbase_module";

}



1;
package Package::memcache;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '2.0.4';



sub base_url {
	my $self = shift;
	return "http://pecl.php.net/get";
}


sub packagename {
	return "memcache-" . $VERSION;
}


sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tgz";
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

	# unpack json distribution
	$self->shell("rm -rf memcache");
	my $tarball = $self->download_path();
	$self->shell("tar -xzvf $tarball");
	$self->shell("mv memcache-* memcache");

}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--enable-memcache";

}

1;
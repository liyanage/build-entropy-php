package Package::json;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '1.2.1';



sub base_url {
	my $self = shift;
	return "http://www.aurore.net/projects/php-json";
}


sub packagename {
	return "php-json-ext-" . $VERSION;
}


sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.bz2";
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
	$self->shell("rm -rf json");
	my $tarball = $self->download_path();
	$self->shell("tar -xjvf $tarball");
	$self->shell("mv php-json-ext* json");

}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-json=shared";

}




sub php_dso_extension_names {
	my $self = shift @_;
	return qw(json);
}



sub package_filelist {
	my $self = shift @_;
	return qw(lib/php/extensions/no-debug-non-zts-20050922/json php.d/50-extension-json.ini);
}


1;
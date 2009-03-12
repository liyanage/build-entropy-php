package Package::curl;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '7.17.1';





sub base_url {
	return "http://curl.haxx.se/download";
}


sub packagename {
	return "curl-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libcurl.dylib";
}


#CFLAGS='-arch i386 -arch x86_64 -arch ppc7400 -arch ppc64' LDFLAGS='-arch i386 -arch x86_64 -arch ppc7400 -arch ppc64' CC='cc -DENTROPY_CH_RELEASE=2' ./configure --disable-dependency-tracking --prefix=/usr/local/php5 --enable-ldaps

sub configure_flags {
	my $self = shift @_;
	return join " ", (
		$self->SUPER::configure_flags(@_),
		'--enable-ldaps'
	);
}

sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-curl=shared," . $self->config()->prefix();
}


sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(lib/libcurl*.dylib php.d/50-extension-curl.ini share/curl);
}




1;

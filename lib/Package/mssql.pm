package Package::mssql;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '0.64';



sub base_url {
	return "http://ibiblio.org/pub/Linux/ALPHA/freetds/stable";
}


sub packagename {
	return "freetds-" . $VERSION;
}


sub subpath_for_check {
	return "lib/libtds.dylib";
}


sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-mssql=shared," . $self->config()->prefix();
}


sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}


sub build_configure {
	my $self = shift @_;

	my $cflags = $self->cflags();
	my $ldflags = $self->ldflags();
	my $cxxflags = $self->compiler_archflags();
	my $archflags = $self->compiler_archflags();
	my $cc = $self->cc();

	my $prefix = $self->config()->prefix();
	$self->shell(qq(MACOSX_DEPLOYMENT_TARGET=10.5 CFLAGS="$cflags" LDFLAGS='$ldflags' CXXFLAGS='$cxxflags' CC='$cc $archflags' CPP='cpp' ./configure ) . $self->configure_flags());

}




sub package_filelist {

	my $self = shift @_;

	# the .so files as built by the FreeTDS build might be broken. might need to investigate.
	return $self->config()->extdir_path('mssql'), qw(
		etc/freetds.conf etc/locales.conf etc/pool.conf
		lib/libtds*.dylib lib/libct*.dylib lib/libsybdb*.dylib lib/libtdsodbc*.so lib/libtdssrv*.dylib
		php.d/50-extension-mssql.ini
	);
	
}





1;

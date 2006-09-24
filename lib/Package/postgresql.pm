package Package::postgresql;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '8.1.4';


sub base_url {
	return "ftp://ftp2.ch.postgresql.org/pub/postgresql/source/v$VERSION/";
}


sub packagename {
	return "postgresql-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libpq.dylib";
}




sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	my $prefix = $self->config()->prefix();

	return "--with-pgsql=shared,$prefix --with-pdo-pgsql=shared,$prefix";

}



sub build_arch_make {
	my $self = shift @_;
	my (%args) = @_;

	foreach my $subdir (qw(interfaces include)) {
		$self->cd("src/$subdir");
		$self->shell("make" . $self->make_flags());
		$self->cd("../..");
	}
}



sub make_install_arch {
	my $self = shift @_;
	my (%args) = @_;
	my $install_override = $self->make_install_override_list(prefix => $args{prefix});
	foreach my $subdir (qw(interfaces include)) {
		$self->cd("src/$subdir");
		$self->shell($self->make_command() . " $install_override install");
		$self->cd("../..");
	}
}




sub php_dso_extension_names {
	my $self = shift @_;
	return qw(pgsql pdo_pgsql);
}



sub package_filelist {

	my $self = shift @_;

	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/*pgsql
		lib/libpgtypes*.dylib
		lib/libpq*.dylib
		php.d/50-extension-*pgsql*.ini
	);
	
}





1;

package Package::iodbc;

use strict;
use warnings;

use base qw(PackageSystemProvided);

our $VERSION = '10.1';



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	my $prefix = $self->config()->prefix();

	return "--with-iodbc=shared,/usr";

}




sub php_dso_extension_names {
	my $self = shift @_;
	return qw(odbc);
}



sub package_filelist {
	my $self = shift @_;
	return $self->config()->extdir_path('odbc'), qw(php.d/50-extension-odbc.ini);
}



1;

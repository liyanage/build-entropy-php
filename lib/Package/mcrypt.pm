package Package::mcrypt;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '2.5.8';

sub init {
	my $self = shift @_;
  # if (-e "/usr/lib/libltdl.dylib") {
  #   die "/usr/lib/libltdl.dylib is present on this system but will be missing on target systems, please move it aside. died";
  # }
	return $self->SUPER::init(@_);
}


sub base_url {
	return "http://dl.sourceforge.net/sourceforge/mcrypt";
}


sub packagename {
	return "libmcrypt-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libmcrypt.dylib";
}



sub php_extension_configure_flags {
	my $self = shift @_;
	my (%args) = @_;
	return "--with-mcrypt=shared," . $self->config()->prefix();
}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(
		lib/libmcrypt*.dylib
		php.d/50-extension-mcrypt.ini
	);
}





1;

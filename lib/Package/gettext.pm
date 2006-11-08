package Package::gettext;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '0.14.5';





sub base_url {
	return "ftp://sunsite.cnlab-switch.ch/mirror/gnu/gettext";
}


sub packagename {
	return "gettext-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libgettextlib.dylib";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-gettext=shared," . $self->config()->prefix();

}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {

	my $self = shift @_;

	return $self->config()->extdir_path('gettext'), qw(
		lib/libgettext*.dylib lib/libasprintf*.dylib lib/libintl*.dylib
		php.d/50-extension-gettext.ini share/gettext
	);
	
}





1;

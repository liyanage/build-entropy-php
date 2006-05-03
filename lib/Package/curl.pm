package Package::curl;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '7.15.1';





sub base_url {
	return "http://curl.haxx.se/download";
}


sub packagename {
	return "curl-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libcurl.dylib";
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

	return qw(lib/php/extensions/no-debug-non-zts-20050922/curl lib/libcurl*.dylib php.d/50-extension-curl.ini share/curl);
	
}





1;
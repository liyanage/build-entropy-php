package Package::tidy;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '2005.10.26';




sub base_url {
	my $self = shift;
	return "http://tidy.sourceforge.net/src";
}
#tidy_src.tgz

sub packagename {
	return "tidy";
}


sub filename {
	my ($self) = shift;
	return $self->packagename() . "_src.tgz";
}


sub subpath_for_check {
	return "lib/libtidy.dylib";
}



sub build_arch_pre {

	my $self = shift @_;

	$self->shell('sh build/gnuauto/setup.sh');

}







sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-tidy=shared," . $self->config()->prefix();

}





sub php_dso_extension_names {
	my $self = shift @_;
	return qw(tidy);
}




sub package_filelist {

	my $self = shift @_;

	return qw(lib/php/extensions/no-debug-non-zts-20050922/tidy php.d/50-extension-tidy.ini lib/libtidy*.dylib);
	
}

1;
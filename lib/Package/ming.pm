package Package::ming;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '0.3.0';





sub base_url {
	return "http://switch.dl.sourceforge.net/sourceforge/ming";
}


sub packagename {
	return "ming-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libming.dylib";
}


sub ldflags {

	my $self = shift @_;
	
	my $prefix = $self->config()->prefix();
	return "-L$prefix/lib";
	
}


sub cflags {

	my $self = shift @_;
	
	my $prefix = $self->config()->prefix();
	return "-I$prefix/include";
	
}


# broken ming build setup can not handle distclean target
sub cleanup_srcdir {
	my $self = shift @_;
	$self->cd_srcdir();
	$self->shell("rm -rf ming-*");
	$self->unpack();
}


# broken ming build setup can not handle parallel make
sub make_flags {

	my $self = shift @_;
	return $self->SUPER::make_flags() . " -j 1";
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-ming=shared," . $self->config()->prefix();

}




sub php_dso_extension_names {
	my $self = shift @_;
	return $self->shortname();
}




sub package_filelist {

	my $self = shift @_;

	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/ming
		lib/libming*.dylib
		php.d/50-extension-ming.ini
	);
	
}





1;
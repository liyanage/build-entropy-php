package Package::pdflib;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '6.0.3';


sub init {

	my $self = shift @_;
	$self->SUPER::init(@_);

	$self->{lite} = $self->config()->pdflib_lite();

}



sub base_url {
	my $self = shift;
	return $self->{lite} ? "http://www.pdflib.com/products/pdflib/download/603src" : '';
}


sub packagename {
	return "PDFlib-Lite-" . $VERSION;
}



sub subpath_for_check {
	return "lib/libpdf.dylib";
}




sub build_arch_post {

	my $self = shift @_;
	my (%args) = @_;

	# this is here because libtool does not pass the -arch flag on to the cc command
	# used to generate the dynamic library, so we have to do that
	# manually here, otherwise the dylib ends up empty and of the wrong
	# architecture
	my $prefix = $self->config()->prefix();
	$self->cd('libs/pdflib');
	$self->shell("cc -arch $args{arch} -dynamiclib -flat_namespace -undefined suppress -o .libs/libpdf.*.*.*.dylib ./pdflib.lo -all_load  ../../libs/pdcore/.libs/libpdcore.al ../../libs/png/.libs/libpng.al ../../libs/flate/.libs/libz.al ../../libs/tiff/.libs/libtiff.al ../../libs/jpeg/.libs/libjpeg.al ../../libs/pdflib/.libs/libpdf_.al  -lc -install_name '$prefix'/lib/libpdf.5.dylib -compatibility_version 6 -current_version 6.3 -framework ApplicationServices");

}


sub configure_flags {

	my $self = shift @_;
	return $self->SUPER::configure_flags(@_) . " --with-java=no --with-perl=no --with-py=no --with-ruby=no --with-tcl=no";

}




sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	return "--with-pdflib=shared," . $self->config()->prefix();

}





sub php_dso_extension_names {
	my $self = shift @_;
	return qw(pdf);
}



sub php_build_arch_pre {

	my $self = shift @_;
	my (%args) = @_;

	# replace pdflib extension module source with newer version
	$self->shell("rm -rf pdf");
	my $pdflib_extension_tarball = $self->extras_dir() . "/pdflib-2.0.5.tgz";
	die "pdflib extensions tarball '$pdflib_extension_tarball' does not exist" unless (-f $pdflib_extension_tarball);
	$self->shell("tar -xzvf $pdflib_extension_tarball");
	$self->shell("mv pdflib-2.*.* pdf; rm package.xml");

}


sub package_filelist {

	my $self = shift @_;

	return qw(lib/php/extensions/no-debug-non-zts-20050922/pdf php.d/50-extension-pdf.ini lib/libpdf*.dylib);
	
}

1;
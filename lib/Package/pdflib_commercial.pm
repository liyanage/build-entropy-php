package Package::pdflib_commercial;

use strict;
use warnings;


use base qw(PackageBinary);

our $VERSION = '6.0.3';




sub download {

	my $self = shift @_;

	$_->download() foreach $self->dependencies();

	return if ($self->is_downloaded());

	my $dp = $self->download_path();

	$self->log("downloading commercial PDFlib, i386");
	$self->shell("hdiutil attach http://www.pdflib.com/products/pdflib/download/603/PDFlib-6.0.3p2-MacOSX-Intel.dmg");
	$self->shell("cp /Volumes/PDFlib-*/bind/php5/php-510/libpdf_php.so $dp.i386");
	$self->shell("hdiutil detach /Volumes/PDFlib-*/");

	$self->log("downloading commercial PDFlib, ppc");
	$self->shell("hdiutil attach http://www.pdflib.com/products/pdflib/download/603/PDFlib-6.0.3-MacOSX-PowerPC.dmg");
	$self->shell("cp /Volumes/PDFlib-*/bind/php5/php-510/libpdf_php.so $dp.ppc");
	$self->shell("hdiutil detach /Volumes/PDFlib-*/");

	$self->shell("lipo -create -arch ppc $dp.ppc -arch i386 $dp.i386 -output $dp");

}


sub filename {
	my $self = shift @_;
	return "pdflib_commercial";
}


sub is_installed {
	my $self = shift @_;
	return 1;
}




sub prepackage_hook {

	my $self = shift @_;
	my ($pkgroot) = @_;
	
	my $dp = $self->download_path();
	my $extdir = "$pkgroot/" . $self->config()->extdir();
	
	$self->shell("mkdir -p $extdir");
	$self->shell("cp $dp $extdir/pdf");

}


sub php_dso_extension_names {
	my $self = shift @_;
	return qw(pdf);
}


sub package_filelist {
	my $self = shift @_;
	return $self->config()->extdir_path('pdf'), qw(php.d/50-extension-pdf.ini);
}


1;

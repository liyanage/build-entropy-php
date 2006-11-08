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
	$self->cd('/tmp');

	foreach my $arch qw (PowerPC Intel) {
		$self->log("downloading commercial PDFlib, $arch");
		$self->shell("curl -O http://www.pdflib.com/binaries/PDFlib/603/PDFlib-6.0.3p5-MacOSX-$arch-php.tar.gz");
		$self->shell("tar -xzf PDFlib-*.tar.gz");
		$self->shell("cp PDFlib-*/bind/php5/php-520/libpdf_php.so $dp.$arch");
		$self->shell("rm -rf PDFlib-*");

	}	

	$self->shell("lipo -create -arch ppc $dp.PowerPC -arch i386 $dp.Intel -output $dp");

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

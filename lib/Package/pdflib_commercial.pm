package Package::pdflib_commercial;

use strict;
use warnings;

use base qw(PackageBinary);

our $VERSION = '7.0.3';


sub download {
	my $self = shift @_;
	$_->download() foreach $self->dependencies();
	return if ($self->is_downloaded());

	my $dp = $self->download_path();
	my $dmg = "PDFlib-7.0.3p5-MacOSX-10.5-Universal-php.dmg";
	my $mountpoint = '/tmp/'.$self->filename();

	$self->log("downloading commercial PDFlib");
	$self->cd('/tmp');
	$self->shell("curl -O http://www.pdflib.com/binaries/PDFlib/703/$dmg");
	$self->shell("hdiutil mount -mountpoint $mountpoint $dmg");
	$self->shell("cp $mountpoint/bind/php5/php-520/libpdf_php.so $dp");
	$self->shell("hdiutil unmount $mountpoint");
}


sub filename {
	my $self = shift @_;
	return "libpdf_php.so";
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
	$self->shell("cp $dp $extdir/");
}


sub php_dso_extension_names {
	my $self = shift @_;
	return qw(libpdf_php);
}


sub package_filelist {
	my $self = shift @_;
	return $self->config()->extdir_path('pdf'), qw(php.d/50-extension-pdf.ini);
}


1;

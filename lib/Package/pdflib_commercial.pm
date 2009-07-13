package Package::pdflib_commercial;

use strict;
use warnings;

use base qw(PackageBinary);

our $VERSION = '7.0.4';
our $PATCHLEVEL = '5';

sub download {
	my $self = shift @_;
	$_->download() foreach $self->dependencies();
	return if ($self->is_downloaded());

	my $dp = $self->download_path();
	my $dmg = "PDFlib-${VERSION}p$PATCHLEVEL-MacOSX-10.5-Universal-php.dmg";
	my $mountpoint = '/tmp/'.$self->filename();

	$self->log("downloading commercial PDFlib");
	$self->cd('/tmp');
	$self->shell("curl -O http://www.pdflib.com/binaries/PDFlib/704/$dmg");
	$self->shell("hdiutil mount -mountpoint $mountpoint $dmg");
	$self->shell("cp $mountpoint/bind/php5/php-530/libpdf_php.so $dp");
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
#	my $extdir = "$pkgroot/" . $self->config()->extdir();
#	$self->shell("mkdir -p $extdir");
	my $c = $self->config();
	my $extdir = $c->prefix() . '/' . $c->extdir();
	$self->shell("cp $dp $extdir/");
}


sub php_dso_extension_names {
	my $self = shift @_;
	return qw(libpdf_php);
}


sub package_filelist {
	my $self = shift @_;
	return $self->php_dso_extension_paths(), qw(php.d/50-extension-libpdf_php.ini);
}


1;

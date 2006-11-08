package Package::frontbase;

use strict;
use warnings;

use base qw(PackageBinary);

our $VERSION = '4.2.4';


# http://www.frontbase.com/download/Download_4.2.4/MacOSX-10.4u/FrontBase-MacOSX-4.2.4.dmg
# /Volumes/FrontBase/FrontBase-4.2.4.mpkg/FBDeveloperLibraries-4.2.4.pkg/Contents/Resources/FBDeveloperLibraries-4.2.4.pax.gz 
sub url {
	my $self = shift;
	return "http://www.frontbase.com/download/Download_$VERSION/MacOSX-10.4u/FrontBase-MacOSX-$VERSION.dmg";

}


sub packagename {
	return "FBDeveloperLibraries";
}


sub filename {
	my ($self) = shift;
	return $self->packagename() . "-$VERSION.pax.gz";
}






sub download {

	my $self = shift @_;

	$_->download() foreach $self->dependencies();

	return if ($self->is_downloaded());
		
	$self->log("downloading $self from " . $self->url());
	$self->shell("hdiutil attach " . $self->url());

	$self->shell("cp /Volumes/FrontBase/FrontBase-$VERSION.mpkg/FBDeveloperLibraries-$VERSION.pkg/Contents/Resources/FBDeveloperLibraries-$VERSION.pax.gz " . $self->download_path());

	$self->shell("hdiutil detach /Volumes/FrontBase/");

}



sub unpack {

	my $self = shift @_;

	return if ($self->is_unpacked());
	$self->download();
	$self->log('unpacking');
	$self->cd_srcdir();
	my $dir = $self->packagesrcdir();
	$self->shell("mkdir -p $dir");
	$self->cd($dir);
	$self->shell('gzcat ', $self->download_path(), '| pax -r');

	# temporary fix for broken static lib in official package
	$self->shell('cp', $self->extras_path('libFBCAccess.a'), 'Library/FrontBase/lib');

	$self->shell('ranlib Library/FrontBase/lib/*.a');

}






sub install {
	my $self = shift @_;

	$self->log("installing");
	
	$self->unpack();

	return undef;

}

sub is_installed {
	my $self = shift @_;
	return undef;
}




sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	my $prefix = $self->config()->prefix();
	my $dir = $self->packagesrcdir() . "/Library/FrontBase";
	return "--with-fbsql=shared,$dir";

}




sub php_dso_extension_names {
	my $self = shift @_;
	return qw(fbsql);
}




sub package_filelist {

	my $self = shift @_;

	return $self->config()->extdir_path('fbsql'), qw(php.d/50-extension-fbsql.ini);
	
}




1;

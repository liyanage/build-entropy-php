package PackageSplice;

use strict;
use warnings;
use base qw(PackageBase);

use UBSplicer;


our $VERSION = '1.0';



sub build {

	my $self = shift @_;

	$self->SUPER::build(@_);
	
	my $shortname = $self->shortname();
	my $prefix_base = "/tmp/universalbuild/$shortname";

#	foreach my $arch (qw(i386 ppc)) {
#		$self->cd_packagesrcdir();
#		$self->shell({fatal => 0}, 'make distclean') if (-e "Makefile");
#		$self->shell("CFLAGS='-arch $arch' ./configure --prefix=" . $self->config()->prefix());
#		$self->shell("make" . $self->make_flags());
#
#		my $prefix = "$prefix_base/$arch/" . $self->config()->prefix();
#		my $install_override = "prefix=$prefix exec_prefix=$prefix bindir=$prefix/bin sbindir=$prefix/sbin sysconfdir=$prefix/etc datadir=$prefix/share includedir=$prefix/include libdir=$prefix/lib libexecdir=$prefix/libexec localstatedir=$prefix/var sharedstatedir=$prefix/com mandir=$prefix/man infodir=$prefix/info";
#
#		$self->shell("make" . $self->make_flags() . "$install_override install");
#		
#	}

	my $splicer = UBSplicer->new(basedir => $prefix_base);
	$splicer->run();
	
}


sub install {

	my $self = shift @_;

	$self->SUPER::install(@_);

	my $prefix = $self->config()->prefix();
	my $shortname = $self->shortname();
	my $src = "/tmp/universalbuild/$shortname/universal/$prefix";
	my $dst = $prefix;
	my $cmd = "cp -R $src/* $dst";
	$self->shell($cmd);
	
}



1;

package PackageSplice;

use strict;
use warnings;
use base qw(PackageBase);

use UBSplicer;


our $VERSION = '1.0';



sub splice_dir {
	my $self = shift @_;	
	my $shortname = $self->shortname();
	return "/tmp/universalbuild/$shortname";
}

sub splice_prefix {
	my $self = shift @_;
	return $self->splice_dir() . "/universal/" . $self->config()->prefix();
}


sub build {

	my $self = shift @_;

	return unless ($self->SUPER::build(@_));
	
	my $shortname = $self->shortname();
	my $splice_dir = $self->splice_dir();

	foreach my $arch (qw(i386 ppc)) {
		$self->cd_packagesrcdir();
		$self->shell({fatal => 0}, 'make distclean') if (-e "Makefile");
		$self->shell("CFLAGS='-arch $arch' ./configure " . $self->configure_flags());
		$self->shell("make" . $self->make_flags());

		my $prefix = "$splice_dir/$arch/" . $self->config()->prefix();
		my $install_override = "prefix=$prefix exec_prefix=$prefix bindir=$prefix/bin sbindir=$prefix/sbin sysconfdir=$prefix/etc datadir=$prefix/share includedir=$prefix/include libdir=$prefix/lib libexecdir=$prefix/libexec localstatedir=$prefix/var sharedstatedir=$prefix/com mandir=$prefix/man infodir=$prefix/info";

		$self->shell($self->make_command() . " $install_override install");
		
	}

	my $splicer = UBSplicer->new(basedir => $splice_dir);
	$splicer->run();

	return 1;
}





sub install {

	my $self = shift @_;

	return undef unless ($self->SUPER::install(@_));

	my $prefix = $self->config()->prefix();
	my $shortname = $self->shortname();
	my $src = "/tmp/universalbuild/$shortname/universal/$prefix";
	my $dst = $prefix;
	my $cmd = "cp -R $src/* $dst";
	$self->shell($cmd);
	
	return 1;
	
}


sub is_built {
	my $self = shift @_;
	my $subpath = $self->subpath_for_check();
	my $exists = -e $self->splice_prefix() . "/$subpath";
	$self->log("not building because '$subpath' exists") if ($exists);
	return $exists;
}


sub is_installed {
	my $self = shift @_;
	my $subpath = $self->subpath_for_check();
	my $exists = -e $self->config()->prefix() . "/$subpath";
	$self->log("not installing because '$subpath' exists") if ($exists);
	return $exists;
}



1;

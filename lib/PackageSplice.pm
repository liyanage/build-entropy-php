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
	return $self->splice_dir() . "/universal/" . $self->install_prefix();
}


sub build {

	my $self = shift @_;

	return unless ($self->SUPER::build(@_));
	
	my $shortname = $self->shortname();
	my $splice_dir = $self->splice_dir();

	foreach my $arch (qw(i386 ppc)) {
		
		$self->cd_packagesrcdir();
		$self->build_arch_pre(arch => $arch);

		$self->build_arch(arch => $arch);

		$self->cd_packagesrcdir();
		$self->build_arch_post(arch => $arch);

		my $prefix = "$splice_dir/$arch/" . $self->install_prefix();
		$self->make_install_arch(arch => $arch, prefix => $prefix);

	}

	my $splicer = UBSplicer->new(basedir => $splice_dir);
	$splicer->run();

	return 1;
}


sub build_arch_pre {}
sub build_arch_post {}



sub build_arch {

	my $self = shift @_;
	my (%args) = @_;

	my $cflags = $self->cflags();

	$self->cd_packagesrcdir();
	$self->shell({fatal => 0}, 'make distclean') if (-e "Makefile");
	$self->shell("CFLAGS='$cflags' CC='cc -arch $args{arch}' CXX='c++ -arch $args{arch}' ./configure " . $self->configure_flags(arch => $args{arch}));
	$self->shell("make" . $self->make_flags());

}





sub make_install_arch {

	my $self = shift @_;
	my (%args) = @_;

	my $install_override = $self->make_install_override_list(prefix => $args{prefix});
	$self->shell($self->make_command() . " $install_override install");

}


sub make_install_override_list {

	my $self = shift @_;
	my (%args) = @_;

	return "prefix=$args{prefix} exec_prefix=$args{prefix} bindir=$args{prefix}/bin sbindir=$args{prefix}/sbin sysconfdir=$args{prefix}/etc datadir=$args{prefix}/share includedir=$args{prefix}/include libdir=$args{prefix}/lib libexecdir=$args{prefix}/libexec localstatedir=$args{prefix}/var sharedstatedir=$args{prefix}/com mandir=$args{prefix}/man infodir=$args{prefix}/info EXTENSION_DIR=$args{prefix}/lib/php/extensions/no-debug-non-zts-20050922";

}



sub install {

	my $self = shift @_;

	return undef unless ($self->SUPER::install(@_));

	my $dst = $self->install_prefix();
	system("mkdir -p $dst");
	unless (-d $dst) {
		die "Unable to find or create installation dir '$dst'";
	}
	my $shortname = $self->shortname();

	my $src = $self->splice_prefix();
	my $cmd = "cp -R $src/* $dst";
	$self->shell($cmd);
	
	return 1;
	
}








sub is_built {
	my $self = shift @_;
	my $subpath = $self->subpath_for_check();
	my $exists = -e $self->splice_prefix() . "/$subpath";

	if ($exists) {
		$self->log("not building because '$subpath' exists")
	} else {
		$self->log("building because '$subpath' does not exist")	
	}

	return $exists;
}




1;

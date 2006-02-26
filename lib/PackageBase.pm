package PackageBase;

use strict;
use warnings;
use base qw(Obj);


our $VERSION = '1.0';


sub init {

	my $self = shift @_;
	my (%args) = @_;

	$self->{dependencies} ||= [];

	foreach my $name ($self->dependency_names()) {
		my $class = 'Package::' . $name;
		eval "use $class";
		die if ($@);
		push @{$self->{dependencies}}, $class->new(config => $self->config());
	}

}




sub base_url {
	my ($self) = shift;
	Carp::croak(sprintf("class %s must override method %s", ref($self) || $self, (caller(0))[3]));
}


sub packagename {
	my ($self) = shift;
	Carp::croak(sprintf("class %s must override method %s", ref($self) || $self, (caller(0))[3]));
}


sub do_build {
	my ($self) = shift;
	Carp::croak(sprintf("class %s must override method %s", ref($self) || $self, (caller(0))[3]));
}


sub filename {
	my ($self) = shift;
	return $self->packagename() . ".tar.gz";
}

sub packagesrcdir {
	my $self = shift @_;
	return $self->config()->srcdir() . "/" . $self->packagename(); 
}



sub url {
	my $self = shift @_;
	return $self->base_url() . "/" . $self->filename();
}

sub download_path {
	my $self = shift @_;
	return $self->config()->downloaddir() . "/" . $self->filename();
}




sub build {

	my $self = shift @_;
	return if ($self->is_built());
	
	$self->unpack();

	$_->install() foreach $self->dependencies();

	$self->log("building");

}

sub is_built {
	my $self = shift @_;
	return undef;
}

sub install {
	my $self = shift @_;
	return if ($self->is_installed());
	$self->build();
	$self->log("installing");
	
}

sub is_installed {
	my $self = shift @_;
	return undef;
}





sub dependency_names {
	return ();
}

sub dependencies {
	my $self = shift;
	return @{$self->{dependencies}};
}



sub is_downloaded {
	my $self = shift @_;
	return -f $self->download_path()
}



sub download {

	my $self = shift @_;

	$_->download() foreach $self->dependencies();

	return if ($self->is_downloaded());
	$self->log("downloading $self from " . $self->url());
	$self->shell('curl', '-o', $self->download_path(), $self->url());

}



sub unpack {

	my $self = shift @_;

	return if ($self->is_unpacked());
	$self->download();
	$self->log('unpacking');
	$self->cd_srcdir();
	$self->shell('tar -xzf', $self->download_path());

}




sub is_unpacked {
	my $self = shift @_;
	return -d $self->packagesrcdir();
}




sub cd_srcdir {
	my $self = shift @_;
	$self->cd($self->config()->srcdir());
}

sub cd_packagesrcdir {
	my $self = shift @_;
	$self->cd($self->packagesrcdir());
}


sub make_flags {

	my $self = shift @_;

	my $cpus = $self->config()->cpus();
	return $cpus > 1 ? " -j $cpus " : "";

}




sub shortname {

	my $self = shift @_;
	my $class = ref($self) || $self;
	my ($shortname) = $class =~ /::([^:]+)$/;

	return $shortname;

}


sub to_string {

	my $self = shift @_;

	my $shortname = $self->shortname();
	return "[package $shortname]";

}



1;

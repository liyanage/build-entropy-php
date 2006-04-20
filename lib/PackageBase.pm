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



# subclasses should override and call this and do
# nothing if this does not return true
#
sub build {

	my $self = shift @_;
	return undef if ($self->is_built());

	$self->unpack();

	$_->install() foreach $self->dependencies();

	$self->log("building");
	
	return 1;

}

sub is_built {
	my $self = shift @_;
	return undef;
}


# subclasses should override and call this and do
# nothing if this does not return true
#
sub install {
	my $self = shift @_;
	return undef if ($self->is_installed());
	$self->build();
	$self->log("installing");
	
	return 1;
	
}


sub is_installed {
	my $self = shift @_;
	my $subpath = $self->subpath_for_check();
	my $exists = -e $self->install_prefix() . "/$subpath";
	$self->log("not installing because '$subpath' exists") if ($exists);
	return $exists;
}


sub subpath_for_check {
	Carp::confess "subclasses must implement this method or provide a different is_installed() implementation"
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
#	$self->log("is unpacked: " . $self->packagesrcdir() . ": " . -d $self->packagesrcdir());
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

sub make_command {
	my $self = shift @_;
	return "make" . $self->make_flags();
}



sub configure_flags {
	my $self = shift @_;
	return "--prefix=" . $self->install_prefix();
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



sub extras_dir {

	my $self = shift @_;

	return $self->config()->basedir() . '/extras/' . $self->shortname();	

}



sub extras_path {

	my $self = shift @_;
	my ($filename) = @_;
	
	return $self->extras_dir() . "/$filename";

}


sub cflags {

	my $self = shift @_;

	return '';
	
}


sub install_prefix {

	my $self = shift @_;
	return $self->config()->prefix();
	
}

# prefix for packages we don't want to bundle
sub install_tmp_prefix {

	my $self = shift @_;
	return $self->config()->basedir() . "/install-tmp";
	
}



sub supported_archs {

	return qw(ppc i386);

}

sub supports_arch {

	my $self = shift @_;
	my ($arch) = @_;
	
	return grep {$_ eq $arch} $self->supported_archs();

}





sub php_extension_configure_flags {
	return "";
}





1;

package Obj;

use strict;
use warnings;

use Imports;

our $VERSION = '1.0';
use vars qw($AUTOLOAD);




sub new {

	my $self = shift @_;
	my (%args) = @_;
	
	my $class = ref($self) || $self;
	$self = bless {%args}, $class;
	$self->{$_} ||= undef foreach qw(config shell);
	$self->init_shell();	
	$self->init(%args);
	Hash::Util::lock_keys(%$self);
	
	return $self;

}


sub init {
}

sub init_shell {
	my $self = shift @_;
	$self->shell(Shell->new());
}


sub log {

	my $self = shift @_;
	my ($message) = @_;
	
	my ($sec,$min,$hour,$mday,$mon,$year) = localtime();
	
	warn(sprintf("[%04d-%02d-%02d %02d:%02d:%02d] %s: %s\n", $year + 1900, $mon + 1, $mday, $hour, $min, $sec, $self, $message));

}


sub cd {

	my $self = shift @_;
	my ($dir) = @_;
	
	chdir($dir) or die "Unable to chdir to '$dir'";

	$self->log("directory is now $dir");

}


sub do_shell {

	my $self = shift @_;
	my (@items) = @_;

	my $cmd = join(" ", @items);
	$cmd .= " 2>&1";

	$self->log("execute: $cmd");

#	my $output = `$cmd`;
	my $output = '';
	system($cmd);
	my $status = $? >> 8;

	if ($status) {
		die "shell command failed with status '$status': '$cmd', output='$output'";
	}
	
	return $output;

}






sub AUTOLOAD {

	my $self = shift @_;
	my ($value) = @_;

	my ($method) = $AUTOLOAD =~ /::([^:]+)$/;

	if ($method eq 'DESTROY') {
		return $self->can('DESTROY') ? $self->SUPER::DESTROY(@_) : undef;
	}

	die "AUTOLOAD call for '$method'" if ($method eq 'AUTOLOAD');
	
	unless (exists($self->{$method})) {
		Carp::croak("No property named '$method'");
	}
	
	return undef unless ($method);
	$self->{$method} = $value if (@_);
	return $self->{$method};

}





1;


package Obj;

use strict;
use warnings;
use overload '""' => 'to_string';

use Imports;

our $VERSION = '1.0';
use vars qw($AUTOLOAD);




sub new {

	my $self = shift @_;
	my (%args) = @_;
	
	my $class = ref($self) || $self;
	$self = bless {%args}, $class;
	$self->{$_} ||= undef foreach qw(config);
	$self->init(%args);
	Hash::Util::lock_keys(%$self);
	
	return $self;

}


sub init {
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

# $self->shell('nonfatal', 'silent', )
# $self->shell({fatal => 0, silent => 1}, )

sub shell {

	my $self = shift @_;
	my (@items) = @_;

	my $options = ref($items[0]) ? shift @items : {};
	$options->{fatal}  = 1 unless exists($options->{fatal});
	$options->{silent} = 1 unless exists($options->{silent});
	$options->{log}    = 1 unless exists($options->{log});

	my $cmd = join(" ", @items, " 3>&1 2>&3");
	$cmd .= " 1>>/tmp/build-entropy-php.log" if $options->{silent};
#	$cmd .= " | tee /tmp/shell-$$.stdout";

	$self->log("run shell: $cmd") if ($options->{log});
	
#	my $output = `$cmd`;
#	my $output = '';
	system($cmd);
	my $status = $? >> 8;
	
	if ($status) {
		my $msg = "shell command failed with status '$status': '$cmd'"; #, output='$output'
		if ($options->{fatal}) {
			Carp::confess "fatal: $msg";
		} else {
			$self->log("nonfatal: $msg");
		}
	}

#	return $output;

}


sub dir_content {
	my $self = shift @_;
	return grep {!/^\.+$/} IO::Dir->new($_[0])->read();
}

sub file_content {
	my $self = shift @_;
	my ($filename) = @_;
	return do {undef local($/); IO::File->new($filename)->getline()};
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
		Carp::confess("No property named '$method'");
	}
	
	return undef unless ($method);
	$self->{$method} = $value if (@_);
	return $self->{$method};

}




sub to_string {

	my $self = shift @_;

	my $class = ref($self) || $self;
	return "[$class]";

}






1;


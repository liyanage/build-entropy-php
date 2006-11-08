package UBSplicer;

use strict;
use warnings;

use base qw(Obj);


our $VERSION = '1.0';

our @KNOWN_ARCHS = qw(ppc i386);
our $MASTER_ARCH = $KNOWN_ARCHS[0];

our @EXECUTABLE_REGEXES = (
	qr/^Mach-O/,
	qr/ar archive/,
);



sub init {

	my $self = shift @_;
	
	die "basedir constructor argument must point to a directory" unless (-d $self->basedir());

	my @archs = grep {my $__ = $_; grep {$__ eq $_} @KNOWN_ARCHS} $self->dir_content($self->basedir());
	
#	$self->log("found archs: @archs");
	
	die "Number of archs != 2: '@archs'" if (@archs != 2);

}





sub run {

	my $self = shift @_;

	$self->process_dir('');
	
}




sub process_dir {

	my $self = shift @_;
	my ($subpath) = @_;

	my $universaldir = $self->universal_path($subpath);

	unless (-d $universaldir || mkdir($universaldir)) {
		die "unable to find or create output directory '$universaldir'";
	}

	my $subdir_path = $self->master_path($subpath);
	my @items = $self->dir_content($subdir_path);

	foreach my $item (@items) {

		my $itempath = "$subdir_path/$item";
		my $subpath = "$subpath/$item";

		if (-l $itempath) {
			$self->copy($subpath);
		} elsif (-d $itempath) {
			$self->process_dir($subpath);
		} elsif (-f $itempath) {
			$self->process_file($subpath);
		} else {
			die "encountered unknown file type of file '$itempath'";
		}
		
	}

}



sub copy {

	my $self = shift @_;
	my ($subpath) = @_;

	my $master = $self->master_path($subpath);
	my $universal = $self->universal_path($subpath);
	
	$self->shell({log => 0}, "cp -Rp $master $universal");

}


sub process_file {

	my $self = shift @_;
	my ($subpath) = @_;

	my $master = $self->master_path($subpath);

	my $filetype = `file -b $master`;

	my $is_executable = grep {$filetype =~ /$_/} @EXECUTABLE_REGEXES;

#	$self->log("filetype ($is_executable): $filetype");

	my @archs = grep {-e $_} $self->arch_paths($subpath);
	return $self->copy($subpath) unless ($is_executable and @archs > 1);

	my $universal = $self->universal_path($subpath);
	$self->log("running lipo for $subpath");
	$self->shell({log => 0}, "lipo -create @archs -output $universal");

}


sub universal_path {

	my $self = shift @_;
	my ($subpath) = @_;

	return $self->basedir() . "/universal/$subpath";

}

sub master_path {

	my $self = shift @_;
	my ($subpath) = @_;

	return $self->basedir() . "/$MASTER_ARCH/$subpath";

}

sub arch_paths {
	
	my $self = shift @_;
	my ($subpath) = @_;

	return map {$self->basedir() . "/$_/$subpath"} @KNOWN_ARCHS;

}


sub to_string {
	
	my $self = shift @_;
	
	return "[UBSplicer at " . $self->basedir() . "]";
	
}




1;


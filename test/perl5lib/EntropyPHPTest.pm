#!/usr/bin/perl

package EntropyPHPTest;

use strict;
use warnings;

use LWP::UserAgent;


sub new {
	my $self = shift @_;
	my (%args) = @_;
	
	my $class = ref($self) || $self;
	$self = bless {%args}, $class;
	
	return $self;
}

sub run {
	my $self = shift;
	die "subclasses must override this";
}


# static for the command line driver
sub run_test {
	my $self = shift;
	my $instance = $self->new(@_);
	$instance->run();
}


sub ua {
	my $self = shift;
	return LWP::UserAgent->new();
}


sub get_url_success {
	my $self = shift;
	my ($path) = @_;
	my $url = "$self->{base_url}/$path";
	my $response = $self->ua()->get($url);
	if (!$response->is_success()) {
		die "Request to '$url' failed: " . $response->status_line();
	}
	return $response->decoded_content();
}


1;
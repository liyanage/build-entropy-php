#!/usr/bin/perl

package EntropyPHPTest::Arch;
use base qw(EntropyPHPTest);


use strict;
use warnings;
use Test::More qw(no_plan);


sub run {
	my $self = shift;
	my $content = $self->get_url_success('test-phpinfo.php');
	my ($arch) = $content =~ /this machine runs: (\w+)/;
#	print $content;
	is($arch, $self->{current_test_arch}, "current_test_arch");
}


1;

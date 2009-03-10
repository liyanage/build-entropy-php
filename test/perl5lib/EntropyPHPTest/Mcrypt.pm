#!/usr/bin/perl

package EntropyPHPTest::Mcrypt;
use base qw(EntropyPHPTest);


use strict;
use warnings;
use Test::More qw(no_plan);


sub run {
	my $self = shift;
	my $content = $self->get_url_success('test-mcrypt.php');
	is($content, 'This is very important data', ref($self));
}


1;

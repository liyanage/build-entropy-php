#!/usr/bin/perl

use strict;
use warnings;
use IO::Dir;


my ($basedir) = grep {-d} map {"$_/EntropyPHPTest"} @INC;
die unless $basedir;

my @testclasses = map {"EntropyPHPTest::$_"} map {/(.+)\.pm$/} IO::Dir->new($basedir)->read();

foreach my $class (@testclasses) {
	print "Running test class $class\n";
	eval "use $class";
	die if $@;
	eval {
		$class->run_test(@ARGV);
	};
	if ($@) {
		warn "Test $class failed: $@\n";
	}
}

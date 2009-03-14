#!/usr/bin/perl

use strict;
use warnings;
use IO::Dir;
use LWP::UserAgent;

use Test::More tests => 3;

my %conf = @ARGV;
my $content;

$content = get_url_success('test-phpinfo.php');
($content) = $content =~ /this machine runs: (\w+)/;
is($content, $conf{current_test_arch}, "current_test_arch");

$content = get_url_success('test-mcrypt.php');
is($content, "This is very important data\n", 'mcrypt');

$content = get_url_success("test-mysql.php?mysql_socket=$conf{mysql_dir}/mysql-test.sock");
like($content, qr/Resource id #\d+, test value: 2/, "mysql connection");


sub ua {
	return LWP::UserAgent->new();
}


sub get_url_success {
	my ($path) = @_;
	my $url = "$conf{base_url}/$path";
	my $response = ua()->get($url);
	if (!$response->is_success()) {
		die "Request to '$url' failed: " . $response->status_line();
	}
	return $response->decoded_content();
}


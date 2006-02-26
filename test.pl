
# asdfdsfeasdfas sadfsadf
# asdfasdfgf


use strict;
use warnings;

use Imports;
use Package::php5;


my $config = Config->new(
	basedir => '/Users/liyanage/svn/entropy/universalbuild',
	prefix  => '/Users/liyanage/svn/entropy/universalbuild/install',
	cpus    => 2,
);

my $package = Package::php5->new(config => $config);

$package->install();



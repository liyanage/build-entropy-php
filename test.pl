
use strict;
use warnings;

use Imports;
use Package::php5;


my $config = Config->new(
	basedir => '/Users/liyanage/Desktop/universalbuild',
	prefix  => '/Users/liyanage/Desktop/universalbuild/install',
);

my $package = Package::php5->new(config => $config);

$package->install();



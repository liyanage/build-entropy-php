
# asdfdsfeasdfas sadfsadf
# asdfasdfgf


use strict;
use warnings;

use Imports;
use Package::php5;


my $config = Config->new(
	basedir              => '/Users/liyanage/svn/entropy/universalbuild',
	prefix               => '/Users/liyanage/svn/entropy/universalbuild/install',
	mysql_install_prefix => undef,
	cpus                 => 2,
);

my $php5 = Package::php5->new(config => $config);

$php5->distimage();



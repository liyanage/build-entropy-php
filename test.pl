
# asdfdsfeasdfas sadfsadf
# asdfasdfgf


use strict;
use warnings;

use Imports;
use Package::php5;


my $config = Config->new(
	basedir              => '/Users/liyanage/svn/entropy/universalbuild',
	prefix               => '/usr/local/php5',
	orahome              => '/Users/liyanage/svn/entropy/universalbuild/install',
	pdflib_lite          => 1,
	mysql_install_prefix => undef,
	cpus                 => 2,
	version              => '5.1.3',
	release              => 3,
);

my $php5 = Package::php5->new(config => $config);

$php5->create_distimage();



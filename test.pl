
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
	variants             => {
		apache1          => {
			apxs_option  => '--with-apxs',
			suffix       => '',
		},
		apache2          => {
			apxs_option  => '--with-apxs2=/usr/local/apache2/bin/apxs',
			suffix       => '-apache2',
		},
	},
	version              => '5.2.0',
	release              => 2,
);

my $php5 = Package::php5->new(config => $config, variant => 'apache1');

$php5->create_distimage();



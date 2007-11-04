
# Main driver script for the PHP build process
#
# Invoke with
#     sudo perl -Ilib build-php.pl
#

use strict;
use warnings;

use Imports;
use Package::php5;

use Package::libxml2;
#use Package::libxslt;
#use Package::mcrypt;


my $config = Config->new(
	basedir              => '/Users/liyanage/Desktop/universalbuild/universalbuild',
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
			apxs_option  => '--with-apxs2=/usr/sbin/apxs',
			suffix       => '-apache2',
		},
	},
	version              => '5.2.4',
	release              => 4,
);

#my $php5 = Package::php5->new(config => $config, variant => 'apache2');
#$php5->create_distimage();


#my $p = Package::php5->new(config => $config, variant => 'apache2');
my $p = Package::libxml2->new(config => $config, variant => 'apache2');
$p->install();




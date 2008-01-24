# Main driver script for the PHP build process
#
# Invoke with
#     sudo perl -Ilib build-php.pl
#

use strict;
use warnings;

use Imports;
use Package::php5;


my $config = Config->new(
	cpus                 => 2,
	basedir              => '/Users/liyanage/svn/entropy/universalbuild',
	prefix               => '/usr/local/php5',
	orahome              => '/Users/liyanage/svn/entropy/universalbuild/install',
	pdflib_lite          => 1,
	mysql_install_prefix => undef,
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
	version              => '5.2.5',
	release              => 7,
	debug                => 1,
);

#my $php5 = Package::php5->new(config => $config, variant => 'apache2');
#$php5->create_distimage();

my $p = Package::php5->new(config => $config, variant => 'apache2');
$p->install();



# use Package::ming;
# my $p = Package::ming->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::postgresql;
# my $p = Package::postgresql->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::imapcclient;
# my $p = Package::imapcclient->new(config => $config, variant => 'apache2');
# $p->install();


# use Package::mysql;
# my $p = Package::mysql->new(config => $config, variant => 'apache2');
# $p->install();




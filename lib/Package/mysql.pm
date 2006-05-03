package Package::mysql;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '5.0.19';

sub init {

	my $self = shift @_;

	$self->SUPER::init(@_);
	
	$self->config()->mysql_install_prefix($self->install_prefix());

}


sub base_url {
	return "ftp://ftp.solnet.ch/mirror/mysql/Downloads/MySQL-5.0/";
}


sub packagename {
	return "mysql-" . $VERSION;
}



sub subpath_for_check {
	return "lib/mysql/libmysqlclient.dylib";
}


# sub install_prefix {
# 	my $self = shift @_;
# 	return $self->install_tmp_prefix() . "/mysql";
# }
# 


sub install {

	my $self = shift @_;

	return undef unless ($self->SUPER::install());

# 	$self->log("removing dynamic libraries to force static link");
# 	$self->shell("rm " . $self->install_prefix() . "/lib/mysql/*.dylib");
# 	$self->shell("ranlib " . $self->install_prefix() . "/lib/mysql/*.a");

	return 1;
}

sub make_command {
	my $self = shift @_;
	return $self->SUPER::make_command() . " -j 1"
}



sub php_extension_configure_flags {

	my $self = shift @_;
	my (%args) = @_;

	my $mysql_prefix = $self->config()->mysql_install_prefix();
	die "mysql install prefix '$mysql_prefix' does not exist" unless (-d $mysql_prefix);

	return "--with-mysql=shared,$mysql_prefix --with-mysqli=shared,$mysql_prefix/bin/mysql_config --with-pdo-mysql=shared,$mysql_prefix";

}



sub php_dso_extension_names {
	my $self = shift @_;
	return qw(mysql mysqli pdo_mysql);
}



sub package_filelist {

	my $self = shift @_;

	return qw(
		lib/php/extensions/no-debug-non-zts-20050922/mysql
		lib/php/extensions/no-debug-non-zts-20050922/mysqli
		lib/php/extensions/no-debug-non-zts-20050922/pdo_mysql
		lib/mysql/lib*.dylib
		php.d/50-extension-*mysql*.ini
	);
	
}





1;
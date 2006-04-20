package Package::php5;

use strict;
use warnings;

use base qw(PackageSplice);

our $VERSION = '5.1.2';
our $RELEASE = 4;




sub base_url {
	return "http://us2.php.net/distributions";
}


sub packagename {
	return "php-$VERSION";
}


sub dependency_names {
	return qw(curl mysql libxml2 libxslt pdflib oracleinstantclient
		imapcclient libjpeg libpng libfreetype);
}


sub subpath_for_check {
	return "libphp5.so";
}


sub configure_flags {
	my $self = shift @_;
	my %args = @_;
	my $prefix = $self->config()->prefix();

	my @extension_flags = (
		"--with-config-file-scan-dir=$prefix/config",
		'--with-iconv',
		'--with-openssl=/usr',
		'--with-zlib=/usr',
		"--with-gd",
		'--with-zlib-dir=/usr',
		"--with-ldap",
		"--with-iodbc=shared,/usr",
		"--with-xmlrpc",
		"--with-iconv-dir=/usr",
		"--enable-exif",
		"--enable-wddx",
		"--enable-soap",
		"--enable-sqlite-utf8",
		"--enable-ftp",
		"--enable-sockets",
		"--enable-dbx",
		"--enable-dbase",
		"--enable-mbstring",
		"--enable-calendar",
		"--with-bz2=/usr",
	);

	push @extension_flags, $self->dependency_extension_flags(%args);

	return $self->SUPER::configure_flags() . " --with-apxs @extension_flags";
	
}



sub dependency_extension_flags {

	my $self = shift @_;
	my (%args) = @_;

	return map {$_->php_extension_configure_flags()} grep {$_->supports_arch($args{arch})} $self->dependencies();

}



sub build_arch_pre {

	my $self = shift @_;
	my (%args) = @_;

	$self->cd('ext');
	$self->shell("rm -rf pdf");
	my $pdflib_extension_tarball = $self->extras_dir() . "/pdflib-2.0.5.tgz";
	die "pdflib extensions tarball '$pdflib_extension_tarball' does not exist" unless (-f $pdflib_extension_tarball);

	$self->shell("tar -xzvf $pdflib_extension_tarball");
	$self->shell("mv pdflib-2.*.* pdf; rm package.xml");

	$self->cd_packagesrcdir();
	$self->shell("aclocal");
	$self->shell("./buildconf --force");
	$self->shell({fatal => 0}, "ranlib " . $self->install_prefix() . "/lib/*.a");
	$self->shell({fatal => 0}, "ranlib " . $self->install_tmp_prefix() . "/lib/*.a");

}





sub make_install_arch {

	my $self = shift @_;
	my (%args) = @_;

	my $install_override = $self->make_install_override_list(prefix => $args{prefix});

	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli pear build headers programs modules);
	$self->shell("cp libs/libphp5.so $args{prefix}");

}



sub install {

	my $self = shift @_;

	$self->SUPER::install(@_);
	
	my $extrasdir = $self->extras_dir();
	my $prefix = $self->config()->prefix();

	$self->cd_packagesrcdir();
	$self->shell({silent => 0}, "cat $extrasdir/dist/httpd.conf.php | sed -e 's!{prefix}!$prefix!g' > $prefix/httpd.conf.php");
	$self->shell({silent => 0}, "cp php.ini-recommended $prefix/lib/");
	$self->shell({silent => 0}, "mkdir $prefix/php.d");

}



sub distimage {

	my $self = shift @_;

	$self->install();


}


sub unpack {

	my $self = shift @_;

	$self->SUPER::unpack();

	my $patchfile = $self->extras_path('php-entropy.patch');
	my $mingtarball = $self->extras_path('ming.tar.gz');
	
	$self->cd_packagesrcdir();
	$self->shell("grep -q ENTROPY_CH ext/standard/info.c || patch -p1 < $patchfile");
	$self->cd("ext");
	$self->shell("tar -xzf $mingtarball");

}


sub cflags {

	my $self = shift @_;
	
	return $self->SUPER::cflags(@_) . " -DENTROPY_CH_RELEASE=$RELEASE"

}



1;

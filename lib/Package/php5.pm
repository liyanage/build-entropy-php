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
	#jpeg png freetype
}


sub subpath_for_check {
	return "libphp5.so";
}


sub configure_flags {
	my $self = shift @_;
	my %args = @_;
	my $prefix = $self->config()->prefix();

	my $mysql_prefix = $self->config()->mysql_install_prefix();
	die "mysql instal prefix '$mysql_prefix' does not exist" unless (-d $mysql_prefix);

	my @extension_flags = (
		'--with-iconv',
		'--with-openssl=/usr',
		'--with-zlib=/usr',
		"--with-mysql=$mysql_prefix",
		"--with-mysqli=$mysql_prefix/bin/mysql_config",
		"--with-libxml-dir=$prefix",
		"--with-xsl=$prefix",
		"--with-curl=$prefix",
		"--with-pdflib=$prefix",
		"--with-gd",
		"--enable-gd-native-ttf",
		"--with-jpeg-dir=$prefix",
		"--with-png-dir=$prefix",
		'--with-zlib-dir=/usr',
		"--with-freetype-dir=$prefix",
		"--with-imap=../imap-2004g",
		"--with-kerberos=/usr",
		"--with-imap-ssl=/usr",
		"--with-ldap",
		"--with-iodbc=/usr",
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


	# add some PPC-only extensions if this is a PPC build
	if ($args{arch} eq 'ppc') {
		# add some PPC-only extensions if this is a PPC build

		push @extension_flags, (
			"--with-oci8=instantclient,$prefix/oracle",
			"--with-pdo-oci=instantclient,$prefix/oracle,10.1.0.3",
		);

	}


	return $self->SUPER::configure_flags() . " --with-apxs @extension_flags";
	
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

	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli pear build headers programs);
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
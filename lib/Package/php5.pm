package Package::php5;

use strict;
use warnings;

use IO::File;

use base qw(PackageSplice);



sub base_url {
	return "http://us2.php.net/distributions";
}


sub packagename {
	my $self = shift @_;
	return "php-" . $self->config()->version();
}


sub dependency_names {
	return qw(curl mysql libxml2 libxslt pdflib oracleinstantclient
		imapcclient libjpeg libpng libfreetype iodbc postgresql t1lib
		gettext ming mcrypt mhash mssql frontbase);
}


sub subpath_for_check {
	return "libphp5.so";
}


# broken ming build setup can not handle distclean target
sub cleanup_srcdir {
	my $self = shift @_;
	$self->cd_srcdir();
	$self->shell("rm -rf php-*");
	$self->unpack();
}


sub configure_flags {
	my $self = shift @_;
	my %args = @_;
	my $prefix = $self->config()->prefix();

	# mime-magic not ported from old distribution because it is deprecated

	my @extension_flags = (
		"--with-config-file-scan-dir=$prefix/php.d",
		'--with-iconv',
		'--with-openssl=/usr',
		'--with-zlib=/usr',
		"--with-gd",
		'--with-zlib-dir=/usr',
		"--with-ldap",
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

#http://www.frontbase.com/download/Download_4.2.4/MacOSX-10.4u/FrontBase-MacOSX-4.2.4.dmg

#         --with-pdflib=$(INSTDIR) \

#         --with-fbsql=$(FRONTBASE_INSTDIR)/Library/FrontBase \
#         --enable-openbase_module




sub dependency_extension_flags {

	my $self = shift @_;
	my (%args) = @_;

	return map {$_->php_extension_configure_flags()} grep {$_->supports_arch($args{arch})} $self->dependencies();

}



sub build_arch_pre {

	my $self = shift @_;
	my (%args) = @_;

	# replace pdflib extension module source with newer version
	$self->cd('ext');
	$self->shell("rm -rf pdf");
	my $pdflib_extension_tarball = $self->extras_dir() . "/pdflib-2.0.5.tgz";
	die "pdflib extensions tarball '$pdflib_extension_tarball' does not exist" unless (-f $pdflib_extension_tarball);
	$self->shell("tar -xzvf $pdflib_extension_tarball");
	$self->shell("mv pdflib-2.*.* pdf; rm package.xml");

	# replace pdo_mysql extension module source with newer version
# 	my $pdo_mysql_tarball = $self->config()->downloaddir() . "/PDO_MYSQL-1.0.2.tgz";
# 	if (! -e $pdo_mysql_tarball) {
# 		$self->shell("curl -o $pdo_mysql_tarball http://pecl.php.net/get/PDO_MYSQL-1.0.2.tgz");
# 	}
# 	$self->cd_packagesrcdir();
# 	$self->cd('ext');
# 	$self->shell("rm -rf pdo_mysql");
# 	$self->shell("tar -xzvf $pdo_mysql_tarball");
# 	$self->shell("mv PDO_MYSQL-1.0.2 pdo_mysql; rm package.xml package2.xml");

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

	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli build headers programs modules);
	$self->shell("cp libs/libphp5.so $args{prefix}");

}



sub install {

	my $self = shift @_;

	$self->SUPER::install(@_);
	
	my $extrasdir = $self->extras_dir();
	my $prefix = $self->config()->prefix();


	$self->cd_packagesrcdir();
	$self->shell({silent => 0}, "cat $extrasdir/dist/entropy-php.conf | sed -e 's!{prefix}!$prefix!g' > $prefix/entropy-php.conf");
	$self->shell({silent => 0}, "cat $extrasdir/dist/activate-entropy-php.py | sed -e 's!{prefix}!$prefix!g' > $prefix/bin/activate-entropy-php.py");
	$self->shell({silent => 0}, "cp php.ini-recommended $prefix/lib/");
	unless (-e "$prefix/etc/pear.conf.default") {
		$self->shell($self->make_command(), "install-pear");
#		$self->shell({silent => 0}, qq!sed -e 's#"[^"]*$prefix\\([^"]*\\)#"$prefix\\1"#g' < $prefix/etc/pear.conf > $prefix/etc/pear.conf.default!);
#		$self->shell({silent => 0}, "rm $prefix/etc/pear.conf");
		$self->shell({silent => 0}, "mv $prefix/etc/pear.conf $prefix/etc/pear.conf.default");
	}
	$self->shell({silent => 0}, "test -d $prefix/php.d || mkdir $prefix/php.d");
	$self->shell({slient => 0}, "perl -p -i -e 's# -L\\S+c-client##' $prefix/bin/php-config");

	$self->create_dso_ini_files();

}



sub create_dso_ini_files {

	my $self = shift @_;

	my @dso_names = grep {$_} map {$_->php_dso_extension_names()} $self->dependencies();
	my $prefix = $self->config()->prefix();
	$self->shell({silent => 0}, "echo 'extension=$_.so' > $prefix/php.d/50-extension-$_.ini") foreach (@dso_names);
	$self->shell({silent => 0}, qq!echo 'extension_dir=$prefix/lib/php/extensions/no-debug-non-zts-20050922' > $prefix/php.d/10-extension_dir.ini!);

}




sub create_distimage {

	my $self = shift @_;

	$self->install();

	$self->create_package();

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
	
	return $self->SUPER::cflags(@_) . " -DENTROPY_CH_RELEASE=" . $self->config()->release();

}




sub package_filelist {

	my $self = shift @_;

	return qw(
		entropy-php.conf
		libphp5.so
		etc/pear.conf.default
		lib/libxml2*.dylib lib/libpng*.dylib lib/libfreetype*.dylib lib/libt1*.dylib
		bin/php* bin/pear bin/pecl bin/peardev bin/activate-*
		lib/php
		lib/php.ini-recommended
		include/php
		php.d/10-extension_dir.ini
	);
	
}





sub create_package {

	my $self = shift @_;

	$self->SUPER::create_package(@_);

	$self->create_metapackage();

}


sub create_metapackage {

	my $self = shift @_;

	$self->log("metapackaging");
	
#	my $dir = "/tmp/universalbuild-pkg/" . $self->shortname() . '-meta';
	my $dst = '/tmp/' . $self->mpkg_filename();

	my @sed_cmds = $self->info_substitution_sed_cmds();

	my $infofile = $self->extras_path('metapackage/Info.plist');
	$self->shell({silent => 0}, "cat $infofile @sed_cmds > $infofile.out");
	my $descfile = $self->extras_path('metapackage/Description.plist');
	$self->shell({silent => 0}, "cat $descfile @sed_cmds > $descfile.out");
	my $resdir = $self->extras_path('metapackage/resources');

	$self->shell({silent => 0}, "/Developer/Tools/packagemaker -build -mi '/tmp/universalbuild-pkgdst' -ds -v -r '$resdir' -i '$infofile.out' -d '$descfile.out' -p '$dst'");

	my $version = $self->config()->version() . '-' . $self->config()->release();

	my $xslt = $self->extras_path('metapackage/info-plist-postprocess.xslt');
	$self->shell({silent => 0}, "xsltproc --stringparam version $version -o $dst/Contents/Info.plist.out $xslt $dst/Contents/Info.plist && mv -f $dst/Contents/Info.plist.out $dst/Contents/Info.plist"); 

	$self->shell('open /tmp/');
	
}



sub package_infofile {
	my $self = shift @_;
	return $self->extras_path('/package/Info.plist');
}

sub package_descfile {
	my $self = shift @_;
	return $self->extras_path('/package/Description.plist');
}

sub package_resdir {
	my $self = shift @_;
	return $self->extras_path('/package/resources');
}



sub prepackage_hook {

	my $self = shift @_;
	my ($pkgroot) = @_;
	
	$self->shell("mkdir -p $pkgroot/lib/php/extensions/no-debug-non-zts-20050922");
	$self->shell("mkdir -p $pkgroot/php.d");

}


sub pkg_filename {
	my $self = shift @_;
	my $version = $self->config()->version() . '-' . $self->config()->release();
	return "entropy-php-$version.pkg";
}

sub mpkg_filename {
	my $self = shift @_;
	my $version = $self->config()->version() . '-' . $self->config()->release();
	return "entropy-php-$version.mpkg";
}









1;

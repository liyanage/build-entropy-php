package Package::php5;

use strict;
use warnings;

use IO::File;
use IO::Dir;

use base qw(Package);

# todo:
# rework this so it runs normally and a third time for the cli version.
# add the new cli/cgi (?) as php-cli or php-cgi
# enable --enable-pcntl and fastcgi for the cgi version
# switch to pdflib 7

sub base_url {
	return "http://us2.php.net/distributions";
}


sub packagename {
	my $self = shift @_;
	return "php-" . $self->config()->version();
}


sub dependency_names {
	#oracleinstantclient
	#iodbc
	#t1lib
	#frontbase 
	#openbase
	#pdflib
	#tidy 
	#ming
	return qw(pdflib_commercial mssql mhash memcache imapcclient libxml2 libxslt gettext curl libpng libjpeg libfreetype mysql postgresql mcrypt);
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
		'--with-openssl=/usr',
		'--with-zlib=/usr',
		'--with-zlib-dir=/usr',
		'--with-gd',
		'--with-ldap',
		'--with-xmlrpc',
		'--enable-exif',
		'--enable-soap',
		'--enable-sqlite-utf8',
		'--enable-wddx',
		'--enable-ftp',
		'--enable-sockets',
		'--with-bz2=/usr',
		'--enable-zip',
		'--enable-pcntl',
		'--enable-shmop',
		'--enable-sysvsem',
		'--enable-sysvshm',
		'--enable-sysvmsg',
 		'--enable-memory-limit',
 		'--enable-mbstring',
 		'--enable-bcmath',
 		'--enable-calendar',
 		'--with-iodbc',
	);

#		'--with-snmp=/usr', #32 bit only in leopard


# 		"--enable-dbx",
# 		"--enable-dbase",
# 		"--with-bz2=/usr",
# 		"--enable-fastcgi",
# 		"--enable-cgi",



	push @extension_flags, $self->dependency_extension_flags(%args);
	
	my $apxs_option = $self->config()->variants()->{$self->{variant}}->{apxs_option};
	return $self->SUPER::configure_flags() . " $apxs_option @extension_flags";
	
}

#http://www.frontbase.com/download/Download_4.2.4/MacOSX-10.4u/FrontBase-MacOSX-4.2.4.dmg

#         --with-pdflib=$(INSTDIR) \

#         --with-fbsql=$(FRONTBASE_INSTDIR)/Library/FrontBase \
#         --enable-openbase_module



#sub build_postconfigure {
#	my $self = shift @_;
#	my (%args) = @_;

#	my $path = $self->extras_path('php-configure-time-endianness-check-fix.c');
#	$self->shell("(cat '$path' >> main/php_config.h)");
#}




sub build_preconfigure {
	my $self = shift @_;
	my (%args) = @_;

	# give extension modules a chance to tweak the contents of the ext directory
	foreach my $dependency ($self->dependencies()) {
		$self->cd_packagesrcdir();
		$self->cd('ext');
		$dependency->php_build_pre(%args, php_package => $self);
	}

	$self->cd_packagesrcdir();
	$self->shell("aclocal");
	$self->shell("./buildconf --force");
	$self->shell({fatal => 0}, "ranlib " . $self->install_prefix() . "/lib/*.a");
	$self->shell({fatal => 0}, "ranlib " . $self->install_tmp_prefix() . "/lib/*.a");

}


	





sub dependency_extension_flags {
	my $self = shift @_;
	my (%args) = @_;

	# fixme: figure out something for extensions with fewer archs
#	return map {$_->php_extension_configure_flags()} grep {$_->supports_arch($args{arch})} $self->dependencies();

	return map {$_->php_extension_configure_flags()} $self->dependencies();
}





# sub build_arch_pre {
# 
# 	my $self = shift @_;
# 	my (%args) = @_;
# 
# 	# give extension modules a chance to tweak the contents of the ext directory
# 	
# 	foreach my $dependency ($self->dependencies()) {
# 		$self->cd_packagesrcdir();
# 		$self->cd('ext');
# 		$dependency->php_build_arch_pre(%args, php_package => $self);
# 	}
# 	
# 	$self->cd_packagesrcdir();
# 	$self->shell("aclocal");
# 	$self->shell("./buildconf --force");
# 	$self->shell({fatal => 0}, "ranlib " . $self->install_prefix() . "/lib/*.a");
# 	$self->shell({fatal => 0}, "ranlib " . $self->install_tmp_prefix() . "/lib/*.a");
# 
# }



# sub make_install_arch {
# 
# 	my $self = shift @_;
# 	my (%args) = @_;
# 
# 	my $install_override = $self->make_install_override_list(prefix => $args{prefix});
# 
# 	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli build headers programs modules);
# 
# #	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cgi build headers programs modules);
# #	$self->shell("mv $args{prefix}/bin/php $args{prefix}/bin/php-cgi");
# 
# #	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli);
# 	$self->shell("cp libs/libphp5.so $args{prefix}");
# 
# 	$self->shell("rm $args{prefix}/lib/php/extensions/*/*.a");
# 
# }
# 
# 



sub install {

	my $self = shift @_;

	$self->build();

	my $dst = $self->install_prefix();
	system("mkdir -p $dst");
	die "Unable to find or create installation dir '$dst'" unless (-d $dst);

	my $install_override = $self->make_install_override_list(prefix => $dst);
 	$self->shell($self->make_command() . " $install_override install-$_") foreach qw(cli build headers programs modules);

 	$self->shell("cp libs/libphp5.so $dst");
 	$self->shell("rm $dst/lib/php/extensions/*/*.a");


#	$self->SUPER::install(@_);
	
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

	$self->shell({slient => 0}, "sudo chown -R root:wheel '$prefix'");
	$self->shell({slient => 0}, "test -e '$prefix/lib/php/build' || sudo ln -s '$prefix/lib/build' '$prefix/lib/php/'");

}



sub create_dso_ini_files {

	my $self = shift @_;

	my @dso_names = grep {$_} map {$_->php_dso_extension_names()} $self->dependencies();
	my $prefix = $self->config()->prefix();
	my $extdir = $self->config()->extdir();
	$self->shell({silent => 0}, "echo 'extension=$_.so' > $prefix/php.d/50-extension-$_.ini") foreach (@dso_names);
	$self->shell({silent => 0}, qq!echo 'extension_dir=$prefix/$extdir' > $prefix/php.d/10-extension_dir.ini!);

}




sub create_distimage {
	my $self = shift @_;
	$self->install();
	$self->create_package();
}


sub patchfiles {
	my $self = shift @_;
#	return qw(php-entropy.patch);
	return qw(php-entropy.patch php-entropy-imap.patch);
}


# sub unpack {
#   my $self = shift @_;
#   $self->SUPER::unpack();
#   $self->cd_packagesrcdir();
#   $self->cd("ext");
#   my $mingtarball = $self->extras_path('ming.tar.gz');
#   $self->shell("tar -xzf $mingtarball");
# }



sub cflags {
	my $self = shift @_;
	my $supported_archs = join '/', $self->supported_archs();
	my $prefix = $self->config()->prefix();
	return $self->SUPER::cflags(@_) . qq( -DENTROPY_CH_ARCHS='\\"$supported_archs\\"' -DENTROPY_CH_RELEASE=) . $self->config()->release();
#-I$prefix/include
}


# sub ldflags {
# 	my $self = shift @_;
# 	return $self->SUPER::ldflags(@_) . " -Wl,-bind_at_load";
# }


sub cc {
	my $self = shift @_;
	my $prefix = $self->config()->prefix();
	
	# - the -L forces our custom iconv before the apple-supplied one
	# - the -I makes sure the libxml2 version number for phpinfo() is picked up correctly,
	#   i.e. ours and not the system-supplied libxml
	return $self->SUPER::cc(@_) . " -L$prefix/lib -I$prefix/include -I$prefix/include/libxml2 -DENTROPY_CH_RELEASE=" . $self->config()->release();
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
		lib/build
		lib/php.ini-recommended
		include/php
		php.d/10-extension_dir.ini
	);
	
}

sub package_excludelist {
	return qw(lib/php/extensions);
}





sub create_package {

	my $self = shift @_;

	$self->SUPER::create_package(@_);

	$self->create_metapackage();

}


sub create_metapackage {

	my $self = shift @_;

	$self->log("metapackaging");
	
#	my $dir = "/tmp/build-entropy-php-pkg/" . $self->shortname() . '-meta';
	my $dst = '/tmp/' . $self->mpkg_filename();

	my @sed_cmds = $self->info_substitution_sed_cmds();

	my $infofile = $self->extras_path('metapackage/Info.plist');
	$self->shell({silent => 0}, "cat $infofile @sed_cmds > $infofile.out");
	my $descfile = $self->extras_path('metapackage/Description.plist');
	$self->shell({silent => 0}, "cat $descfile @sed_cmds > $descfile.out");
	my $resdir = $self->extras_path('metapackage/resources');

	$self->shell({silent => 0}, "/Developer/Applications/Utilities/PackageMaker.app/Contents/MacOS/PackageMaker -build -mi '/tmp/build-entropy-php-pkgdst' -ds -v -r '$resdir' -i '$infofile.out' -d '$descfile.out' -p '$dst'");

	my $version = $self->config()->version() . '-' . $self->config()->release();

	my $xslt = $self->extras_path('metapackage/info-plist-postprocess.xslt');
	$self->shell({silent => 0}, "xsltproc --stringparam version $version -o $dst/Contents/Info.plist.out $xslt $dst/Contents/Info.plist && mv -f $dst/Contents/Info.plist.out $dst/Contents/Info.plist"); 

	my $variant_suffix = $self->config()->variants()->{$self->{variant}}->{suffix};
	$self->shell("cd /tmp && tar -cvzf entropy-php-$version$variant_suffix.tar.gz", $self->mpkg_filename()); 

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

	my $extdir = $self->config()->extdir();
	$self->shell("mkdir -p $pkgroot/$extdir");
	$self->shell("mkdir -p $pkgroot/php.d");

}


sub pkg_filename {
	my $self = shift @_;
	my $version = $self->config()->version() . '-' . $self->config()->release();
	return "entropy-php.pkg";
}

sub mpkg_filename {
	my $self = shift @_;
	my $version = $self->config()->version() . '-' . $self->config()->release();
	return "entropy-php.mpkg";
}









1;

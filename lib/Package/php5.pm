package Package::php5;

use strict;
use warnings;

use base qw(Package);

our $VERSION = '5.1.2';





sub base_url {
	return "http://us2.php.net/distributions";
}


sub packagename {
	return "php-$VERSION";
}


sub dependency_names {
	return qw(curl);
}



1;
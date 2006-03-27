#
# Additional PHP Apache directives,
# part of the entropy.ch PHP package for Mac OS X
# 
# For more information, go to http://www.entropy.ch/software/macosx/php/
#

LoadModule php5_module        {prefix}/libphp5.so

<IfDefine !APACHE2>
AddModule mod_php5.c
</IfDefine>


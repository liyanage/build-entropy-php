<?php

$input = "what do ya want for nothing?";
$hash = mhash(MHASH_MD5, $input);
echo "The hash is " . bin2hex($hash) . "<br />\n";
$hash = mhash(MHASH_MD5, $input, "Jefe");
echo "The hmac is " . bin2hex($hash) . "<br />\n";

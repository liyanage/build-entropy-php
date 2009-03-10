<?php

$td = mcrypt_module_open('rijndael-256', '', 'ofb', '');

/* Create the IV and determine the keysize length, use MCRYPT_RAND
 * on Windows instead */
$iv = mcrypt_create_iv(mcrypt_enc_get_iv_size($td), MCRYPT_DEV_RANDOM);
$ks = mcrypt_enc_get_key_size($td);

/* Create key */
$key = substr(md5('very secret key'), 0, $ks);

/* Intialize encryption */
mcrypt_generic_init($td, $key, $iv);

/* Encrypt data */
$encrypted = mcrypt_generic($td, 'This is very important data');

/* Terminate encryption handler */
mcrypt_generic_deinit($td);

/* Initialize encryption module for decryption */
mcrypt_generic_init($td, $key, $iv);

/* Decrypt encrypted string */
$decrypted = mdecrypt_generic($td, $encrypted);

/* Terminate decryption handle and close module */
mcrypt_generic_deinit($td);
mcrypt_module_close($td);

/* Show string */
echo trim($decrypted) . "\n";


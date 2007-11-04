/* To be appended to main/php_config.h */
/* Taken from http://archive.netbsd.se/?ml=php-dev&a=2007-07&t=4772195 */

#if (defined(__APPLE__) || defined(__APPLE_CC__)) && (defined(__BIG_ENDIAN__) || defined(__LITTLE_ENDIAN__))
# if defined(__LITTLE_ENDIAN__)
#  undef WORDS_BIGENDIAN
# else if defined(__BIG_ENDIAN__)
#  define WORDS_BIGENDIAN
# endif
#endif


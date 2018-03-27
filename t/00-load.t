#!perl -T
use 5.006;
use strict;
use warnings;
use Test::More;

plan tests => 1;

BEGIN {
    use_ok( 'CGL::Global' ) || print "Bail out!\n";
}

diag( "Testing CGL::Global $CGL::Global::VERSION, Perl $], $^X" );

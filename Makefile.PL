use 5.006;
use strict;
use warnings;
use ExtUtils::MakeMaker;

WriteMakefile(
    NAME             => 'CGL',
    AUTHOR           => q{JF Abril <jabril@ub.edu>},
    VERSION_FROM     => 'lib/CGL/Global.pm',
    ABSTRACT_FROM    => 'lib/CGL/Global.pm',
    LICENSE          => 'artistic_2',
    PL_FILES         => {},
    MIN_PERL_VERSION => '5.006',
    EXE_FILES        => ['bin/cdna2orfs', 'bin/coverage_blastshorttbl', 'bin/tbl2fa', 'bin/fa2tbl', 'bin/grepID'],
    CONFIGURE_REQUIRES => {
        'ExtUtils::MakeMaker' => '0',
    },
    BUILD_REQUIRES => {
        'Test::More' => '0',
    },
    PREREQ_PM => {
        'Inline::C'  => '0',
        'Inline::Filters' => '0',
    },
    dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
    clean => { FILES => 'CGL-*' },
);

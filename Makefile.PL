
use strict;
use warnings;

use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'MooseX-Aliases',
  NAME      => 'MooseX::Aliases',
  AUTHOR    => 'Jesse\ Luehrs\ \<doy\ at\ tozt\ dot\ net\>\,\ Chris\ Prather\ \<chris\@prather\.org\>',
  ABSTRACT  => 'easy\ aliasing\ of\ methods\ and\ attributes\ in\ Moose',
  VERSION   => '0.01',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.21) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Moose" => '0.89',
  },
);

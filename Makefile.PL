
use strict;
use warnings;



use ExtUtils::MakeMaker;

WriteMakefile(
  DISTNAME  => 'MooseX-Aliases',
  NAME      => 'MooseX::Aliases',
  AUTHOR    => "Jesse\ Luehrs\ \<doy\ at\ tozt\ dot\ net\>\,\ Chris\ Prather\ \<chris\@prather\.org\>\,\ Justin\ Hunter\ \<justin\.d\.hunter\ at\ gmail\ dot\ com\>",
  ABSTRACT  => "easy\ aliasing\ of\ methods\ and\ attributes\ in\ Moose",
  VERSION   => '0.08',
  EXE_FILES => [ qw() ],
  (eval { ExtUtils::MakeMaker->VERSION(6.31) } ? (LICENSE => 'perl') : ()),
  PREREQ_PM    => {
    "Test::Exception" => '0',
    "Moose" => '0.90',
  },
  test => {TESTS => 't/*.t'}
);


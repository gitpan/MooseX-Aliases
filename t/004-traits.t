#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 6;

my ($foo_called, $baz_called, $run_called);

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    has foo => (
        is      => 'rw',
        traits   => ['Aliased'],
        alias   => 'bar',
        trigger => sub { $foo_called++ },
    );

    has baz => (
        is      => 'rw',
        traits  => ['Aliased'],
        alias   => [qw/quux quuux/],
        trigger => sub { $baz_called++ },
    );

    sub run { $run_called++ }
    alias walk => 'run';
}

{
    my $t = MyTest->new;
    $t->foo(1);
    $t->bar(1);
    $t->baz(1);
    $t->quux(1);
    $t->quuux(1);
    $t->run;
    $t->walk;
    is($foo_called, 2, 'all aliased methods were called from foo');
    is($baz_called, 3, 'all aliased methods were called from baz');
    is($run_called, 2, 'all aliased methods were called from run');

    if (MyTest->meta->is_mutable) {
        MyTest->meta->make_immutable;
        $foo_called = 0;
        $baz_called = 0;
        $run_called = 0;
        redo;
    }
}

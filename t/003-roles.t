#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 6;

my ($foo_called, $baz_called, $run_called);

{
    package MyTestRole;
    use Moose::Role;
    use MooseX::Aliases;

SKIP: {
    ::skip q[roles don't have attribute metaclasses], 0;
    has foo => (
        is      => 'rw',
        alias   => 'bar',
        trigger => sub { $foo_called++ },
    );

    has baz => (
        is      => 'rw',
        alias   => [qw/quux quuux/],
        trigger => sub { $baz_called++ },
    );
}

    sub run { $run_called++ }
    alias walk => 'run';
}

{
    package MyTest;
    use Moose;
    with 'MyTestRole';
}

{
    my $t = MyTest->new;
    SKIP: {
        skip q[roles don't have attribute metaclasses], 2;
        $t->foo(1);
        $t->bar(1);
        $t->baz(1);
        $t->quux(1);
        $t->quuux(1);
        is($foo_called, 2, 'all aliased methods were called from foo');
        is($baz_called, 3, 'all aliased methods were called from baz');
    }
    $t->run;
    $t->walk;
    is($run_called, 2, 'all aliased methods were called from run');

    if (MyTest->meta->is_mutable) {
        MyTest->meta->make_immutable;
        $foo_called = 0;
        $baz_called = 0;
        $run_called = 0;
        redo;
    }
}

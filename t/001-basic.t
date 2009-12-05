#!/usr/bin/env perl
use strict;
use warnings;
use Test::More tests => 6;

my $called = 0;
my $subclass = 0;

{
    package MyTest;
    use Moose;
    use MooseX::Aliases;

    sub foo { $called++ }
    alias bar => 'foo';

    package MyTest::Sub;
    use Moose;

    extends qw(MyTest);

    sub foo { $subclass++ };
}

{
    my $t = MyTest->new;
    $t->foo;
    $t->bar;
    is($called, 2, 'alias calls the original method');

    my $t2 = MyTest::Sub->new;
    $t2->foo;
    $t2->bar;
    is($subclass, 2, 'subclass method called twice');
    is($called, 2, 'original method not called again');

    if (MyTest->meta->is_mutable) {
        $called = 0;
        $subclass = 0;
        MyTest->meta->make_immutable;
        MyTest::Sub->meta->make_immutable;
        redo;
    }
}

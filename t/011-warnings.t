#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;
BEGIN {
    eval "use Test::Output;";
    plan skip_all => "Test::Output is required for this test" if $@;
    plan tests => 5;
}

{
    package Foo;
    use Moose;
    use MooseX::Aliases;
    sub foo { }
    ::stderr_like { alias foo => 'bar' }
                qr/^"alias \$from => \$to" is deprecated, please use "alias \$to => \$from"/,
                "got a proper deprecation warning";
}

{
    can_ok('Foo', 'bar');
    is(Foo->meta->get_method('bar')->aliased_from, 'foo',
       "it's the right alias");

    if (Foo->meta->is_mutable) {
        Foo->meta->make_immutable;
        redo;
    }
}

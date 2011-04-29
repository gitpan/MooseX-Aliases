package MooseX::Aliases::Meta::Trait::Role::ApplicationToClass;
BEGIN {
  $MooseX::Aliases::Meta::Trait::Role::ApplicationToClass::VERSION = '0.10';
}
use Moose::Role;

around apply => sub {
    my $orig  = shift;
    my $self  = shift;
    my ($role, $class) = @_;

    $class = Moose::Util::MetaRole::apply_metaroles(
        for             => $class,
        class_metaroles => {
            ((Moose->VERSION >= 1.9900)
                ? (class =>
                       [ 'MooseX::Aliases::Meta::Trait::Class' ])
                : (constructor =>
                       [ 'MooseX::Aliases::Meta::Trait::Constructor' ])),
        }
    );

    $self->$orig( $role, $class );
};

no Moose::Role;

1;

__END__
=pod

=head1 NAME

MooseX::Aliases::Meta::Trait::Role::ApplicationToClass

=head1 VERSION

version 0.10

=head1 SEE ALSO

=over 4

=item *

L<MooseX::Aliases>

=back

=head1 AUTHORS

=over 4

=item *

Jesse Luehrs <doy at tozt dot net>

=item *

Chris Prather <chris@prather.org>

=item *

Justin Hunter <justin.d.hunter at gmail dot com>

=back

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2011 by Jesse Luehrs.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut


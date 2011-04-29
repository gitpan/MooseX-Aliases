package MooseX::Aliases::Meta::Trait::Constructor;
BEGIN {
  $MooseX::Aliases::Meta::Trait::Constructor::VERSION = '0.10';
}
use Moose::Role;
# ABSTRACT: constructor metaclass trait for L<MooseX::Aliases>


around _generate_slot_initializer => sub {
    my $orig = shift;
    my $self = shift;
    my ($index) = @_;
    my $attr = $self->_attributes->[$index];

    my $orig_source = $self->$orig(@_);
    return $orig_source
        # only run on aliased attributes
        unless $attr->meta->can('does_role')
            && $attr->meta->does_role('MooseX::Aliases::Meta::Trait::Attribute');
    return $orig_source
        # don't run if we haven't set any aliases
        # don't run if init_arg is explicitly undef
        unless $attr->has_alias && $attr->has_init_arg;

    my $init_arg = $attr->init_arg;

    my $source = '';
    $source .= 'if (my @aliases = grep { exists $params->{$_} } (qw('
             . join(' ', @{ $attr->alias }) . '))) {' . "\n";
    $source .= '    if (exists $params->{ ' . $init_arg . ' }) {' . "\n";
    $source .= '        push @aliases, \'' . $init_arg . '\';' . "\n";
    $source .= '    }' . "\n";
    $source .= '    ' . $self->_inline_throw_error(
        "'Conflicting init_args: (' . join(', ', \@aliases) . ')'"
        ) . ' if @aliases > 1;' . "\n";
    $source .= '    $params->{ ' . $init_arg . ' } = delete '
             . '$params->{ $aliases[0] };' . "\n";
    $source .= '}' . "\n";

    return $source . $orig_source;
};

no Moose::Role;

1;

__END__
=pod

=head1 NAME

MooseX::Aliases::Meta::Trait::Constructor - constructor metaclass trait for L<MooseX::Aliases>

=head1 VERSION

version 0.10

=head1 DESCRIPTION

This trait adds the handling of aliased C<init_arg>s for inlined constructors
(for immutable classes).

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


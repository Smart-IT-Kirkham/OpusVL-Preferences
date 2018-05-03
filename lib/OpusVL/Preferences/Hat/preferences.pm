package OpusVL::Preferences::Hat::preferences;

use Moose;

# ABSTRACT: Allows any FB11 component to do legacy Preferences stuff

sub schema { shift->__brain }

sub register_extension {
    my $self = shift;
    my $schema = shift;
    $self->schema->load_classes(
        ref $schema => \@_
    );
}

1;

=head1 DESCRIPTION

This Hat doesn't have an interface because it is entirely specific to this
module.

Anything using this hat is already tightly coupled to the Preferences module
and deserves everything it gets.

It exists so that those components can still actualy get at this component via
the component manager - the only level of decoupling we expect to achieve.

=head2 DEPRECATED

This module was written deprecated. New code should not be using it. New code
should make the JSON-based L<OpusVL::FB11::Parameters> module work instead, and
then use that.

=head1 METHODS

=head2 schema

The Preferences schema is the brain. The dbic_schema::is_brain hat is also worn.

=head2 register_extension

Pass another schema and all its classes are loaded into this schema.

This should only be done at Catalyst time so that we don't produce migrations
for other schemata.


package OpusVL::Preferences::Schema;

=head1 NAME

OpusVL::Preferences::Schema

=head1 SYNOPSIS

This is the DBIx::Class schema for the Preferences module.

=head1 AUTHOR

OpusVL, C<< <rich at opusvl.com> >>

=head1 LICENSE AND COPYRIGHT

Copyright 2011 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

use Moose;
use namespace::autoclean;
use OpusVL::SimpleCrypto;

extends 'DBIx::Class::Schema';

has encryption_key => (is => 'rw', isa => 'Str');
has encryption_salt => (is => 'rw', isa => 'Str');
has encryption_client => (is => 'ro', lazy => 1, builder => '_build_encryption_client');

sub _build_encryption_client
{
    my $self = shift;
    return undef unless $self->encryption_salt && $self->encryption_key;
    my $crypto = OpusVL::SimpleCrypto->new({
        key_string => $self->encryption_key,
        deterministic_salt_string => $self->encryption_salt,
    });
    return $crypto;
}


__PACKAGE__->load_namespaces;

__PACKAGE__->meta->make_immutable(inline_constructor => 0);

1;


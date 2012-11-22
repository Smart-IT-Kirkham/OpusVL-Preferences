package OpusVL::Preferences::Schema::ResultSet::PrfDefaultValues;

use Moose;
extends 'DBIx::Class::ResultSet';

sub sorted
{
    my $self = shift;
    return $self->search(undef, { order_by => ['value'] });
}

1;

=head1 NAME

OpusVL::Preferences::Schema::ResultSet::PrfDefaultValues

=head1 DESCRIPTION

=head1 METHODS

=head2 sorted

=head1 ATTRIBUTES


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

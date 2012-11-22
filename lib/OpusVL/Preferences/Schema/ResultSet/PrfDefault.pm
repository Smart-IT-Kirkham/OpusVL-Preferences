
package OpusVL::Preferences::Schema::ResultSet::PrfDefault;

use strict;
use warnings;
use Moose;

extends 'DBIx::Class::ResultSet';

sub active
{
    my $self = shift;
    return $self->search({ active => 1 }, {
        order_by => ['name'], # just ensure we always have a consistent order
    });
}

sub active_first
{
    my $self = shift;
    return $self->search(undef, {
        order_by => [ { -desc => ['active'] }, { -asc => ['name'] } ], 
    });
}


return 1;

=head1 NAME

OpusVL::Preferences::Schema::ResultSet::PrfDefault

=head1 DESCRIPTION

=head1 METHODS

=head2 active

=head2 active_first

=head1 ATTRIBUTES


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

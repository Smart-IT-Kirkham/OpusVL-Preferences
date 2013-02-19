
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
        order_by => [ { -desc => ['active'] }, { -asc => ['display_order', 'name'] } ], 
    });
}

sub not_hidden
{
    my $self = shift;
    return $self->search({ -or => [ hidden => 0, hidden => undef ] });
}

sub display_order
{
    my $self = shift;
    return $self->search(undef, { order_by => [ 'display_order' ] } );
}

sub for_report
{
    my $self = shift;
    return $self->active->not_hidden->display_order;
}

return 1;

=head1 NAME

OpusVL::Preferences::Schema::ResultSet::PrfDefault

=head1 DESCRIPTION

=head1 METHODS

=head2 active

=head2 active_first

=head2 not_hidden

=head2 display_order

Returns the preferences in the display order.

=head1 ATTRIBUTES


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

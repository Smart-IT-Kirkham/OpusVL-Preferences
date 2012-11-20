
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

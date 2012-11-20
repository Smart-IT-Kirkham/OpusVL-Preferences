package OpusVL::Preferences::Schema::ResultSet::PrfDefaultValues;

use Moose;
extends 'DBIx::Class::ResultSet';

sub sorted
{
    my $self = shift;
    return $self->search(undef, { order_by => ['value'] });
}

1;

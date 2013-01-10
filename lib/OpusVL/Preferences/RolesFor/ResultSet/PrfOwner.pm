
package OpusVL::Preferences::RolesFor::ResultSet::PrfOwner;

use strict;
use warnings;
use Moose::Role;

sub prf_get_default
{
	my $self = shift;
	my $name = shift;

	my $defaults = $self->prf_defaults;

	return
		unless defined $defaults;

	my $def = $defaults->find ({ name => $name });

	return 
		unless defined $def;

	return $def->default_value;
}

sub prf_set_default
{
	my $self  = shift;
	my $name  = shift;
	my $value = shift;
	
	$self->setup_owner_type;
	$self->prf_defaults->update_or_create
	({
		name          => $name,
		default_value => $value
	});
}

sub setup_owner_type
{
	my $self   = shift;
	my $schema = $self->result_source->schema;
	my $source = $self->result_source;

	return $schema->resultset ('PrfOwnerType')->setup_from_source ($source);
}

sub get_owner_type
{
	my $self   = shift;
	my $schema = $self->result_source->schema;
	my $source = $self->result_source;

	return $schema->resultset ('PrfOwnerType')->get_from_source ($source);
}

sub prf_defaults
{
	my $self   = shift;
	my $schema = $self->result_source->schema;
	my $type   = $self->setup_owner_type;      # we always want a result here

	return $type->prf_defaults;
}

sub with_fields
{
    my ($self, $args) = @_;

    my @params;
    my @joins;
    my $x = 1;
    for my $name (keys %$args)
    {
        my $alias = $x == 1 ? "prf_preferences" : "prf_preferences_$x";
        my $value = $args->{$name};
        push @params, {
            "$alias.name" => $name,
            "$alias.value" => $value,
        };
        push @joins, 'prf_preferences';
        $x++;
    }
    $self->search({ -and => \@params }, {
        join => { prf_owner => \@joins }
    });
}

sub validate_extra_parameters
{
    my $self = shift;
    my $params = shift;
    my $unique_validator = shift;
    my $id = shift;

    # check them against their defaults.
    my @fields = $self->prf_defaults->active;
    for my $field (@fields)
    {
        if($field->required)
        {
            return 'Must specify ' . $field->name unless exists $params->{$field->name};
        }
        if($field->unique_field)
        {
            # check to see if it's unique
            my $p = {
                prf_owner_type_id => $field->prf_owner_type_id,
            };
            $p->{id} = $id if $id;
            my $error = $unique_validator->validate('global_fields_' . $field->name, 
                                                    $params->{$field->name}, $p, 
                                                    { label => $field->comment });
            return $error if $error;
        }
        # FIXME: ought to check types.
    }
}


return 1;


=head1 NAME

OpusVL::Preferences::RolesFor::ResultSet::PrfOwner

=head1 DESCRIPTION

=head1 METHODS

=head2 prf_get_default

=head2 prf_set_default

=head2 setup_owner_type

=head2 get_owner_type

=head2 prf_defaults

=head2 with_fields

Searches the objecs with fields that match.  Pass it a hash of 
name => value pairs and it will return a resultset of all 
the owners that match all the requirements.  If you want to use 
ilikes, you can, just like regular DBIC searches.  It will figure
out the hard relationship stuff for you.

    my $rs = Owner->with_fields({ 
        'simple_test' => 'test',
        'second_test' => { -ilike => 'test2' },
    });

=head2 validate_extra_parameters

=head1 ATTRIBUTES


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

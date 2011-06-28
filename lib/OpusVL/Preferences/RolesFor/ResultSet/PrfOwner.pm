
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

return 1;


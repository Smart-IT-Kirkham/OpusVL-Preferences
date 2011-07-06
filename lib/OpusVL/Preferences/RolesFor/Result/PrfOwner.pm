
package OpusVL::Preferences::RolesFor::Result::PrfOwner;

use strict;
use warnings;
use Moose::Role;

sub prf_owner_init
{
	my $class = shift;

	$class->add_columns
	(
		prf_owner_type_id =>
		{
			data_type      => 'integer',
			is_nullable    => 1,
			is_foreign_key => 1
		}
	);

	$class->belongs_to
	(
		prf_owner => 'OpusVL::Preferences::Schema::Result::PrfOwner',
		{
			'foreign.prf_owner_id'      => 'self.id',
			'foreign.prf_owner_type_id' => 'self.prf_owner_type_id'
		}
	);

	$class->belongs_to
	(
		prf_owner_type => 'OpusVL::Preferences::Schema::Result::PrfOwnerType',
		{
			'foreign.prf_owner_type_id' => 'self.prf_owner_type_id'
		}
	);
}

after insert => sub
{
	my $self   = shift;
	my $schema = $self->result_source->schema;
	my $type   = $schema->resultset ('PrfOwnerType')->setup_from_source ($self->result_source);

	$schema->resultset ('PrfOwner')->create
	({
		prf_owner_id      => $self->id,
		prf_owner_type_id => $type->prf_owner_type_id
	});
	
	$self->update ({ prf_owner_type_id => $type->prf_owner_type_id });
};

sub prf_defaults
{
	my $self = shift;

	return $self->prf_owner_type->prf_defaults;
}

sub prf_preferences
{
	# this could maybe be achieved with a proper DBIx::Class relationship, but
	# this will do for now

	my $self = shift;

	return $self->prf_owner->prf_preferences;
}

sub prf_get
{
	my $self = shift;
	my $name = shift;
	my $pref = $self->prf_preferences->search ({ name => $name })->first;

	return $pref->value
		if defined $pref;

	my $default = $self->prf_defaults->search ({ name => $name })->first;

	return $default->default_value
		if defined $default;

	return;
}

sub prf_set
{
	my $self     = shift;
	my $prefname = shift;
	my $value    = shift;

	my $allprefs = $self->prf_preferences;
	
	my $pref = $allprefs->search ({ name => $prefname })->first;

	if ($pref)
	{
		$pref->update ({ value => $value });
	}
	else
	{
		$allprefs->create
		({
			name  => $prefname,
			value => $value
		});
	}
}

sub prf_reset
{
	my $self = shift;
	my $name = shift;

	$self->prf_preferences->search ({ name => $name })->delete;
}

return 1;


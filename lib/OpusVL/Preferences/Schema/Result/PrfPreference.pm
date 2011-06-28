
package OpusVL::Preferences::Schema::Result::PrfPreference;

use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->table("prf_preferences");

__PACKAGE__->add_columns
(
	prf_preference_id =>
	{
		data_type   => "integer",
		is_nullable => 0,
		is_auto_increment => 1
	},

	prf_owner_id =>
	{
		data_type   => 'integer',
		is_nullable => 0
	},

	prf_owner_type_id =>
	{
		data_type   => "integer",
		is_nullable => 0,
	},

	name =>
	{
		data_type   => 'varchar',
		is_nullable => 0
	},

	value =>
	{
		data_type   => 'varchar',
		is_nullable => 1
	},
);

__PACKAGE__->set_primary_key("prf_preference_id");

__PACKAGE__->belongs_to
(
	prf_owner => 'OpusVL::Preferences::Schema::Result::PrfOwner',
	{
		'foreign.prf_owner_id'      => 'self.prf_owner_id',
		'foreign.prf_owner_type_id' => 'self.prf_owner_type_id'
	}
);

return 1;


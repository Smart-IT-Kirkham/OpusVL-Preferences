
package OpusVL::Preferences::Schema::Result::PrfOwner;

use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->table("prf_owners");

__PACKAGE__->add_columns
(
	prf_owner_id =>
	{
		data_type   => "integer",
		is_nullable => 0
	},

	prf_owner_type_id =>
	{
		data_type   => "integer",
		is_nullable => 0,
	},
);

__PACKAGE__->set_primary_key("prf_owner_id", "prf_owner_type_id");


__PACKAGE__->has_many
(
	prf_preferences => "OpusVL::Preferences::Schema::Result::PrfPreference",
	{
		"foreign.prf_owner_id"      => "self.prf_owner_id",
		"foreign.prf_owner_type_id" => "self.prf_owner_type_id",
	},
);

__PACKAGE__->belongs_to
(
	prf_owner_types => 'OpusVL::Preferences::Schema::Result::PrfOwnerType',
	{
		'foreign.prf_owner_type_id' => 'self.prf_owner_type_id'
	}
);

return 1;


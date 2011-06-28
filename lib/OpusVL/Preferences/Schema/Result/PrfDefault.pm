
package OpusVL::Preferences::Schema::Result::PrfDefault;

use strict;
use warnings;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;

extends 'DBIx::Class::Core';

__PACKAGE__->table("prf_defaults");

__PACKAGE__->add_columns
(
	prf_owner_type_id =>
	{
		data_type   => "integer",
		is_nullable => 0,
	},

	name =>
	{
		data_type   => "varchar",
		is_nullable => 0,
	},

	default_value =>
	{
		data_type   => "varchar",
		is_nullable => 0,
	},

	data_type =>
	{
		data_type   => 'varchar',
		is_nullable => 1
	},

	comment =>
	{
		data_type   => 'varchar',
		is_nullable => 1
	},
);

__PACKAGE__->set_primary_key(qw/prf_owner_type_id name/);

return 1;

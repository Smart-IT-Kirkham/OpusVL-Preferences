package OpusVL::Preferences::Schema::Result::PrfDefaultValues;

use 5.010;
use Moose;
use MooseX::NonMoose;
use namespace::autoclean;
extends 'DBIx::Class::Core';

__PACKAGE__->table('prf_default_values');

__PACKAGE__->add_columns(
    'id' => {
        data_type         => "serial",
        is_auto_increment => 1,
        is_nullable       => 0,
    },
    'value' => {
        data_type   => 'text',
        is_nullable => 1,
    },
    'prf_owner_type_id' => {
        data_type => 'integer',
        is_nullable => 0,
    },
	name => {
		data_type   => "varchar",
		is_nullable => 0,
    },
);

__PACKAGE__->set_primary_key("id");

__PACKAGE__->belongs_to(
    'field' => 'OpusVL::Preferences::Schema::Result::PrfDefault',
    {
		"foreign.name"      => "self.name",
		"foreign.prf_owner_type_id" => "self.prf_owner_type_id",
    }
);

__PACKAGE__->meta->make_immutable();


1;



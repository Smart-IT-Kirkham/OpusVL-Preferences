
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

    required =>
    {
        data_type => 'boolean',
        is_nullable => 1,
        default_value => 0,
    },
    active => 
    {
        data_type => 'boolean',
        is_nullable => 1,
        default_value => 1,
    },
    hidden => 
    {
        data_type => 'boolean',
        is_nullable => 1,
    },
    display_on_search => 
    {
        data_type => 'boolean',
        is_nullable => 1,
    },
    # note: this isn't stricly enforced by the module.
    # NOTE: might need to switch this to validator class
    unique_field => 
    {
        data_type => 'boolean',
        is_nullable => 1,
    },
    ajax_validate => 
    {
        data_type => 'boolean',
        is_nullable => 1,
    },

    display_order => 
    {
        data_type => 'int',
        is_nullable => 0,
        default_value => 1,
    },
    confirmation_required =>
    {
        data_type => 'boolean',
        is_nullable => 1,
    },
);

__PACKAGE__->set_primary_key(qw/prf_owner_type_id name/);
__PACKAGE__->has_many
(
	values => "OpusVL::Preferences::Schema::Result::PrfDefaultValues",
	{
		"foreign.name"      => "self.name",
		"foreign.prf_owner_type_id" => "self.prf_owner_type_id",
	},
);

__PACKAGE__->has_many
(
	preferences => "OpusVL::Preferences::Schema::Result::PrfPreference",
	{
		"foreign.name"      => "self.name",
		"foreign.prf_owner_type_id" => "self.prf_owner_type_id",
	},
);


__PACKAGE__->belongs_to
(
	owner_type => 'OpusVL::Preferences::Schema::Result::PrfOwnerType',
	{
		'foreign.prf_owner_type_id' => 'self.prf_owner_type_id'
	}
);

sub form_options
{
    my $self = shift;
    my @options = map { [ $_->value, $_->value ] } $self->values->sorted;
    return \@options;
}

sub hash_key
{
    my $self = shift;
    return $self->name;
}

around update => sub {
    my $orig = shift;
    my $self = shift;
    my $update = shift;
    $update  //= {};
    $self->set_inflated_columns($update);

    my $schema = $self->result_source->schema;
    my $txn = $schema->txn_scope_guard;
    my %updated_columns = ($self->get_dirty_columns);
    $self->$orig;
    if(exists $updated_columns{unique_field})
    {
        my $obj_rs = $schema->resultset($self->owner_type->owner_resultset);
        if($self->unique_field)
        {
            # create the unique values
            my $rs = $obj_rs;
            if($obj_rs->can('active_for_unique_params'))
            {
                $rs = $obj_rs->active_for_unique_params;
            }
            my $params = $rs->search_related('prf_owner')->search_related('prf_preferences', 
                { 
                    "prf_preferences.name" => $self->name, 
                }
            );
            # this kind of sucks, it would be a lot neater to do an insert based on the query.
            # perhaps I could do a select and get the query then do the insert simply?
            map { $_->create_related('unique_value', { value => $_->value }) } $params->all;
        }
        else
        {
            # wipe them out.
            $self->preferences->search_related('unique_value')->delete;
        }
    }
    $txn->commit;
};
return 1;

=head1 NAME

OpusVL::Preferences::Schema::Result::PrfDefault

=head1 DESCRIPTION

=head1 METHODS

=head2 form_options

=head1 ATTRIBUTES

=head2 values

=head2 prf_owner_type_id

=head2 name

=head2 default_value

=head2 data_type

=head2 comment

=head2 required

=head2 active

=head2 hidden

=head2 hash_key

Returns a string convenient for use in hashes based on the parameter name.

=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut

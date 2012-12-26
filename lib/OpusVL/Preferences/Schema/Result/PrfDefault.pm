
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
    # note: this isn't stricly enforced by the module.
    unique_field => 
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

sub form_options
{
    my $self = shift;
    my @options = map { [ $_->value, $_->value ] } $self->values->sorted;
    return \@options;
}


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


=head1 LICENSE AND COPYRIGHT

Copyright 2012 OpusVL.

This software is licensed according to the "IP Assignment Schedule" provided with the development project.

=cut
